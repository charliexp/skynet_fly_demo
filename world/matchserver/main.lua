local skynet = require "skynet"
local contriner_launcher = require "skynet-fly.contriner.contriner_launcher"
local log = require "skynet-fly.log"
local sharedata = require "skynet-fly.sharedata"

skynet.start(function()
	skynet.call('.logger','lua','add_hook','common.log_hook')
	skynet.error("start matchserver>>>>>>>>>>>>>>>>>")
	contriner_launcher.run()
	--启动集群连接入口
	skynet.uniqueservice("frpc_server")
	skynet.exit()
end)