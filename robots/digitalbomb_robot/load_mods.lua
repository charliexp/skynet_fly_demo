local redis_cfg = loadfile("../../commonlualib/common/etc/redis_cfg.lua")()
local server_cfg = loadfile("../../commonlualib/common/etc/server_cfg.lua")()
local frpc_server_cfg = loadfile("../../commonlualib/common/etc/frpc_server_cfg.lua")()

return {
	--共享配置
	share_config_m = {
		launch_seq = 2,     --启动顺序，从小到大
		launch_num = 1,     --启动数量
		default_arg = {     --默认配置
			redis = {
				--rpc连接配置
				rpc = redis_cfg.rpc,
				--全服共用的redis
				global = redis_cfg.global,
			},

			--cluster_server用的配置
			frpc_server = frpc_server_cfg.robots.digitalbomb_robot,

			server_cfg = server_cfg.robots.digitalbomb_robot,
		}
	},

	--日志切割
	logrotate_m = {
        launch_seq = 1,
        launch_num = 1,
        default_arg = {
            file_path = server_cfg.robots.digitalbomb_robot.logpath,          --文件路径
            filename = 'server.log',   --文件名
            limit_size = 0,            --最小分割大小
            max_age = 2,               --最大保留天数
            max_backups = 7,           --最大保留文件数
            sys_cmd = [[
                /usr/bin/pkill -HUP -f skynet.make/digitalbomb_robot_config.lua\n
            ]],              --系统命令
        }
    },

	--debug入口
	debug_console_m = {
		launch_seq = 3,
		launch_num = 1,
	},

	--机器人启动管理
	robot_launch_m = {
		launch_seq = 5,
		launch_num = 1,
		default_arg = {
			robot_num = 2500,    --启动机器人数量
		}
	},

	--机器人逻辑
	robot_m = {
		launch_seq = 6,
		launch_num = 20,
		default_arg = {
			game_name = "digitalbomb",
		}
	}
}