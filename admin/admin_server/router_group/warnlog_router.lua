local rsp_body = require "rsp_body"
local cluster_client = require "cluster_client"
local log = require "log"

local assert = assert
local tonumber = tonumber

return function(group)
    group:get('/info',function(c)
        local query = c.req.query
        local pre_day = assert(query.pre_day,"not pre_day")                 --前几天
        pre_day = tonumber(pre_day)
        local instance = cluster_client:instance("logserver","warn_m"):set_svr_id(1)
        local ret = instance:byid_mod_call('read', pre_day)
        local context = ret.result
        log.info("warnlog_router:", context)
        local result = nil
        if context then
            result = "OK"
            context = context[1]
        else
            context = "无"
        end
        rsp_body.set_rsp(c,{
            result = result,
            context = context
        })
    end)
end