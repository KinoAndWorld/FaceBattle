//
//  BaseApiEngine.m
//  HomeInns-iOS
//
//  Created by kino on 15/9/7.
//
//

#import "BaseApiEngine.h"

//#import "RSAEncryptor.h"

@implementation BaseApiEngine

//wrapper
//+ (NSString *)jsonStringFromDic:(NSDictionary *)dic{
//    if ([[dic allKeys] count] == 0) {
//        return @"";
//    }
//    
//    NSError *error = nil;
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic
//                                                       options:kNilOptions
//                                                         error:&error];
//    NSString *jsonString = [[NSString alloc] initWithData:jsonData
//                                                 encoding:NSUTF8StringEncoding];
//    return jsonString;
//}
//
//+ (NSString *)encryString:(NSString *)oriString{
//    RSAEncryptor *rsa = [[RSAEncryptor alloc] init];
//    
//    BFLog(@"encryptor using rsa");
//    NSString *publicKeyPath = [[NSBundle mainBundle] pathForResource:@"unionpay_public_key" ofType:@"der"];
//    BFLog(@"public key: %@", publicKeyPath);
//    [rsa loadPublicKeyFromFile:publicKeyPath];
//    
//    NSString *securityText = oriString;
//    NSString *encryptedString = [rsa rsaEncryptString:securityText];
//    BFLog(@"encrypted data: %@", encryptedString);
//    
//    return encryptedString;
//}

@end
