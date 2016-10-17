//
//  MBProgressHUD+NJ.m
//
//  Created by 李南江 on 14-5-5.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "MBProgressHUD+NJ.h"

@implementation MBProgressHUD (NJ)
#pragma mark 显示信息
+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view
{
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = text;
//    hud.detailsLabelText = text;
    // 设置图片
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@", icon]]];
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    // 1秒之后再消失
    [hud hide:YES afterDelay:1];
}

#pragma mark 显示错误信息
+ (void)showError:(NSString *)error toView:(UIView *)view{
    [self show:error icon:@"error.png" view:view];
}

+ (void)showSuccess:(NSString *)success toView:(UIView *)view
{
    [self show:success icon:@"success.png" view:view];
}


+(void)showSuccess:(NSString *)text view:(UIView *)view sectend:(int)sectend{
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
//    hud.labelText = text;
        hud.detailsLabelText = text;
    // 设置图片
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@", @"success.png"]]];
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    // 1秒之后再消失
    [hud hide:YES afterDelay:2.4];
}

#pragma mark 显示一些信息
+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view {
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.detailsLabelText = message;
  hud.detailsLabelFont = [UIFont systemFontOfSize:16.0f];
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
  
    //只显示文字模式
    hud.mode = MBProgressHUDModeText;
    // YES代表需要蒙版效果
    hud.dimBackground = YES;
  
  hud.removeFromSuperViewOnHide = YES;
  
  // 1秒之后再消失
  [hud hide:YES afterDelay:2.4];
  
    return hud;
}

+(MBProgressHUD *)showMessage:(NSString *)message andDurationTime:(CGFloat)time{
  
  UIView *view = [[UIApplication sharedApplication].windows lastObject];
  // 快速显示一个提示信息
  MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
  hud.labelText = message;
  // 隐藏时候从父控件中移除
  hud.removeFromSuperViewOnHide = YES;
  
  //只显示文字模式
  hud.mode = MBProgressHUDModeText;
  // YES代表需要蒙版效果
  hud.dimBackground = YES;
  
  hud.removeFromSuperViewOnHide = YES;
  
  // time秒之后再消失
  [hud hide:YES afterDelay:time];
  
  return hud;
  
}

+ (MBProgressHUD *)showMessageWithLoad:(NSString *)message toView:(UIView *)view {
  if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
  // 快速显示一个提示信息
  MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
  hud.detailsLabelText = message;
  hud.detailsLabelFont = [UIFont systemFontOfSize:16.0f];
  // 隐藏时候从父控件中移除
  hud.removeFromSuperViewOnHide = YES;
  
  //只显示文字模式
//  hud.mode = MBProgressHUDModeText;
  // YES代表需要蒙版效果
  hud.dimBackground = YES;
  
  hud.removeFromSuperViewOnHide = YES;
  
  // 1秒之后再消失
  [hud hide:YES afterDelay:2.4];
  
  return hud;
}


+(MBProgressHUD *)showMessage:(NSString *)message delegate:(id)delegate view:(UIView *)view{
    
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
//    hud.labelText = message;
    
    hud.detailsLabelText = message;
    // 设置图片
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@", @"success.png"]]];
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    
    hud.delegate = delegate;
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    // 1秒之后再消失
    [hud hide:YES afterDelay:2.4];
    
    return hud;
}


-(void)showMessage:(NSString *)message{
    self.labelText = message;
    // 设置图片
    self.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@",@"error.png"]]];
    // 再设置模式
    self.mode = MBProgressHUDModeCustomView;
    [self hide:YES afterDelay:1];
}


+ (void)showSuccess:(NSString *)success
{
    [self showSuccess:success toView:nil];
}

+ (void)showError:(NSString *)error
{
    [self showError:error toView:nil];
}

+ (MBProgressHUD *)showMessage:(NSString *)message
{
    return [self showMessage:message toView:nil];
}




+ (void)hideHUDForView:(UIView *)view
{
    [self hideHUDForView:view animated:YES];
}

+ (void)hideHUD
{
    [self hideHUDForView:nil];
}
@end
