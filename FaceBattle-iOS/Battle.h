//
//  Battle.h
//  FaceBattle-iOS
//
//  Created by kino on 16/6/4.
//
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    BattleTypeDiff = 0,
    BattleTypeSame,
} BattleType;

@class BattleScore;

@interface Battle : KOModel

@property (copy, nonatomic) NSString *bid;
@property (copy, nonatomic) NSString *uid;
@property (copy, nonatomic) NSString *pid;
@property (copy, nonatomic) NSString *status;

@property (assign, nonatomic) BattleType type;

@property (copy, nonatomic) NSString *startUid;
@property (strong, nonatomic) NSDate *startTime;
@property (copy, nonatomic) NSString *startUsername;
@property (copy, nonatomic) NSString *startPid;
@property (copy, nonatomic) NSString *startPhotoUrl;

@property (strong, nonatomic) BattleScore *startScore;


@property (copy, nonatomic) NSString *parterUid;
@property (strong, nonatomic) NSDate *parterTime;
@property (copy, nonatomic) NSString *parterUsername;
@property (copy, nonatomic) NSString *parterPid;
@property (copy, nonatomic) NSString *parterPhotoUrl;

@property (strong, nonatomic) BattleScore *parterScore;

- (BOOL)checkBattleIfStartUserWin;


- (NSString *)startDescString;
- (NSString *)partnerString;

@end


//@interface BattleJoiner : KOModel
//
//
//
//@end


@interface BattleScore : KOModel

@property (assign, nonatomic) float disgust;//": 0.0000188611375,
@property (assign, nonatomic) float contempt;//": 0.000230420846,
@property (assign, nonatomic) float anger;//": 0.000008974128,
@property (assign, nonatomic) float happiness;//": 0.00004466128,
@property (assign, nonatomic) float sadness;//": 0.0008327073,
@property (assign, nonatomic) float fear;//": 0.0000169579453,
@property (assign, nonatomic) float surprise;//": 0.00105792622,
@property (assign, nonatomic) float neutral;

- (NSDictionary *)getMainlyEmotion;


@end


//@interface BattleRuleManager : NSObject
//
//- (BOOL)checkWin
//
//@end
