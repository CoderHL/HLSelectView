//
//  HLSelectView.h
//  listView
//
//  Created by 刘洪 on 2018/12/4.
//  Copyright © 2018年 刘洪. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HLSelectView;
// 监听cell上的按钮点击需要注册此通知
//extern NSString *const HLNotificationReadBtnClick;
// 用于设置cell子控件对应的key,不需要外部设置的一定不要设置
extern NSString *const HLCellKeyOfFirstSubview;
extern NSString *const HLCellKeyOfSecondSubview;
extern NSString *const HLCellKeyOfThirdSubview;
extern NSString *const HLCellKeyOfFourSubview;
@protocol HLSelectViewDataSource<NSObject>
@required
- (NSArray *_Nullable)datasWithSelectView:(HLSelectView *)selectView;
//用于设置cell对应子控件的值
- (NSDictionary *)dictionaryWithCellValuesForKeys;
@optional
- (UIView *)responseViewWithPoint:(CGPoint)point andEvent:(UIEvent *)event;
@end

@protocol HLSelectViewDelegate <NSObject>

- (void)selectView:(HLSelectView *)selectView didSelectRowAtIndex:(NSInteger)index;

@end

@interface HLSelectView : UIView

- (instancetype _Nonnull )initWithFrame:(CGRect)frame andTitle:(NSString *_Nullable)title;

@property (nonatomic,weak,nullable) id<HLSelectViewDataSource> dataSource;

@property (nonatomic,weak,nullable) id<HLSelectViewDelegate> delegate;

@property (nonatomic, assign) CGFloat minY;//浮框允许的最小Y值,即最高处

@end
