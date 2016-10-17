//
//  NTUtil.h
//  NTUtil
//
//  Created by 孝辰 吴 on 16/10/13.
//  Copyright © 2016年 TCJQ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RCTBridgeModule.h"
#import "RNMessage.h"
#import "RNContact.h"
#import "RNImage.h"

static RNMessage *rnMessage;
static RNContact *rnContact;
static RNImage *rnImage;

@interface NTUtil : NSObject<RCTBridgeModule>

@end
