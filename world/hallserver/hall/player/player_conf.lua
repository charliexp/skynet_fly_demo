local skynet = require "skynet"
local sharedata = require "skynet-fly.sharedata"
local log = require "skynet-fly.log"

local assert = assert

local g_player_level = nil

local g_max_level = 0

local function init()
    g_player_level = sharedata:new("../../commonlualib/data_tables/player_level.lua", sharedata.enum.sharedata)
                       :set_map("level_idx", "level")
                       :builder()

    local level_idx_map = g_player_level:get_map("level_idx")
    for level in pairs(level_idx_map) do
        if level > g_max_level then
            g_max_level = level
        end
    end
end

skynet.init(init)

local M = {}

function M.hotfix()
    init()
end

--获取等级需要经验值
function M.get_level_exp(level)
    local level_idx_map = g_player_level:get_map("level_idx")
    local cfg = level_idx_map[level]
    assert(cfg, "level not exists cfg " .. level)

    return cfg.exp
end

--获取当前经验值能升到的等级
function M.get_curexp_uplevel(level, exp)
    local level_idx_map = g_player_level:get_map("level_idx")
    local need_exp = 0
    local next_level = level
    for i = level, g_max_level do
        local cfg = level_idx_map[i]
        if cfg.exp + need_exp > exp then
            break
        end
        
        need_exp = need_exp + cfg.exp
        next_level = i
    end

    return next_level, need_exp
end

return M