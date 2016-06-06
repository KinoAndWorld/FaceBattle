//
//  BattleEngine.m
//  FaceBattle-iOS
//
//  Created by kino on 16/6/4.
//
//

#import "BattleEngine.h"

@implementation BattleEngine

/**
 *  当前battle
 *
 *  @param req
 */
+ (void)fetchCurrentBattleOnComplete:(ResponseBlock)completeBlock
                             onError:(ErrorBlock)errorBlock
                          translater:(Class<DataTranslate>)translater{
    
    AppUser *user = [UserManager sharedManager].curUser;
    
    NSDictionary *params = @{@"uid": user.userId, @"token":user.authToken};
    
    [[APIManager shareManager] sendRequestFromMethod:APIMethodPost
                                                path:API_BattleCurrentList
                                              params:params
                                          onComplete:Default_Handle
                                             onError:errorBlock];
}

/**
 *  已完成battle
 *
 *  @param req
 */
+ (void)fetchCompleteBattleOnComplete:(ResponseBlock)completeBlock
                              onError:(ErrorBlock)errorBlock
                           translater:(Class<DataTranslate>)translater{
    
    AppUser *user = [UserManager sharedManager].curUser;
    
    NSDictionary *params = @{@"uid": user.userId, @"token":user.authToken};
    
    [[APIManager shareManager] sendRequestFromMethod:APIMethodPost
                                                path:API_BattleHistoryList
                                              params:params
                                          onComplete:Default_Handle
                                             onError:errorBlock];
}


/**
 *  上传照片参战
 */
+ (void)uploadPhotoToBattleWithImage:(UIImage *)photo
                                type:(NSUInteger)type
                            progress:(void(^)(NSProgress *))progressHandler
                          onComplete:(ResponseBlock)completeBlock
                             onError:(ErrorBlock)errorBlock
                          translater:(Class<DataTranslate>)translater{
    
    AppUser *user = [UserManager sharedManager].curUser;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"uid"] = user.userId;
    params[@"token"] = user.authToken;
    params[@"type"] = @(type);
    
    [[APIManager shareManager] sendRequestFromMethod:APIMethodPost path:API_CreateBattle params:params onComplete:Default_Handle onError:errorBlock responseSerializer:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if (photo) {
            
            NSData *imageData = UIImagePNGRepresentation(photo);
            NSString *name = @"photo";
            [formData appendPartWithFileData:imageData name:name fileName:@"photo" mimeType:@"image/png"];
        }
    } progress:^(NSProgress * _Nonnull progeess) {
        if (progressHandler) {
            progressHandler(progeess);
        }
    }];
}



/**
 *  加入Battle
 *
 *  @param photo           <#photo description#>
 *  @param bid             <#bid description#>
 */
+ (void)joinBattleWithPhoto:(UIImage *)photo
                        bid:(NSString *)bid
                   progress:(void(^)(NSProgress *))progressHandler
                 onComplete:(ResponseBlock)completeBlock
                    onError:(ErrorBlock)errorBlock
                 translater:(Class<DataTranslate>)translater{
    
    AppUser *user = [UserManager sharedManager].curUser;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"uid"] = user.userId;
    params[@"token"] = user.authToken;
    params[@"bid"] = bid;
    
    [[APIManager shareManager] sendRequestFromMethod:APIMethodPost path:API_JoinBattle params:params onComplete:Default_Handle onError:errorBlock responseSerializer:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if (photo) {
            
            NSData *imageData = UIImagePNGRepresentation(photo);
            NSString *name = @"photo";
            [formData appendPartWithFileData:imageData name:name fileName:@"photo" mimeType:@"image/png"];
        }
    } progress:^(NSProgress * _Nonnull progeess) {
        if (progressHandler) {
            progressHandler(progeess);
        }
    }];
}


/**
 *  BAttle 详情
 *
 *  @param bid
 */
+ (void)getBattleInfoFormBid:(NSString *)bid
                  onComplete:(ResponseBlock)completeBlock
                     onError:(ErrorBlock)errorBlock
                  translater:(Class<DataTranslate>)translater{
    
    AppUser *user = [UserManager sharedManager].curUser;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"uid"] = user.userId;
    params[@"token"] = user.authToken;
    params[@"bid"] = bid;
    
    [[APIManager shareManager] sendRequestFromMethod:APIMethodPost
                                                path:API_BattleInfo
                                              params:params
                                          onComplete:Default_Handle
                                             onError:errorBlock];
}

@end
