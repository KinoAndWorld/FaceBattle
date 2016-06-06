//
//  DataTranslate.h
//  MeiYuan-iOS
//
//  Created by kino on 15/9/7.
//
//

#import <Foundation/Foundation.h>


@protocol DataTranslate<NSObject>

@required
+ (id)translateFromData:(id)data;

@end

@interface KOModel : NSObject<DataTranslate>



@end

@interface JsonTranslater : NSObject<DataTranslate>

@end