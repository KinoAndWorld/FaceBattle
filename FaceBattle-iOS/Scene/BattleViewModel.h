//
//  BattleViewModel.h
//  FaceBattle-iOS
//
//  Created by kino on 16/6/4.
//
//

#import "KOViewModel.h"

#import "Battle.h"

typedef enum {
    BattleSectionTypeCurrent = 0,
    BattleSectionTypeHistory,
    BattleSectionTypeMine
}BattleSectionType;

@class BattleSearchPageStatus;


@interface BattleViewModel : KOViewModel

/**
 *  重新加载作品
 */
- (RACSignal *)fetchNewestBattleListByType:(BattleSectionType)type;

///**
// *  加载更多作品
// */
//- (RACSignal *)fetchNextPageBattleListByType:(BattleSectionType)type;

- (BattleSearchPageStatus *)modelWithType:(BattleSectionType)type;

@end



@interface BattleSearchPageStatus : NSObject

@property (assign, nonatomic) BattleSectionType type;

@property (copy, nonatomic) NSString *title;
@property (assign, nonatomic) NSUInteger page;
@property (assign, nonatomic) NSUInteger pageSize;
@property (strong, nonatomic) NSMutableArray *datas;



@property (assign, nonatomic) BOOL isFetchingData;

+ (instancetype)modelWithType:(BattleSectionType)type
                        title:(NSString *)title
                         page:(NSUInteger)page
                        datas:(NSMutableArray *)datas;

@end