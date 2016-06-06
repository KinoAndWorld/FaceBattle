//
//  Battle.m
//  FaceBattle-iOS
//
//  Created by kino on 16/6/4.
//
//

#import "Battle.h"

@implementation Battle

+ (NSDictionary *)modelCustomPropertyMapper{
    return @{@"startTime" : @"stater.time",
             @"startUsername" : @"stater.username",
             @"startPid" : @"stater.pid",
             @"startUid" : @"stater.uid",
             @"startScore" : @"stater.score",
             
             @"parterUid" : @"participator.uid",
             @"parterTime" : @"participator.time",
             @"parterUsername" : @"participator.username",
             @"parterPid" : @"participator.pid",
             @"parterScore" : @"participator.score"};
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"score" : [BattleScore class] };
}

- (BOOL)checkBattleIfStartUserWin{
    
    NSDictionary *startDic = [self.startScore getMainlyEmotion];
    NSDictionary *partnerDic = [self.parterScore getMainlyEmotion];
    
    NSString *startEmotion = [startDic safeObjectForKey:@"name"];
    NSString *parterMotion = [partnerDic safeObjectForKey:@"name"];
    
    if ([startEmotion isEqualToString:@"happiness"]) {
        if ([parterMotion isEqualToString:@"sadness"]) {
            return YES;
        }
        return NO;
    }else if ([startEmotion isEqualToString:@"sadness"]){
        if ([parterMotion isEqualToString:@"anger"]) {
            return YES;
        }
        return NO;
    }else if ([startEmotion isEqualToString:@"anger"]){
        if ([parterMotion isEqualToString:@"happiness"]) {
            return YES;
        }
        return NO;
    }
    
    return YES;
}

- (NSString *)startDescString{
    
    NSDictionary *startDic = [self.startScore getMainlyEmotion];
    
    return [NSString stringWithFormat:@"%0.0f%% %@", [[startDic safeObjectForKey:@"score"] floatValue] * 100, [startDic safeObjectForKey:@"name"]];
}

- (NSString *)partnerString{
    NSDictionary *partnerDic = [self.parterScore getMainlyEmotion];
    
    return [NSString stringWithFormat:@"%0.0f%% %@", [[partnerDic safeObjectForKey:@"score"] floatValue] * 100, [partnerDic safeObjectForKey:@"name"]];
}



@end


@implementation BattleScore

- (NSDictionary *)getMainlyEmotion{
    
    NSString *result = @"";
    float max = 0.f;
//    if (_disgust > max) {
//        max = _disgust;
//        result = @"disgust";
//    }
//    if (_contempt > max) {
//        max = _disgust;
//        result = @"contempt";
//    }
    if (_anger > max) {
        max = _anger;
        result = @"anger";
    }
    if (_happiness > max) {
        max = _happiness;
        result = @"happiness";
    }
    if (_sadness > max) {
        max = _sadness;
        result = @"sadness";
    }
//    if (_fear > max) {
//        max = _disgust;
//        result = @"";
//    }
//    if (_surprise > max) {
//        max = _disgust;
//        result = @"";
//    }
//    if (_neutral > max) {
//        max = _disgust;
//        result = @"";
//    }
    
    return @{@"name" : result, @"score" : @(max)};
}

@end