//
//  HLDemoObject.h
//  listView
//
//  Created by 刘洪 on 2018/12/4.
//  Copyright © 2018年 刘洪. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HLDemoObject : NSObject

+ (instancetype)demoObjecWithSourceName:(NSString *)sourceName sourceUrl:(NSString *)sourceUrl;

@property (nonatomic, copy, readonly) NSString *sourceName;
@property (nonatomic, copy, readonly) NSString *sourceUrl;

@end
