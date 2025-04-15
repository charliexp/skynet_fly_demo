import { ecs } from "db://oops-framework/libs/ecs/ECS";
import { Account } from "../login/account/Account";
import { Initialize } from "../login/initialize/Initialize";
import { NetNodeManager } from "../../libs/network/NetNodeManager";
import {HallEntity} from "../hall/hall/Hall"
import {BoardEntity} from "../game/board/BoardEntity"
import {EmailEntity} from "../hall/email/EmailEntity"
import {FriendEntity} from "../hall/friend/FriendEntity"
import { Tables } from "../../libs/schema";

/** 游戏单例业务模块 */
@ecs.register('SingletonModule')
export class SingletonModuleComp extends ecs.Comp {
    /** 游戏初始化模块 */
    initialize: Initialize = null!;
    /** 游戏账号模块 */
    account: Account = null!;
    /** 网络模块 */
    net = new NetNodeManager();
    /** 配置表 */
    tables : Tables = null!;
    /** 大厅模块 */
    hall: HallEntity = null!;
    /** 游戏模块 */
    game: BoardEntity = null!;
    /** 邮件模块 */
    email: EmailEntity = null!;
    /** 好友模块 */
    friend: FriendEntity = null!;
    reset() { }
}

export const smc: SingletonModuleComp = ecs.getSingleton(SingletonModuleComp);