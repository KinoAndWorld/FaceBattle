//
//  BattleEngine.h
//  FaceBattle-iOS
//
//  Created by kino on 16/6/4.
//
//

#import "BaseApiEngine.h"

@interface BattleEngine : BaseApiEngine

/**
 *  当前battle
 *
 *  @param req
 */
+ (void)fetchCurrentBattleOnComplete:(ResponseBlock)completeBlock
                             onError:(ErrorBlock)errorBlock
                          translater:(Class<DataTranslate>)translater;

/**
 *  已完成battle
 *
 *  @param req
 */
+ (void)fetchCompleteBattleOnComplete:(ResponseBlock)completeBlock
                              onError:(ErrorBlock)errorBlock
                           translater:(Class<DataTranslate>)translater;



/**
 *  上传照片参战
 */
+ (void)uploadPhotoToBattleWithImage:(UIImage *)photo
                                type:(NSUInteger)type
                            progress:(void(^)(NSProgress *))progressHandler
                          onComplete:(ResponseBlock)completeBlock
                             onError:(ErrorBlock)errorBlock
                          translater:(Class<DataTranslate>)translater;


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
                 translater:(Class<DataTranslate>)translater;



/**
 *  BAttle 详情
 *
 *  @param bid
 */
+ (void)getBattleInfoFormBid:(NSString *)bid
                  onComplete:(ResponseBlock)completeBlock
                     onError:(ErrorBlock)errorBlock
                  translater:(Class<DataTranslate>)translater;


@end
