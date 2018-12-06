//
//  HLSelectView.h
//  listView
//
//  Created by 刘洪 on 2018/12/4.
//  Copyright © 2018年 刘洪. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HLSelectView;

@protocol HLSelectViewDataSource<NSObject>
@required
- (NSArray *_Nullable)datasWithSelectView:(HLSelectView *)selectView ;

@end
// 监听cell上的按钮点击需要注册此通知
extern NSString *const HLNotificationReadBtnClick;
@interface HLSelectView : UIView

- (instancetype _Nonnull )initWithFrame:(CGRect)frame andTitle:(NSString *_Nullable)title;

@property (nonatomic,strong,nullable) id<HLSelectViewDataSource> dataSource;

@property (nonatomic, assign) CGFloat minY;//浮框允许的最小Y值,即最高处

@end
