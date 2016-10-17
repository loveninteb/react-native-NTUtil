//
//  RNContact.m
//  TCShopAPP
//
//  Created by 孝辰 吴 on 16/6/2.
//  Copyright © 2016年 Facebook. All rights reserved.
//

#import "RNContact.h"
#import <Foundation/Foundation.h>  
#import <UIKit/UIKit.h>  

@implementation RNContact



/**
 *  @author wuxiaochen, 2016-06-02 21:06:12
 *
 *  RN 增加通讯录  主目录
 *
 *  @param companyName 公司别名
 *  @param phoneList   电话列表
 */
-(void) addContact:(NSString *)companyName phoneNumbers:(NSArray *)phoneList withNote:(NSString *)note{
  
  [self getAddressBookWithCompanyName:companyName];
  
  [self addAddressBookWithCompanyName:companyName withPhoneNumbers:phoneList withNote:note];
  
}


/**
 *  @author wuxiaochen, 2016-06-02 19:06:16
 *
 *  新增通讯录
 *
 *  @param companyName 公司 名称
 *  @param phoneList 电话列表
 *
 *  @return 是否成功
 */
- (BOOL)addAddressBookWithCompanyName:(NSString *)companyName withPhoneNumbers:(NSArray *)phoneList withNote:(NSString *)note{
  
  ABAddressBookRef addressBookRef = [self getAddressBookRef];
  
  if (addressBookRef == nil) {
    NSLog(@"读取通讯录失败");
    return NO;
  }
  
  BOOL isSuccess = NO;
  //    创建通讯录模版
  ABRecordRef recordRef = ABPersonCreate();
  
  //插入公司名
  isSuccess = ABRecordSetValue(recordRef, kABPersonOrganizationProperty, (__bridge CFTypeRef)(companyName), nil);
  
  if([note length]>0){
    //插入备注
    isSuccess = ABRecordSetValue(recordRef, kABPersonNoteProperty, (__bridge CFTypeRef)(note), nil);
  }
 
  
  
  NSString *filePath = [[NSBundle mainBundle] pathForResource:@"xiaogu" ofType:@"png"];
  NSData *imageData = [NSData dataWithContentsOfFile:filePath];
  //设置头像
  isSuccess = ABPersonSetImageData(recordRef, (__bridge CFDataRef)(imageData), nil);
  
  
  ABMutableMultiValueRef multiValueRef =ABMultiValueCreateMutable(kABStringPropertyType);//添加设置多值属性
  
  int count = [[NSString stringWithFormat:@"%lu",(unsigned long)[phoneList count]] intValue];
  
  for(int i =0 ; i<count; i++){
    ABMultiValueAddValueAndLabel(multiValueRef, (__bridge CFStringRef)(phoneList[i]),  (__bridge CFStringRef)@"商务电话", NULL);//添加工作电话

  }
  
  //批量新增 手机号码
  isSuccess = ABRecordSetValue(recordRef, kABPersonPhoneProperty, multiValueRef, NULL);
  
  //将准备好的联系人添加到通讯录里面
  isSuccess = ABAddressBookAddRecord(addressBookRef, recordRef, nil);
  
  //保存修改过的通讯录
  isSuccess = ABAddressBookSave(addressBookRef, nil);
  
  if (recordRef) {
    CFRelease(recordRef);
  }
  return isSuccess;
}


/**
 *  @author wuxiaochen, 2016-06-02 19:06:41
 *
 *  创建通讯录对象
 *
 *  @return 通讯录
 */
