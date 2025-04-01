local skynet = require "skynet"
local SEAT_STATE = require "enum.SEAT_STATE"
local ws_pbnet_util = require "skynet-fly.utils.net.ws_pbnet_util"
local log = require "skynet-fly.log"
local player = require "common.rpc.hallserver.player"
local item = require "common.rpc.hallserver.item"
local timer = require "skynet-fly.timer"
local chess_conf = hotfix_require "common.conf.chess_conf"
local ITEM_CHANGE_SOURCE = hotfix_require "common.enum.ITEM_CHANGE_SOURCE"

local setmetatable = setmetatable
local assert = assert

local M = {}

local meta = {__index = M}

function M:new()
	local t = {
		player = nil,
		state = SEAT_STATE.empty,
		team_type = 0,
	}

	setmetatable(t,meta)
	return t
end

--坐下
function M:enter(player_id, seat_id)
	self.player = player.get_player_info(player_id)
	self.score = self.player.rank_score
	self.seat_id = seat_id
	
	if not self.player or not self.score then
		return false
	end

	self.rank_level = chess_conf.get_rank_level(self.score)
	self.state = SEAT_STATE.waitting
	return true
end

--离开
function M:leave()
	self.player = nil
	self.state = SEAT_STATE.empty
end

--是否空座位
function M:is_empty()
	return self.state == SEAT_STATE.empty
end

--是否可以离开
function M:is_can_leave()
	return self.state ~= SEAT_STATE.playing
end

--获取玩家信息
function M:get_player()
	return self.player
end

--游戏开始
function M:game_start()
	self.state = SEAT_STATE.playing
end

--游戏结束
function M:game_over()
	self.state = SEAT_STATE.waitting
end

--设置队伍类型
function M:set_team_type(team_type)
	self.team_type = team_type
end

--返回队伍类型
function M:get_team_type()
	return self.team_type
end

--获取分数
function M:get_score()
	return self.score
end

--获取段位等级
function M:get_rank_level()
	return self.rank_level
end

--增加积分
function M:add_score(num)
	if num <= 0 then return 0 end
	local player_id = self.player.player_id
	self.score = player.change_rank_score(player_id, num)
	
	return num
end

--减少积分
function M:reduce_score(num)
	if num <= 0 then return 0 end
	local player_id = self.player.player_id
	self.score = player.change_rank_score(player_id, -num)

	return num
end

--获得奖励
function M:add_item_map(item_map)
	local player_id = self.player.player_id
	return item.add_item_map(player_id, item_map, ITEM_CHANGE_SOURCE.CHESS_CONCLUDE_REWARD)
end

--设置操作,总时长,单次时长
function M:set_doing_time(total_time, one_time)
	self.remain_total_time = total_time * timer.second
	self.once_time = one_time * timer.second
end

--开始操作
function M:start_doing(time_out_callback, ...)
	if self.remain_total_time > self.once_time then
		self.time_obj = timer:new(self.once_time, 1, time_out_callback, ...)
	else
		self.time_obj = timer:new(self.remain_total_time, 1, time_out_callback, ...)
	end
end

--获取操作剩余时间
function M:get_doing_time()
	local remain_total_time = self.remain_total_time
	local remain_once_time = self.once_time
	if self.time_obj then
		remain_once_time = self.time_obj:remain_expire()
		remain_total_time = remain_total_time - self.once_time + remain_once_time
	end

	return remain_total_time, remain_once_time
end

--操作结束
function M:doing_end()
	if not self.time_obj then return end
	local remain_once_time = self.time_obj:remain_expire()
	self.remain_total_time = self.remain_total_time - self.once_time + remain_once_time
	if self.remain_total_time < 0 then
		self.remain_total_time = 0
	end
	self.time_obj:cancel()
	self.time_obj = nil
end

--获取座位号
function M:get_seat_id()
	return self.seat_id
end

return M