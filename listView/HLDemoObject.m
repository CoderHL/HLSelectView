//
//  HLDemoObject.m
//  listView
//
//  Created by 刘洪 on 2018/12/4.
//  Copyright © 2018年 刘洪. All rights reserved.
//

#import "HLDemoObject.h"

@interface HLDemoObject()
@property (nonatomic, copy) NSString *sourceName;
@property (nonatomic, copy) NSString *sourceUrl;
@property (nonatomic, copy) NSString *selectedStr;
@end

@implementation HLDemoObject

static int getRandomNumber(int from, int to)
{
    return (int)(from + (arc4random() % (to - from + 1)));
}

+ (instancetype)demoObjecWithSourceName:(NSString *)sourceName sourceUrl:(NSString *)sourceUrl
{
    HLDemoObject *object = [[self alloc]init];
    object.sourceName = sourceName;
    object.sourceUrl = sourceUrl;
    object.selectedStr = [NSString stringWithFormat:@"%d%%网友选择",getRandomNumber(80,98)];
    return object;
}

@end