- (ABAddressBookRef)getAddressBookRef
{
  ABAddressBookRef addressBookRef = nil;
  
  __block BOOL isSuccess = NO;
  //    创建通讯录对象，注意不会自动释放
  if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0) {
    addressBookRef = ABAddressBookCreateWithOptions(nil, nil);

    //iOS6.0以后，需要经过用户同意，所以做个等待线程
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
      
      ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error) {
        NSLog(@"Yes=%d_No=%d 是否经过用户同意%d",YES,NO,granted);
        isSuccess = granted?YES:NO;
        dispatch_semaphore_signal(semaphore);
      });

      
    });
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
  }else{
    addressBookRef = ABAddressBookCreate();
  }
  if (!isSuccess) {
//    [[[UIAlertView alloc] initWithTitle:@"提示" message:@"没有访问通讯录的权限" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil] show];
    return nil;
  }
  if (addressBookRef) {
    CFAutorelease(addressBookRef);
  }
  return addressBookRef;
}



/**
 *  @author wuxiaochen, 2016-06-02 20:06:36
 *
 *  根据 公司 别名 查找到对应的通讯记录并删除
 *
 *  @param companyName 公司别名
 *
 *  @return <#return value description#>
 */
- (void)getAddressBookWithCompanyName:(NSString *)companyName{

  ABAddressBookRef addressBookRef = [self getAddressBookRef];
  if (addressBookRef == nil) {
    NSLog(@"读取通讯录失败");
    return;
  }

  //获取所有本地的通讯录
  NSArray * records = (__bridge NSArray *)ABAddressBookCopyArrayOfAllPeople(addressBookRef);
  for (id record in records) {
    //单个联系人对象
    ABRecordRef recordRef = (__bridge ABRecordRef)record;
    //公司别名
    NSString *currnetCompanyName = (__bridge NSString *)ABRecordCopyValue(recordRef, kABPersonOrganizationProperty);
    
    if([currnetCompanyName isEqualToString:companyName]){
      //已经存在该公司别名，删除该条记录
      ABAddressBookRemoveRecord(addressBookRef, recordRef, nil);
      
      ABAddressBookSave(addressBookRef, nil);
    }
    
    if (recordRef) {
      CFRelease(recordRef);
    }
    
  }

}


/**
 *  @author wuxiaochen, 2016-07-13 18:07:37
 *
 *  获取通讯录所有信息
 *
 *  @return <#return value description#>
 */
-(NSDictionary *)getAllContactInfo{
  
 
  
  NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
  
  for(int i=0;i<26;i++)
  {
    char y=(char)(65+i);
    NSMutableArray *mutArray = [[NSMutableArray alloc]init];
    [dic setObject:mutArray forKey:[NSString stringWithFormat:@"%c",y]];
    
  }
  NSMutableArray *mutArray = [[NSMutableArray alloc]init];
  [dic setObject:mutArray forKey:@"#"];
 
  
//  NSMutableArray *resultArray = [[NSMutableArray alloc]init];
 
  
  ABAddressBookRef addressBookRef = [self getAddressBookRef];
  if (addressBookRef == nil) {
    NSLog(@"读取通讯录失败");
    return nil;
  }
  //获取所有本地的通讯录
  NSArray * records = (__bridge NSArray *)ABAddressBookCopyArrayOfAllPeople(addressBookRef);

  
  
  for (id record in records) {
      //单个联系人对象
      ABRecordRef recordRef = (__bridge ABRecordRef)record;
      
      NSString *firstName = (__bridge NSString *)ABRecordCopyValue(recordRef, kABPersonFirstNameProperty);
      NSString *lastName = (__bridge NSString *)ABRecordCopyValue(recordRef, kABPersonLastNameProperty);
      NSString *companyName = (__bridge NSString *)ABRecordCopyValue(recordRef, kABPersonOrganizationProperty);

      //姓名
      NSString *name  = nil ;
      if(firstName!=nil || lastName!=nil){
        
        name = [NSString stringWithFormat:@"%@%@",lastName==nil?@"":lastName,firstName==nil?@"":firstName];
      
      }else{
        
        if(companyName!=nil){
          name = [NSString stringWithFormat:@"%@",companyName];
        }
        
      }
    
    
    
      //手机号 可能会有多个
      ABMultiValueRef phoneProperty = ABRecordCopyValue(recordRef, kABPersonPhoneProperty);
      //将多值属性的多个值转化为数组
      NSArray * phoneArray = CFBridgingRelease(ABMultiValueCopyArrayOfAllValues(phoneProperty));
      for (int index = 0; index < phoneArray.count; index++) {
        NSString *phone = [phoneArray objectAtIndex:index];
        
        if([phone hasPrefix:@"1"] || [phone hasPrefix:@"+86"]){
          NSMutableDictionary *resultDic = [[NSMutableDictionary alloc]init];
          [resultDic setObject:name==nil?phone:name forKey:@"name"];
          [resultDic setObject:phone forKey:@"phone"];
          
          //        [resultArray addObject:resultDic];
          
          
          NSString *str= [NSString stringWithFormat:@"%c",pinyinFirstLetter([name characterAtIndex:0])] ;
          NSString *upper=[str uppercaseString];
          
          NSMutableArray *array = [dic objectForKey:upper];
          if(array==nil){
            [[dic objectForKey:@"#"] addObject:resultDic];
          }else{
            [[dic objectForKey:upper] addObject:resultDic];
          }
        }
        
      }

      if (recordRef) {
        CFRelease(recordRef);
      }
  }
  return dic;
  
}


