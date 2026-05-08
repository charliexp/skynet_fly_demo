local frpc_client = require "skynet-fly.client.frpc_client"
local log = require "skynet-fly.log"

local M = {}

--匹配
function M.match(game_server, player_id, play_type)
    local ret, errno, errmsg = frpc_client:instance(frpc_client.FRPC_MODE.one, "matchserver", "match_m", game_server):
    balance_call_by_name("match", player_id, play_type)
    if not ret then 
        log.error("match err ", errno, errmsg)
        return
    end
    
    return ret:unpack()
end

--取消匹配
function M.cancel_match(game_server, player_id, play_type)
    local ret, errno, errmsg = frpc_client:instance(frpc_client.FRPC_MODE.one, "matchserver", "match_m", game_server)
    :balance_call_by_name("cancel_match", player_id, play_type)
    if not ret then 
        log.error("cancel_match err ", errno, errmsg)
        return
    end
    
    return ret:unpack()
end

--接受对局
function M.accept_session(game_server, player_id, session_id)
    local ret, errno, errmsg = frpc_client:instance(frpc_client.FRPC_MODE.one, "matchserver", "match_m", game_server)
    :balance_call_by_name("accept_session", player_id, session_id)
    if not ret then 
        log.error("accept_session err ", errno, errmsg)
        return 
    end

    return ret:unpack()
end

return M