//
//  IPHelper.h
//  wifiDemo
//
//  Created by jamelee on 2021/3/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface IPHelper : NSObject

+ (NSString *)deviceIPAdress;
+ (NSString *)getIPAddress:(BOOL)preferIPv4;
+ (BOOL)isValidatIP:(NSString *)ipAddress;

@end

NS_ASSUME_NONNULL_END
