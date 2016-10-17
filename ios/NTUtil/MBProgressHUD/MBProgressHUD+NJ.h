//
//  MBProgressHUD+NJ.h
//
//  Created by 李南江 on 14-5-5.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (NJ)
+ (void)showSuccess:(NSString *)success toView:(UIView *)view;
+ (void)showError:(NSString *)error toView:(UIView *)view;

+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view;


+ (void)showSuccess:(NSString *)success;
+ (void)showError:(NSString *)error;

+ (MBProgressHUD *)showMessage:(NSString *)message;

+ (MBProgressHUD *)showMessageWithLoad:(NSString *)message toView:(UIView *)view;
+(MBProgressHUD *)showMessage:(NSString *)message andDurationTime:(CGFloat)time;


+(MBProgressHUD *)showMessage:(NSString *)message delegate:(id)delegate view:(UIView *)view;

+ (void)hideHUDForView:(UIView *)view;
+ (void)hideHUD;


-(void)showMessage:(NSString *)message;

/**
 *  @author wuxiaochen, 2015-10-16 15:10:04
 *
 *  快速入园成功提示
 *
 *  @param text    <#text description#>
 *  @param view    <#view description#>
 *  @param sectend <#sectend description#>
 */
+(void)showSuccess:(NSString *)text view:(UIView *)view sectend:(int)sectend;

@end
