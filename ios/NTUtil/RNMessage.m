//
//  RNMessage.m
//  TCShopAPP
//
//  Created by 孝辰 吴 on 16/5/5.
//  Copyright © 2016年 Facebook. All rights reserved.
//

#import "RNMessage.h"

@implementation RNMessage


-(void)sendMessage:(NSString *)message toPhone:(NSString *)phone{
  if([MFMessageComposeViewController canSendText]){
    
    MFMessageComposeViewController * controller = [[MFMessageComposeViewController alloc]init]; //autorelease];
    
    controller.recipients = [NSArray arrayWithObject:phone];
    controller.body = message;
    controller.messageComposeDelegate = self;
    
    
    UIViewController *rootController = UIApplication.sharedApplication.delegate.window.rootViewController;
    
    dispatch_async(dispatch_get_main_queue(), ^{
      [rootController presentViewController:controller animated:YES completion:^{
      
      }];
    });
    
    [[[[controller viewControllers] lastObject] navigationItem] setTitle:@"发送短信"];//修改短信界面标题
  }else{
    
    [self alertWithTitle:@"提示信息" msg:@"设备没有短信功能"];
  }

}


- (void) alertWithTitle:(NSString *)title msg:(NSString *)msg {
  
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                  message:msg
                                                 delegate:self
                                        cancelButtonTitle:nil
                                        otherButtonTitles:@"确定", nil];
  
  [alert show];
  
}


- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
  
  // [controller dismissModalViewControllerAnimated:NO];//关键的一句   不能为YES
  
  [controller dismissViewControllerAnimated:NO completion:^{
    
  }];//关键的一句 不能为YES
  
  
  switch ( result ) {
    case MessageComposeResultCancelled:
      [self alertWithTitle:@"提示信息" msg:@"发送取消"];
      break;
    case MessageComposeResultFailed:// send failed
      [self alertWithTitle:@"提示信息" msg:@"发送失败"];
      break;
    case MessageComposeResultSent:
      [self alertWithTitle:@"提示信息" msg:@"发送成功"];
      break;
    default:
      break;
  }
}





@end
