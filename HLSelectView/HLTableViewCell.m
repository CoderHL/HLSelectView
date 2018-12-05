//
//  hltableViewCell.m
//  listView
//
//  Created by 刘洪 on 2018/12/4.
//  Copyright © 2018年 刘洪. All rights reserved.
//

#import "HLTableViewCell.h"

@interface UIView(HLTableViewCellExtension)
- (void)hlt_setOrigin:(CGPoint)origin;
- (CGFloat)hlt_x;
- (CGFloat)hlt_y;
- (CGFloat)hlt_width;
- (CGFloat)hlt_height;
- (void)setHlt_width:(CGFloat)hlt_width;
@end

@implementation UIView(HLTableViewCellExtension)
- (void)hlt_setOrigin:(CGPoint)origin
{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}
- (CGFloat)hlt_x
{
    return self.frame.origin.x;
}
- (CGFloat)hlt_y
{
    return self.frame.origin.y;
}
- (CGFloat)hlt_width
{
    return self.bounds.size.width;
}
- (CGFloat)hlt_height
{
    return self.bounds.size.height;
}

- (void)setHlt_width:(CGFloat)hlt_width
{
    CGRect frame = self.frame;
    frame.size.width = hlt_width;
    self.frame = frame;
}
- (void)setHlt_height:(CGFloat)hlt_height
{
    CGRect frame = self.frame;
    frame.size.height = hlt_height;
    self.frame = frame;
}

- (void)setHlt_y:(CGFloat)hlt_y
{
    CGRect frame = self.frame;
    frame.origin.y = hlt_y;
    self.frame = frame;
}
- (void)setHlt_x:(CGFloat)hlt_x
{
    CGRect frame = self.frame;
    frame.origin.x = hlt_x;
    self.frame = frame;
}

@end

@interface HLTableViewCell()
@property (nonatomic, weak) UILabel *sourceName;
@property (nonatomic, weak) UILabel *urlLabel;
@property (nonatomic, weak) UILabel *selectedPercent;
@property (nonatomic, weak) UIButton *readBtn;
@end
NSString *const fontName_ = @"PingFangSC-Medium";
NSString *const NSNotificationReadBtnClick = @"readBtnClick";
@implementation HLTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self p_settingSubviews];
    }
    return self;
}

-(void)p_settingSubviews
{
    {
        UILabel *sourceName = [[UILabel alloc]init];
        sourceName.layer.backgroundColor = [UIColor colorWithRed:146/255.0 green:154/255.0 blue:163/255.0 alpha:1.0].CGColor;
        sourceName.textAlignment = NSTextAlignmentCenter;
        [self addSubview:sourceName];
        self.sourceName = sourceName;
    }
    
    {
        UILabel *urlLable = [[UILabel alloc]init];
        urlLable.textAlignment = NSTextAlignmentLeft;
        [self addSubview:urlLable];
        self.urlLabel = urlLable;
    }
    
    {
        UILabel *selectedPercent = [[UILabel alloc]init];
        [self addSubview:selectedPercent];
        self.selectedPercent = selectedPercent;
    }
    
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.layer.backgroundColor = [UIColor colorWithRed:238/255.0 green:71/255.0 blue:69/255.0 alpha:0.1].CGColor;
        NSAttributedString *string = [[NSAttributedString alloc]initWithString:@"免费读" attributes: @{NSFontAttributeName: [UIFont fontWithName:fontName_ size: 12],NSForegroundColorAttributeName: [UIColor colorWithRed:238/255.0 green:71/255.0 blue:69/255.0 alpha:1.0]}];
        [btn setAttributedTitle:string forState:UIControlStateNormal];
        [btn setContentEdgeInsets:UIEdgeInsetsMake(5, 15, 5, 15)];
        [btn sizeToFit];
        [btn addTarget:self action:@selector(readBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.layer.cornerRadius = btn.hlt_height/2.0;
        
        [self addSubview:btn];
        self.readBtn = btn;
    }
    
}


- (void)readBtnClick:(UIButton *)readBtn
{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NSNotificationReadBtnClick object:[NSNotification notificationWithName:NSNotificationReadBtnClick object:nil] userInfo:@{@"url":_urlLabel.text}];
}

-(void)setDataModel:(id)dataModel
{
    _sourceName.attributedText = [[NSAttributedString alloc]initWithString:[dataModel valueForKey:@"sourceName"] attributes:@{NSFontAttributeName: [UIFont fontWithName:fontName_ size: 10],NSForegroundColorAttributeName: [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]}];
    [_sourceName sizeToFit];
    _sourceName.hlt_width = _sourceName.hlt_width+10;
    _sourceName.layer.cornerRadius = 4;
    
    _selectedPercent.textAlignment = NSTextAlignmentRight;
    _selectedPercent.attributedText = [[NSAttributedString alloc]initWithString:[dataModel valueForKey:@"selectedStr"] attributes:@{NSFontAttributeName: [UIFont fontWithName:fontName_ size: 10],NSForegroundColorAttributeName: [UIColor colorWithRed:189/255.0 green:189/255.0 blue:189/255.0 alpha:1.0]}];
    [_selectedPercent sizeToFit];
    
    _urlLabel.attributedText = [[NSAttributedString alloc]initWithString:[dataModel valueForKey:@"sourceUrl"] attributes:@{NSFontAttributeName: [UIFont fontWithName:fontName_ size: 14],NSForegroundColorAttributeName: [UIColor colorWithRed:146/255.0 green:154/255.0 blue:163/255.0 alpha:1.0]}];
    [_urlLabel sizeToFit];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    CGPoint point;
    //sourceName
    point = CGPointMake(15, (self.hlt_height-_sourceName.hlt_height)/2.0);
    [_sourceName hlt_setOrigin:point];
   
    //readBtn
    point = CGPointMake(self.hlt_width - 15-_readBtn.hlt_width, (self.hlt_height-_readBtn.hlt_height)/2.0);
    [_readBtn hlt_setOrigin:point];
    
    //selectedPercent
    point = CGPointMake(_readBtn.hlt_x-8-_selectedPercent.hlt_width, (self.hlt_height-_selectedPercent.hlt_height)/2.0);
    [_selectedPercent hlt_setOrigin:point];
    
    //urlLabel
    point = CGPointMake(CGRectGetMaxX(_sourceName.frame)+8, (self.hlt_height-_urlLabel.hlt_height)/2.0);
    _urlLabel.frame = (CGRect){.origin=point, .size=CGSizeMake(_selectedPercent.hlt_x-15-point.x, _urlLabel.hlt_height)};

}





@end



