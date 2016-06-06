//
//  BattleViewModel.m
//  FaceBattle-iOS
//
//  Created by kino on 16/6/4.
//
//

#import "BattleViewModel.h"

#import "BattleEngine.h"

static NSUInteger kPageStartIndex = 1;

@interface BattleViewModel()

@property (strong, nonatomic) NSArray<BattleSearchPageStatus *> *typeWithPageMaps;

@end

@implementation BattleViewModel

- (void)initialize{
    
    BattleSearchPageStatus *typeZero = [BattleSearchPageStatus modelWithType:BattleSectionTypeCurrent
                                                                         title:@"" page:kPageStartIndex datas:[@[] mutableCopy]];
    BattleSearchPageStatus *typeOne = [BattleSearchPageStatus modelWithType:BattleSectionTypeHistory
                                                                        title:@"" page:kPageStartIndex datas:[@[] mutableCopy]];
    BattleSearchPageStatus *typeTwo = [BattleSearchPageStatus modelWithType:BattleSectionTypeMine
                                                                        title:@"" page:kPageStartIndex datas:[@[] mutableCopy]];
    
    _typeWithPageMaps = @[typeZero, typeOne, typeTwo];
}

/**
 *  重新加载作品
 */
- (RACSignal *)fetchNewestBattleListByType:(BattleSectionType)type{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        __block BattleSearchPageStatus *model = [self modelWithType:type];
        model.isFetchingData = YES;
        
        __block NSUInteger originPage = model.page;
        model.page = kPageStartIndex;
        
        if (type == BattleSectionTypeCurrent) {
            
            [BattleEngine fetchCurrentBattleOnComplete:^(id responseResult) {
                
                model.isFetchingData = NO;
                model.datas = responseResult;
                
                [subscriber sendNext:model];
                [subscriber sendCompleted];
            } onError:^(NSError *error) {
                
                model.isFetchingData = NO;
                model.page = originPage;
                [subscriber sendError:error];
                [subscriber sendCompleted];

            } translater:[Battle class]];
            
        }else if (type == BattleSectionTypeHistory){
            [BattleEngine fetchCompleteBattleOnComplete:^(id responseResult) {
                model.isFetchingData = NO;
                model.datas = responseResult;
                
                [subscriber sendNext:model];
                [subscriber sendCompleted];
            } onError:^(NSError *error) {
                
                model.isFetchingData = NO;
                model.page = originPage;
                [subscriber sendError:error];
                [subscriber sendCompleted];

            } translater:[Battle class]];
        }
        
        return nil;
    }];
}

///**
// *  加载更多作品
// */
//- (RACSignal *)fetchNextPageBattleListByType:(BattleSectionType)type{
//    
//}

- (BattleSearchPageStatus *)modelWithType:(BattleSectionType)type{
    NSArray *resultes = [[[_typeWithPageMaps rac_sequence] filter:^BOOL(BattleSearchPageStatus *value) {
        return value.type == type;
    }] array];
    return [resultes safeObjectAtIndex:0];
}


@end


@implementation BattleSearchPageStatus

+ (instancetype)modelWithType:(BattleSectionType)type title:(NSString *)title
                         page:(NSUInteger)page datas:(NSMutableArray *)datas{
    
    BattleSearchPageStatus *model = [[BattleSearchPageStatus alloc] init];
    model.type = type;
    model.title = title;
    model.page = page;
    model.pageSize = 10;
    model.datas = datas;
    return model;
}

- (NSMutableArray *)datas{
    if (!_datas) {
        _datas = [NSMutableArray array];
    }
    
    if (![_datas isKindOfClass:[NSArray class]]) {
        _datas = @[];
    }
    
    return _datas;
}

@end