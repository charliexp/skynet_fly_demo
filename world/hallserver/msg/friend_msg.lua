local setmetatable = setmetatable

local PACK = require "common.pack_helper".PACK

local M = {}
local meta = {__index = M}

function M:new(interface_mgr)
	local t = {
		interface_mgr = interface_mgr
	}
	setmetatable(t,meta)
	return t
end

--好友列表
function M:friend_list_res(player_id, res)
    self.interface_mgr:send_msg(player_id, PACK.hallserver_friend.FriendListRes, res)
end

--请求加好友
function M:add_friend_res(player_id, res)
	self.interface_mgr:send_msg(player_id, PACK.hallserver_friend.AddFriendRes, res)
end

--同意加好友
function M:agree_friend_res(player_id, res)
	self.interface_mgr:send_msg(player_id, PACK.hallserver_friend.AgreeAddFriendRes, res)
end

--拒绝加好友
function M:refuse_friend_res(player_id, res)
	self.interface_mgr:send_msg(player_id, PACK.hallserver_friend.RefuseAddFriendRes, res)
end

--删除好友
function M:del_friend_res(player_id, res)
	self.interface_mgr:send_msg(player_id, PACK.hallserver_friend.DelFriendReq, res)
end

return M