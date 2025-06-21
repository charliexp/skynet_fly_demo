
local player_logic = hotfix_require "hall.player.player_logic"
local log = require "skynet-fly.log"
local skynet = require "skynet"

local PACK = require "common.pack_helper".PACK
local ID = require "common.pack_helper".ID

local M = {}

function M.init(interface_mgr)
    skynet.fork(function()
        while true do
            skynet.sleep(60 * 10 * 100) --10分钟检测一次
            player_logic.check_heart()
        end
    end)
    player_logic.init(interface_mgr)
end

function M.on_login(player_id)
    player_logic.on_login(player_id)
end

function M.on_loginout(player_id)
    player_logic.on_loginout(player_id)
end

function M.on_reconnect(player_id)
    player_logic.on_reconnect(player_id)
end

--消息前置处理
function M.on_msg_before(player_id, pack_id, pack_body)
    --log.info("on_msg_before >>> ", player_id, pack_id)
    return true
end

--消息指定主码前置处理
M.on_msg_before_id = {
    [ID.hallserver_player] = function(player_id, pack_id, pack_body)
        --log.info("on_msg_before hallserver_player >>> ", player_id, pack_id)
        return true
    end
}

M.handle = {
    --心跳
    [PACK.login.HeartReq] = function(player_id, pack_id, pack_body)
       return player_logic.do_heart(player_id, pack_body)
    end,
    --请求修改昵称
    [PACK.hallserver_player.ReqChangeNickName] = function(player_id, pack_id, pack_body)
        return player_logic.do_change_nickname(player_id, pack_body)
    end
}

--开关忽略
M.switch_ignores = {
    [PACK.login.HeartReq] = true,
}

local CMD = {}

--获取玩家信息
function CMD.player_get_info(_, player_id, field_map)
    return player_logic.cmd_get_info(player_id, field_map)
end

--获取所有在线玩家ID
function CMD.get_all_online()
    return player_logic.cmd_get_all_online()
end

--批量获取玩家字段信息
function CMD.player_get_players_info(_, player_list, field_map)
    return player_logic.cmd_get_players_info(player_list, field_map)
end

--改变玩家段位积分
function CMD.player_change_rank_score(player_id, score)
    return player_logic.cmd_change_rank_score(player_id, score)
end

M.register_cmd = CMD

local gmCMD = {
    ['player:info'] = {
        func = function(...)
            return player_logic.gm_info(...)
        end,
        help_des = "查询玩家信息 arg1=player_id"
    },
}

M.gm_cmd = gmCMD

return M