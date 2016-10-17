//
//  RNImage.h
//  TCShopAPP
//
//  Created by 孝辰 吴 on 16/7/28.
//  Copyright © 2016年 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "RCTBridgeModule.h"
@interface RNImage : NSObject


+(void)saveImage:(NSArray *)array andCallBack:(RCTResponseSenderBlock)callback;
@end
