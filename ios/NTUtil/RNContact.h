//
//  RNContact.h
//  TCShopAPP
//
//  Created by 孝辰 吴 on 16/6/2.
//  Copyright © 2016年 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>
#import "RCTBridgeModule.h"
#import "pinyin.h"

@interface RNContact : NSObject


@property (nonatomic,strong) RCTResponseSenderBlock callBack;

/**
 *  @author wuxiaochen, 2016-06-02 21:06:12
 *
 *  RN 增加通讯录  主目录
 *
 *  @param companyName 公司别名
 *  @param phoneList   电话列表
 */
-(void) addContact:(NSString *)companyName phoneNumbers:(NSArray *)phoneList withNote:(NSString *)note;

-(NSDictionary *) getAllContactInfo;

@end
