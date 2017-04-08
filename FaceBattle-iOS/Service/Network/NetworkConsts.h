//
//  NetworkConsts.h
//  MeiYuan-iOS
//
//  Created by kino on 15/9/7.
//
//

#ifndef MeiYuan_iOS_NetworkConsts_h
#define MeiYuan_iOS_NetworkConsts_h

#define KODefineAPI(Name,Path)\
static NSString * const (Name) = (Path);

typedef enum {
    APIMethodGet = 0,
    APIMethodPost ,
    APIMethodPut,
    APIMethodDelete
}APIMethod;


KODefineAPI(BASE_API_URL, @"https://api.facebattle.us")
KODefineAPI(TEST_BASE_API_URL,  @"http://localhost:3000")

/**
 *  Battle API
 */
KODefineAPI(API_BattleHistoryList, @"battle/finished")
KODefineAPI(API_BattleCurrentList, @"battle/available")

//获取指定bid对战信息
KODefineAPI(API_BattleInfo, @"battle/detail")
//发起battle
KODefineAPI(API_CreateBattle, @"battle/create")
//加入battle
KODefineAPI(API_JoinBattle, @"battle/join")


//KODefineAPI(API_GetImage, @"address/photo/get")

/**
 *  User API
 */
KODefineAPI(API_SignUp, @"user/signup")
KODefineAPI(API_SignIn, @"user/login")

#endif
