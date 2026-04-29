local frpc_client = require "skynet-fly.client.frpc_client"
local log = require "skynet-fly.log"

local table = table
local sbyte = string.byte

local M = {}

--注册
function M.register(account_info, channel) 
    local cli = frpc_client:instance(frpc_client.FRPC_MODE.one, "centerserver", "account_m")
    cli:set_mod_num(sbyte(account_info.account, account_info.account:len()))
    local ret, err, errcode = cli:mod_call("register", account_info, channel)
    if not ret then 
        log.error("注册 出错 >>> ", err, errcode)
        return
    end

    return ret:unpack()
end

--认证登录 
function M.auth(account, password)
    local cli = frpc_client:instance(frpc_client.FRPC_MODE.one, "centerserver", "account_m")
    cli:set_mod_num(sbyte(account, account:len()))
    local ret, err, errcode = cli:mod_call("auth", account, password)
    if not ret then 
        log.error("认证登录 出错 >>> ", err, errcode)
        return
    end
    return ret:unpack()
end

return M
