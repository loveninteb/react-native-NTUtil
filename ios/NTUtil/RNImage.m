//
//  RNImage.m
//  TCShopAPP
//
//  Created by 孝辰 吴 on 16/7/28.
//  Copyright © 2016年 Facebook. All rights reserved.
//

#import "RNImage.h"

@implementation RNImage

+(void)saveImage:(NSArray *)array andCallBack:(RCTResponseSenderBlock)callback{
  
  
  dispatch_async(dispatch_get_global_queue(0, 0), ^{
    
    @try {
      
      for(int i=0;i<[array count];i++){
        
        NSData *data =[NSData dataWithContentsOfURL:[NSURL URLWithString:array[i]]];
        
        UIImage *image = [UIImage imageWithData:data];
        
        UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);
        
      }
      callback(@[@YES]);
    } @catch (NSException *exception) {
      callback(@[@NO]);
    }
    
  });
}


@end
