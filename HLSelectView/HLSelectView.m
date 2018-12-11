//
//  HLSelectView.m
//  listView
//
//  Created by 刘洪 on 2018/12/4.
//  Copyright © 2018年 刘洪. All rights reserved.
//

#import "HLSelectView.h"
#import "HLTableViewCell.h"

#define KZoom_Scale_X ((KScreenWidth)/(375.0))
#define KZoom_Scale_Y ((KScreenHeight)/(667.0))
#define EPSILON 1e-6

@interface HLSelectView()<UITableViewDelegate,UITableViewDataSource>
{
    struct {
        unsigned int datasFlag:1;//是否实现数据源方法
        unsigned int responseViewFlag:1;
        unsigned int cellKeyValuesFlag:1;
        unsigned int didSelectRowFlag:1;
    } _delegateFlags;
    CGFloat _maxY;//浮框允许的最大y,即最低点
    CGRect _frame;
    CGFloat _originY;//记录浮框最初的位置
}
@property (nonatomic, weak) UIView *containView;
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, copy) NSArray *datas;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, weak) UIView *identifyView;
@end

NSString *const HLCellKeyOfFirstSubview = @"firstView";
NSString *const HLCellKeyOfSecondSubview = @"secondView";
NSString *const HLCellKeyOfThirdSubview = @"thirdView";
NSString *const HLCellKeyOfFourSubview = @"fourView";
static CGFloat const KMaxAlpha_ = 0.5;
static CGFloat const KCornerRadiu_ = 12;

@implementation HLSelectView

- (instancetype)init
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"Must use initWithFrame:andTitle: instead" userInfo:nil];
}

-(instancetype)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame andTitle:@""];
}

- (instancetype)initWithFrame:(CGRect)frame andTitle:(NSString *)title
{
    if (self=[super initWithFrame:[UIScreen mainScreen].bounds]) {
        [self p_createTableViewWithFrame:frame];
        self.headerView = [self p_createHeaderViewWithTitle:title];
        [self p_initialSetting];
        _maxY = frame.origin.y;
    }
    return self;
}

- (void)p_initialSetting
{
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    self.minY = _minY ? _minY : self.hlt_height/5.0;
}


- (void)p_createTableViewWithFrame:(CGRect)frame
{
    _frame = frame;
    UIView *containView = [[UIView alloc]initWithFrame:frame];
    containView.layer.shadowColor = [UIColor blackColor].CGColor;
    containView.layer.shadowOffset = CGSizeMake(0, -6);
    containView.layer.shadowOpacity = 1;
    containView.layer.shadowRadius = KCornerRadiu_;
    
    containView.layer.backgroundColor = [UIColor whiteColor].CGColor;
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:containView.bounds];
    containView.layer.shadowPath = path.CGPath;//防止离屏渲染
    
    containView.layer.cornerRadius = KCornerRadiu_;
    //containView.layer.shouldRasterize = YES;//光删化,预先渲染成位图,使用在阴影的lay上提高性能.
    
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:containView.bounds style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.layer.cornerRadius = KCornerRadiu_;
    [self addSubview:containView];
    [containView addSubview:tableView];
    self.tableView = tableView;
    self.tableView.tableFooterView = [UIView new];
    self.containView = containView;
}



- (UIView *)p_createHeaderViewWithTitle:(NSString *)title
{
    //title
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.attributedText = [[NSAttributedString alloc]initWithString:title attributes:@{NSFontAttributeName: [UIFont fontWithName:fontName_ size: 15],NSForegroundColorAttributeName: [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0]}];
    titleLabel.textAlignment = NSTextAlignmentJustified;
    [titleLabel hlt_setOrigin:CGPointMake(15, 26)];
    titleLabel.numberOfLines = 0;
    [titleLabel setHlt_width:self.hlt_width-30];
    [titleLabel sizeToFit];
    
    //headerView
    UIView *headerView = [[UIView alloc]initWithFrame:(CGRect){.origin=CGPointMake(0, 0),.size=CGSizeMake(self.hlt_width, CGRectGetMaxY(titleLabel.frame)+20)}];
    [headerView addSubview:titleLabel];
    headerView.layer.backgroundColor = [UIColor whiteColor].CGColor;
    [self p_cornerView:headerView cornerRadiu:KCornerRadiu_ byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight];
    
    //identifyView
    CGFloat width = 36;
    CGFloat height = 6;
    CGFloat y = 7;
    UIView *identifyView = [[UIView alloc]initWithFrame:CGRectMake((self.hlt_width-width)/2.0, y, width, height)];
    identifyView.layer.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.1].CGColor;
    identifyView.layer.cornerRadius = 3;
    self.identifyView = identifyView;
    [headerView addSubview:identifyView];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(headerViewPan:)];
    [headerView addGestureRecognizer:pan];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headerViewTap:)];
    tap.numberOfTapsRequired = 2;
    [headerView addGestureRecognizer:tap];
    return headerView;
}

- (void)headerViewTap:(UITapGestureRecognizer *)tap
{
    if (tap.state == UIGestureRecognizerStateRecognized) {
        if (fabs(_containView.hlt_y - _maxY)<=EPSILON) {//最下面
            [_containView setHlt_height:self.hlt_height-_minY];
            _tableView.frame = _containView.bounds;
            [self p_springAnimationWithPositionY:_minY andCompletion:nil];
        }else if (fabs(_containView.hlt_y - _minY)<=EPSILON){//最上面
            [self p_springAnimationWithPositionY:_maxY andCompletion:^(BOOL finish) {
                [_containView setHlt_height:_frame.size.height];
                _tableView.frame = _containView.bounds;
            }];
            
        }
    }
}

