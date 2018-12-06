//
//  HLTableViewCell.h
//  listView
//
//  Created by 刘洪 on 2018/12/4.
//  Copyright © 2018年 刘洪. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^readBtnClickBlock)(void);

@interface UIView(hltableViewCellExtension)
- (void)hlt_setOrigin:(CGPoint)origin;
- (CGFloat)hlt_x;
- (CGFloat)hlt_y;
- (CGFloat)hlt_width;
- (CGFloat)hlt_height;
- (void)setHlt_width:(CGFloat)hlt_width;
- (void)setHlt_height:(CGFloat)hlt_height;
- (void)setHlt_y:(CGFloat)hlt_y;
- (void)setHlt_x:(CGFloat)hlt_x;
@end
extern NSString *const fontName_;
extern NSString *const HLNotificationReadBtnClick;
@interface HLTableViewCell : UITableViewCell

@property (nonatomic, strong) id dataModel;

@end
