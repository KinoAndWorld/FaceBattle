//
//  UserRequest.h
//  MeiYuan
//
//  Created by kino on 16/4/8.
//
//

#import <Foundation/Foundation.h>

@interface UserRequest : NSObject

@property (copy, nonatomic) NSString *account;

@property (copy, nonatomic) NSString *password;
@property (copy, nonatomic) NSString *originPassword;

@property (copy, nonatomic) NSString *validCode;

//datas
@property (strong, nonatomic) UIImage *avatar;
@property (copy, nonatomic) NSString *name;

@property (copy, nonatomic) NSString *university;
@property (copy, nonatomic) NSString *college;
@property (copy, nonatomic) NSString *major;
@property (copy, nonatomic) NSString *city;
@property (copy, nonatomic) NSString *collegeYear;

@property (copy, nonatomic) NSString *gender;
@property (assign, nonatomic) BOOL isArtist;
@property (strong, nonatomic) NSArray *fieldList;


@end