//-(void)gcdGetFirstLetter:(NSMutableArray *)resultArray andDic:(NSMutableDictionary *)resultDic{
//  
//  __block NSMutableDictionary * result = [[NSMutableDictionary alloc]init];
//  
//  int count = [[NSString stringWithFormat:@"%lu",(unsigned long)[resultArray count]] intValue];
//  
//  int midCount = count%2==0?count/2:(count+1)/2 ;
//  
//  NSArray *firstArray = [resultArray subarrayWithRange:NSMakeRange(0, midCount)];
//  NSArray *sencondArray = [resultArray subarrayWithRange:NSMakeRange(midCount, count-midCount)];
//  
//  
//  __block NSMutableDictionary * dic = resultDic;
//  
//  dispatch_group_t group = dispatch_group_create();
//  
//  dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
//    
//    for (int i=0;i<[firstArray count];i++){
//     
//      NSMutableArray *array = [dic objectForKey:[self getFirstLetterFromString:firstArray[i][@"name"]]];
//              if(array==nil){
//                [[dic objectForKey:@"#"] addObject:firstArray[i]];
//              }else{
//                [[dic objectForKey:[self getFirstLetterFromString:firstArray[i][@"name"]]] addObject:firstArray[i]];
//              }
//    }
//    
//  });
//  
//  dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
//    
//    for (int i=0;i<[sencondArray count];i++){
//      NSMutableArray *array = [dic objectForKey:[self getFirstLetterFromString:sencondArray[i][@"name"]]];
//      if(array==nil){
//        [[dic objectForKey:@"#"] addObject:sencondArray[i]];
//      }else{
//        [[dic objectForKey:[self getFirstLetterFromString:sencondArray[i][@"name"]]] addObject:sencondArray[i]];
//      }
//    }
//    
//  });
//  
//  dispatch_group_notify(group, dispatch_get_global_queue(0, 0), ^{
//    
//      result = [[NSMutableDictionary alloc]initWithDictionary:dic];
//      self.callBack(@[[NSNull null], result]);
//  });
//  
// 
//}
//
//
//
////获取字符串首字母(传入汉字字符串, 返回大写拼音首字母)
//- (NSString *)getFirstLetterFromString:(NSString *)aString
//{
//  //转成了可变字符串
//  NSMutableString *str = [NSMutableString stringWithString:aString];
//  //先转换为带声调的拼音
//  CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformMandarinLatin,NO);
//  //再转换为不带声调的拼音
//  CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformStripDiacritics,NO);
//  //转化为大写拼音
//  NSString *strPinYin = [str capitalizedString];
//  //获取并返回首字母
//  return [strPinYin substringToIndex:1];
//}



@end
