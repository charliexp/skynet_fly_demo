local server_cfg = loadfile("../../commonlualib/common/etc/server_cfg.lua")()
local gate_cfg = loadfile("../../commonlualib/common/etc/gate_cfg.lua")()
local frpc_server_cfg = loadfile("../../commonlualib/common/etc/frpc_server_cfg.lua")()
local cfg = loadfile('load_mods_1.lua')()

cfg.share_config_m.default_arg.frpc_server = frpc_server_cfg.games.digitalbomb_2
cfg.share_config_m.default_arg.server_cfg = server_cfg.games.digitalbomb_2
cfg.share_config_m.default_arg.room_game_login.wsgateconf = gate_cfg.games.digitalbomb_2

cfg.logrotate_m.default_arg.file_path = server_cfg.games.digitalbomb_2.logpath
cfg.logrotate_m.default_arg.sys_cmd = [[
	/usr/bin/pkill -HUP -f skynet.make/digitalbomb_config.lua.load_mods_2.lua\n
]]

return cfg