//
//  NSMutableURLRequest+BBModel.h
//  FrameWork
//
//  Created by lonnie on 2017/7/19.
//  Copyright © 2017年 fanyue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"
@interface NSMutableURLRequest (BBModel)
+ (NSMutableURLRequest*) requestWithModel:(requestModel*) model;

+ (NSMutableURLRequest*) requestWithModelSDK:(requestModel*) model;

@end
@interface NSMutableURLRequest (CountBaseModel)
@end
