//
//  RNMessage.h
//  TCShopAPP
//
//  Created by 孝辰 吴 on 16/5/5.
//  Copyright © 2016年 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>

@interface RNMessage : NSObject<
MFMessageComposeViewControllerDelegate
>


-(void)sendMessage:(NSString *)message toPhone:(NSString *)phone;

@end
