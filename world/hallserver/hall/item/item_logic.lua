local log = require "skynet-fly.log"
local time_util = require "skynet-fly.utils.time_util"
local item_msg = hotfix_require "msg.item_msg"
local orm_table_client = require "skynet-fly.client.orm_table_client"
local state_data = require "skynet-fly.hotfix.state_data"
local event_mgr = require "common.event_mgr"
local EVENT_ID = hotfix_require "enum.EVENT_ID"
local interface = require "hall.item.interface"
local table_util = require "skynet-fly.utils.table_util"
local item_conf = hotfix_require "common.conf.item_conf"
local log_helper = require "common.log_helper"

local assert = assert
local tinsert = table.insert
local pairs = pairs
local next = next
local type = type

local g_item_entity = orm_table_client:instance("item")

local g_local_info = state_data.alloc_table("g_local_info")

local function hotfix_init()
    g_local_info.item_change_log = log_helper:new_user_log('item_change_log')
    :int64("player_id")         --玩家ID
    :int64("item_id")           --道具ID
    :int64("change_num")        --改变值
    :int64("cur_num")           --目前值
    :uint32("source")           --变更来源
    :set_index("item_index", "item_id", "change_num")
    :set_index("player_index", "player_id")
    :builder()

    event_mgr.monitor(EVENT_ID.ITEM_CHANGE, function(player_id, id, num, count, source)
        g_local_info.item_change_log:write_log({
            player_id = player_id,
            item_id = id,
            change_num = num,
            cur_num = count,
            source = source or 0,
        })
    end)
end

local M = {}
function M.init(interface_mgr)
    g_local_info.item_msg = item_msg:new(interface_mgr)
    hotfix_init()
end

function M.hotfix()
    hotfix_init()
    --道具改变日志
end

---------------------------其他逻辑------------------------------------
local function player_item_notice(player_id)
    local item_list = g_item_entity:get_entry(player_id)
    g_local_info.item_msg:item_list_notice(player_id, {
        item_list = item_list,
    })
end
---------------------------客户端事件----------------------------------
--登录
function M.on_login(player_id)
    player_item_notice(player_id)
end

--登出
function M.on_loginout(player_id)

end

--重连
function M.on_reconnect(player_id)
    player_item_notice(player_id)
end

---------------------------客户端消息处理-------------------------------


---------------------------CMD-----------------------------------------
--查询道具
function M.cmd_get_item(player_id, id)
    local item_cfg = item_conf.get_item_info(id)
    assert(item_cfg, "not item_cfg " .. id)
    return g_item_entity:get_item(player_id, id)
end

--增加道具
function M.cmd_add_item(player_id, id, num, source)
    local item_cfg = item_conf.get_item_info(id)
    assert(item_cfg, "not item_cfg " .. id)
    local count = g_item_entity:add_item(player_id, id, num)
    if not count then
        return nil
    end

    local item_list = {{id = id, count = count}}
    --同步到客户端
    g_local_info.item_msg:item_list_notice(player_id, {
        item_list = item_list
    })

    event_mgr.publish(EVENT_ID.ITEM_CHANGE, player_id, id, num, count, source)
    return count
end

--减少道具
function M.cmd_reduce_item(player_id, id, num, source)
    local item_cfg = item_conf.get_item_info(id)
    assert(item_cfg, "not item_cfg " .. id)
    local ret,count = g_item_entity:reduce_item(player_id, id, num)
    if not ret then
        return ret,count
    end

    --同步到客户端
    g_local_info.item_msg:item_list_notice(player_id, {
        item_list = {{id = id, count = count}}
    })
    event_mgr.publish(EVENT_ID.ITEM_CHANGE, player_id, id, -num, count, source)

    return ret,count
end

--批量查询道具
function M.cmd_get_item_map(player_id, id_list)
    return g_item_entity:get_item_map(player_id, id_list)
end

--批量增加道具
function M.cmd_add_item_map(player_id, item_map, source)
    if not next(item_map) then return item_map end
    for id, count in pairs(item_map) do
        local item_cfg = item_conf.get_item_info(id)
        assert(item_cfg, "not item_cfg " .. id)
        assert(count >= 0, "count err " .. count)
    end

    local ret_map = g_item_entity:add_item_map(player_id, item_map)
    local item_list = {}
    for id, count in pairs(ret_map) do
        tinsert(item_list, {id = id, count = count})
        local num = item_map[id]
        event_mgr.publish(EVENT_ID.ITEM_CHANGE, player_id, id, num, count, source)
    end
    g_local_info.item_msg:item_list_notice(player_id, {item_list = item_list})

    return ret_map
end

--批量增加道具
function M.cmd_add_item_list(player_id, item_list, source)
    if not next(item_list) then return item_list end
    
    local item_map = {}
    for i = 1, #item_list do
        local one_item = item_list[i]
        local id = one_item.id
        local count = one_item.count
        local item_cfg = item_conf.get_item_info(id)
        assert(item_cfg, "not item_cfg " .. id)
        assert(count >= 0, "count err " .. count)
        if not item_map[id] then
            item_map[id] = 0
        end
        item_map[id] = item_map[id] + count
    end

    local ret_map = g_item_entity:add_item_map(player_id, item_map)
    local item_list = {}
    for id, count in pairs(ret_map) do
        tinsert(item_list, {id = id, count = count})
        local num = item_map[id]
        event_mgr.publish(EVENT_ID.ITEM_CHANGE, player_id, id, num, count, source)
    end
    g_local_info.item_msg:item_list_notice(player_id, {item_list = item_list})

    return ret_map
end

-----------------------------interface------------------------------------
--查询道具
function interface.get_item(player_id, id)
    return M.cmd_get_item(player_id, id)
end

--增加道具
function interface.add_item(player_id, id, num, source)
    return M.cmd_add_item(player_id, id, num, source)
end

--减少道具
function interface.reduce_item(player_id, id, num, source)
    return M.cmd_reduce_item(player_id, id, num, source)
end

--批量增加道具
function interface.add_item_map(player_id, item_map, source)
    return M.cmd_add_item_map(player_id, item_map, source)
end

--批量增加道具
function interface.add_item_list(player_id, item_list, source)
    return M.cmd_add_item_list(player_id, item_list, source)
end

--道具转换
function interface.convert_item_list(items)
    local item_list = nil
    --适配items的模式
    if items and next(items) then
        local v = nil
        for k,vv in pairs(items) do         --next 对应sharedata数据 会返回 c confctrl 还是用pairs去取一个数据吧
            v = vv
            break
        end
        --[id] = num 模式
        local vt = type(v)
        if vt == 'number' then
            item_list = {}
            for id, count in pairs(items) do
                tinsert(item_list, {id = id, count = count})
            end
        else
            if v.id then
                item_list = items
            else
                item_list = {}
                --{{id,count},{id,count}}
                for i = 1, #items do
                    tinsert(item_list, {id = items[i][1], count = items[i][2]})
                end
            end
        end
    end

    return item_list
end

return M