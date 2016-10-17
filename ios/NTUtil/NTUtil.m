//
//  NTUtil.m
//  NTUtil
//
//  Created by 孝辰 吴 on 16/10/13.
//  Copyright © 2016年 TCJQ. All rights reserved.
//

#import "NTUtil.h"
#import "RCTBridge.h"
#import "RCTEventDispatcher.h"
#import "MBProgressHUD+NJ.h"
#import "Reachability.h"
#import "RCTUtils.h"

static NSString *const RCTShowDevMenuNotification = @"RCTShowDevMenuNotification";


#if !RCT_DEV

@implementation UIWindow (RNShakeEvent)

- (void)handleShakeEvent:(__unused UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (event.subtype == UIEventSubtypeMotionShake) {
        [[NSNotificationCenter defaultCenter] postNotificationName:RCTShowDevMenuNotification object:nil];
    }
}

@end


@implementation NTUtil

@synthesize bridge = _bridge;

RCT_EXPORT_MODULE(NTUtilModule)

+ (void)initialize
{
    RCTSwapInstanceMethods([UIWindow class], @selector(motionEnded:withEvent:), @selector(handleShakeEvent:withEvent:));
}

- (instancetype)init
{
    if ((self = [super init])) {
        RCTLogInfo(@"RNShakeEvent: started in debug mode");
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(motionEnded:)
                                                     name:RCTShowDevMenuNotification
                                                   object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)motionEnded:(NSNotification *)notification
{
    
    [_bridge.eventDispatcher sendDeviceEventWithName:@"ShakeEvent"
                                                body:nil];
}

#else



@implementation NTUtil

RCT_EXPORT_MODULE(NTUtilModule)

@synthesize bridge = _bridge;

- (instancetype)init
{
    if ((self = [super init])) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(motionEnded:)
                                                     name:RCTShowDevMenuNotification
                                                   object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)motionEnded:(NSNotification *)notification
{
    
    [_bridge.eventDispatcher sendDeviceEventWithName:@"ShakeEvent"
                                                body:nil];
}

#endif



/**
 *  @author wuxiaochen, 2016-05-19 17:05:00
 *
 *  错误提示模态框（2.4秒后自动消失）
 */
RCT_EXPORT_METHOD(showError:(NSString *)msg){
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD showError:msg];
    });
}

/**
 *  @author wuxiaochen, 2016-05-19 17:05:13
 *
 *  提示模态框（只显示文字，2.4秒后自动消失）
 */
RCT_EXPORT_METHOD(showMessage:(NSString *)msg){
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD showMessage:msg];
    });
}


/**
 *  @author wuxiaochen, 2016-06-01 14:06:09
 *
 *  提示模态框（只显示文字，可控制几秒之后自动消失）
 *
 *  @param NSString <#NSString description#>
 *
 *  @return <#return value description#>
 */
RCT_EXPORT_METHOD(showMessageWithTime:(NSString *)msg andDurationTime:(CGFloat)time){
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD showMessage:msg andDurationTime:time];
    });
}

/**
 *  @author wuxiaochen, 2016-05-19 17:05:49
 *
 *  正确提示模态框(2.4秒后自动消失)
 */
RCT_EXPORT_METHOD(showSuccess:(NSString *)msg){
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD showSuccess:msg];
    });
}

/**
 *  @author wuxiaochen, 2016-05-19 17:05:09
 *
 *  隐藏模态框
 */
RCT_EXPORT_METHOD(hideHUD){
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUD];
    });
}

/**
 *  @author wuxiaochen, 2016-06-01 15:06:10
 *
 *  发送短信
 *
 *  @param NSString 短信内容
 *
 *  @return return value description
 */
RCT_EXPORT_METHOD(sendMsg:(NSString *)msg toPhone:(NSString *)phone){
    rnMessage = [[RNMessage alloc]init];
    [rnMessage sendMessage:msg toPhone:phone];
}

/**
 *  @author wuxiaochen, 2016-09-02 15:09:52
 *
 *  拨打电话
 */
