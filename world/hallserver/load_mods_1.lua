local server_cfg = loadfile("../../commonlualib/common/etc/server_cfg.lua")()
local redis_cfg = loadfile("../../commonlualib/common/etc/redis_cfg.lua")()
local frpc_server_cfg = loadfile("../../commonlualib/common/etc/frpc_server_cfg.lua")()
local gate_cfg = loadfile("../../commonlualib/common/etc/gate_cfg.lua")()
local mysql_cfg = loadfile("../../commonlualib/common/etc/mysql_cfg.lua")()

return {
        --共享配置
	share_config_m = {
		launch_seq = 1000,     --启动顺序，从小到大
		launch_num = 1,     --启动数量
		default_arg = {     --默认配置
			redis = {
				--rpc连接配置
				rpc = redis_cfg.rpc,

				--全服共用的redis
				global = redis_cfg.global,
			},

			mysql = {
				orm_db = mysql_cfg.world.hallserver_1,
			},
			--cluster_server用的配置
			frpc_server = frpc_server_cfg.world.hallserver_1,

			server_cfg = server_cfg.world.hallserver_1,

            --room_game_login用的配置
			room_game_login = {
				--wsgate连接配置
				wsgateconf = gate_cfg.world.hallserver_1,
				login_plug = "common.plug.login_plug",  --login加载的插件lua模块文件名
			},
		}
	},

    --debug入口
	debug_console_m = {
		launch_seq = 2000,
		launch_num = 1,
	},
    --日志切割
	logrotate_m = {
        launch_seq = 1,
        launch_num = 1,
        default_arg = {
            file_path = server_cfg.world.hallserver_1.logpath,          --文件路径
            filename = 'server.log',   --文件名
            limit_size = 0,            --最小分割大小
            max_age = 7,               --最大保留天数
            max_backups = 7,           --最大保留文件数
            sys_cmd = [[
                /usr/bin/pkill -HUP -f skynet.make/hallserver_config.lua.load_mods_1.lua\n
            ]],              --系统命令
        }
    },

	--集群客户端
    frpc_client_m = {
		launch_seq = 5000,
		launch_num = 1,
		default_arg = {
			node_map = {
				['centerserver'] = true,    --中心服
				['matchserver'] = true,     --匹配服
				['hallserver'] = true,      --大厅服
				['chinese_chess'] = true,   --象棋服
				['digitalbomb'] = true,     --数字炸弹服
			},
			watch = 'redis',  --监听redis的方式做服务发现
		}
	},

	--token
	token_m = {
		launch_seq = 5500,
		launch_num = 1,
	},

	-- orm
	orm_table_m = {
		launch_seq = 5600,
		launch_num = 7,
		mod_args = {
            {instance_name = "player", orm_plug = "orm_entity.player_entity"},
			{instance_name = "item", orm_plug = "orm_entity.item_entity"},
			{instance_name = "game_record", orm_plug = "orm_entity.game_record_entity"},
			{instance_name = "friend", orm_plug = "orm_entity.friend_entity"},
			{instance_name = "friend_req", orm_plug = "orm_entity.friend_req_entity"},
			{instance_name = "email", orm_plug = "orm_entity.email_entity"},
			{instance_name = "misc", orm_plug = "orm_entity.misc_entity"},
		}
	},

    player_m = {
        launch_seq = 5700,
        launch_num = 6,
    },

    --大厅服
	room_game_hall_m = {
		launch_seq = 6000,
		launch_num = 6,     --启动6个
		is_record_on = 1,   --录像

		--自动定时热更 skynet-fly.time_extend.time_point.lua 的配置项
		auto_reload = {
			type = 3,    --每天
			hour = 5,    --5点
			min = 30,    --30分
			sec = 30,    --30秒
		},

		--录像文件自动整理
		--需要启动logrotate_m
		record_backup = {
			max_age = 3,      --最大保留天数
			max_backups = 50, --最大保留文件数
			point_type = 3,   --每天
			hour = 5,         --5点
			sec = 20,         --20
		},

		default_arg = {
			hall_plug = "common.plug.hall_plug",         --大厅加载的插件lua模块文件名
		}
	},

    --匹配服
	room_game_alloc_m = {
		launch_seq = 6100,
		launch_num = 1, --启动1个
		default_arg = {
			alloc_plug = "alloc.alloc_plug",       --匹配加载的插件lua模块文件名
			MAX_TABLES = 10000,  --最多1万个游戏桌子
		}
	},

	--房间服
	room_game_table_m = {
		launch_seq = 6200,
		launch_num = 1,
		default_arg = {
			table_plug = "table.table_plug",   --房间插件
			instance_name = "default",
			table_conf = {}
		}
	},
}