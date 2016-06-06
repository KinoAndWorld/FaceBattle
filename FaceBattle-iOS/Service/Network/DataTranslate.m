//
//  DataTranslate.m
//  MeiYuan-iOS
//
//  Created by kino on 15/9/7.
//
//

#import "DataTranslate.h"


@implementation KOModel

+ (id)translateFromData:(id)responseObject{
    if ([responseObject isKindOfClass:[NSArray class]]) {
        NSArray *translateResults = [NSArray yy_modelArrayWithClass:[self class] json:responseObject];
        return translateResults;
    }else if ([responseObject isKindOfClass:[NSDictionary class]]){
        id result = [self yy_modelWithDictionary:responseObject];
        return result;
    }
    
    return responseObject;
}

@end

@implementation JsonTranslater

+ (id)translateFromData:(id)responseObject{
    if ([responseObject isKindOfClass:[NSData class]]) {
        NSError *error = nil;
        NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
        return responseJSON;
    }
    return responseObject;
}



@end