RCT_EXPORT_METHOD(call:(NSString *)phone){
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",phone];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWebView * callWebview = [[UIWebView alloc] init];
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
        UIViewController *rootController = UIApplication.sharedApplication.delegate.window.rootViewController;
        [rootController.view addSubview:callWebview];
    });
    
}

/**
 *  @author wuxiaochen, 2016-08-26 20:08:52
 *
 *  复制到剪切板
 */
RCT_EXPORT_METHOD(copyText:(NSString *)text){
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = text;
}

/**
 *  @author wuxiaochen, 2016-06-13 11:06:53
 *
 *  更改头部状态栏 颜色
 */
RCT_EXPORT_METHOD(setHeaderColor:(NSString *)type){
    if([type isEqualToString:@"black"]){
        dispatch_async(dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        });
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        });
    }
}

/**
 *  @author wuxiaochen, 2016-06-02 17:06:03
 *
 *  增加通讯录
 *
 *  @param NSString NSString description
 *
 *  @return return value description
 */
RCT_EXPORT_METHOD(addContact:(NSString *)name andPhoneList:(NSArray *)phoneList){
    
    RNContact *contact = [[RNContact alloc]init];
    
    [contact addContact:name phoneNumbers:phoneList withNote:@""];
    
}

/**
 *  @author wuxiaochen, 2016-06-02 17:06:03
 *
 *  增加通讯录(带备注)
 *
 *  @param NSString NSString description
 *
 *  @return return value description
 */

RCT_EXPORT_METHOD(addContactWithNote:(NSString *)name andPhoneList:(NSArray *)phoneList andNote:(NSString *)note){
    
    RNContact *contact = [[RNContact alloc]init];
    
    [contact addContact:name phoneNumbers:phoneList withNote:note];
    
}


/**
 *  @author wuxiaochen, 2016-08-18 18:08:13
 *
 *  清除cookie
 */
RCT_EXPORT_METHOD(clearCookie) {
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    
    for (NSHTTPCookie *c in cookieStorage.cookies) {
        [cookieStorage deleteCookie:c];
    }
    
    //  NSArray * cookArray = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[NSURL URLWithString:@"http://www.baidu.com"]];
    //  NSString * successCode = @"";
    //  for (NSHTTPCookie*cookie in cookArray) {
    //    if ([cookie.name isEqualToString:@"cookiename"]) {
    //      [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
    //    }
    //  }
}

/**
 *  @author wuxiaochen, 2016-07-21 19:07:12
 *
 *  读取通讯录
 */
RCT_EXPORT_METHOD(getContactList:(RCTResponseSenderBlock)callback){
    
    RNContact *contact = [[RNContact alloc]init];
    
    NSDictionary *dic = [contact getAllContactInfo];
    //1 代表 无通讯录访问权限
    if(dic == nil){
        callback(@[@"1",[NSNull null]]);
    }else{
        callback(@[[NSNull null],dic]);
    }
    
    
}

/**
 *  @author wuxiaochen, 2016-07-21 19:07:02
 *
 *  当前版本是否是Debug版本
 */
RCT_EXPORT_METHOD(judgeIsDebug:(RCTResponseSenderBlock)callback){
    
#if DEBUG
    callback(@[@YES]);
#else
    callback(@[@NO]);
#endif
    
}


/**
 *  @author wuxiaochen, 2016-07-28 15:07:16
 *
 *  保存网络图片到本地相册
 */
RCT_EXPORT_METHOD(saveImage:(NSArray *)array andCallBack:(RCTResponseSenderBlock)callback){
    
    [RNImage saveImage:array andCallBack:callback];
    
}

/**
 *  @author wuxiaochen, 2016-09-01 15:09:29
 *
 *  判断当前网络是否是WIFI
 */
RCT_EXPORT_METHOD(judgeNetType:(RCTResponseSenderBlock)callback){
    
    NSString *result = @"";
    
    Reachability *reachability = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    switch ([reachability currentReachabilityStatus]) {
        case NotReachable:{
            result = @"无网络";
        }
            break;
        case ReachableViaWWAN:{
            result = @"4G/3G/2G";
        }
            break;
        case ReachableViaWiFi:{
            result = @"WIFI";
        }
            break;
        default:
            result = @"无网络";
            break;
    }
    callback(@[result]);
    
}

























@end