- (void)headerViewPan:(UIPanGestureRecognizer *)pan
{
    //获取偏移量
    CGPoint transPoint = [pan translationInView:_headerView];
    if (pan.state == UIGestureRecognizerStateBegan) {
        [_containView setHlt_height:self.hlt_height-_minY];
        _tableView.frame = _containView.bounds;
        _originY = _containView.hlt_y;
    }else if (pan.state == UIGestureRecognizerStateChanged){
        //向上 && 没到最高点 || 向下
        if ((transPoint.y < 0 && _containView.hlt_y > _minY) ||
            (transPoint.y > 0 && _containView.hlt_y < _maxY))
        {
            CGFloat alpha = KMaxAlpha_*(_maxY-_containView.hlt_y)/(_maxY-_minY);
            [_containView setHlt_y: _containView.hlt_y + transPoint.y];
            self.layer.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:alpha].CGColor;
        }
        
    }else if (pan.state == UIGestureRecognizerStateEnded){
        CGFloat minusHeight = _maxY - _minY;
        if (_containView.hlt_y<(_maxY-minusHeight/3.0) && fabs(_originY-_maxY) <= EPSILON) {//向上
            [self p_springAnimationWithPositionY:_minY andCompletion:nil];
        }else if (_containView.hlt_y>(_minY+minusHeight/3.0) && fabs(_originY-_minY) <= EPSILON){//向下
            [self p_springAnimationWithPositionY:_maxY andCompletion:^(BOOL finish) {
                [_containView setHlt_height:_frame.size.height];
                _tableView.frame = _containView.bounds;
            }];
        }else{
            [self p_springAnimationWithPositionY:_originY andCompletion:^(BOOL finish) {
                
                if (fabs(_originY-_frame.origin.y) <= EPSILON) {
                    [_containView setHlt_height:_frame.size.height];
                    _tableView.frame = _containView.bounds;
                }
            }];
        }
    }
    //复位
    [pan setTranslation:CGPointZero inView:_headerView];
    
}

- (void)p_springAnimationWithPositionY:(CGFloat)positionY andCompletion:(void(^)(BOOL finish))completion
{
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [_containView setHlt_y:positionY];
        CGFloat alpha =  KMaxAlpha_*(_maxY-_containView.hlt_y)/(_maxY-_minY);
        self.layer.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:alpha].CGColor;
    } completion:completion];
}


- (void)p_cornerView:(UIView *)view cornerRadiu:(CGFloat)cornerRadiu byRoundingCorners:(UIRectCorner)corners
{
    CGRect bounds = view.bounds;
    if ([view isKindOfClass:[UITableView class]]) {
        bounds = (CGRect){.origin=CGPointZero,.size=self.tableView.contentSize};
    }
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:bounds byRoundingCorners:corners cornerRadii:CGSizeMake(cornerRadiu, cornerRadiu)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    maskLayer.path = maskPath.CGPath;
    view.layer.mask = maskLayer;
}


#pragma mark - Setter

-(void)setDataSource:(id<HLSelectViewDataSource>)dataSource
{
    _dataSource = dataSource;
    _delegateFlags.datasFlag = [self.dataSource respondsToSelector:@selector(datasWithSelectView:)];
    _delegateFlags.responseViewFlag = [self.dataSource respondsToSelector:@selector(responseViewWithPoint:andEvent:)];
    _delegateFlags.cellKeyValuesFlag = [self.dataSource respondsToSelector:@selector(dictionaryWithCellValuesForKeys)];
}

-(void)setDelegate:(id<HLSelectViewDelegate>)delegate
{
    _delegate = delegate;
    _delegateFlags.didSelectRowFlag = [self.delegate respondsToSelector:@selector(selectView:didSelectRowAtIndex:)];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = 0;
    if (_delegateFlags.datasFlag) {
        self.datas = [_dataSource datasWithSelectView:self];
        count = _datas.count;
    }
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * const ID = @"HLTableViewCell";
    HLTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[HLTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSDictionary *dictionary;
    if (_delegateFlags.cellKeyValuesFlag) {
        dictionary = [_dataSource dictionaryWithCellValuesForKeys];
    }
    [cell setCellValueWithDataModel:self.datas[indexPath.row] KeyValues:dictionary andIndex:indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return _headerView.hlt_height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    return _headerView;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    
    self.minY = (self.hlt_height - _minY)>tableView.contentSize.height ? self.hlt_height - tableView.contentSize.height : _minY;
    if (_minY > _containView.hlt_y) {
        _identifyView.hidden = YES;
        _minY = _maxY;
    }else{
        _identifyView.hidden = NO;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_delegateFlags.didSelectRowFlag) {
        [_delegate selectView:self didSelectRowAtIndex:indexPath.row];
    }
}

#pragma mark - system
-(void)dealloc
{
    self.headerView = nil;
}

-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *responseView;
    if (point.y < _containView.hlt_y && _delegateFlags.responseViewFlag) {
        responseView = [_dataSource responseViewWithPoint:point andEvent:event];
        responseView = [responseView hitTest:point withEvent:event];
    }else{
        responseView = [super hitTest:point withEvent:event];
    }
    return responseView;
}

@end
