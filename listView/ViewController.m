//
//  ViewController.m
//  listView
//
//  Created by 刘洪 on 2018/12/3.
//  Copyright © 2018年 刘洪. All rights reserved.
//

#import "ViewController.h"
#import "HLSelectView.h"
#import "HLDemoObject.h"
@interface ViewController ()<HLSelectViewDataSource>

@property (nonatomic, strong) NSMutableArray *datas;

@property (nonatomic, weak) HLSelectView *selectView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"frame == %@",NSStringFromCGRect(self.view.frame));
    HLSelectView *selectView = [[HLSelectView alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-300, self.view.bounds.size.width, 300) andTitle:@"检测到网友常用以下的站点免费阅读<<感冒让我走向地狱后重生到清朝当王爷>>"];
    selectView.dataSource = self;
    [self.view addSubview:selectView];
    self.selectView = selectView;
    self.datas = [NSMutableArray array];
    HLDemoObject *object;
    for (int i=0; i<2; i++) {
       object = [HLDemoObject demoObjecWithSourceName:[NSString stringWithFormat:@"起点中文网"] sourceUrl:@"www.baidu.com.www.baidu.com.www.baidu.com.www.baidu.com.www.baidu.com"];
        [self.datas addObject:object];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(readBtnClickNotification:) name:HLNotificationReadBtnClick object:nil];
}

- (void)readBtnClickNotification:(NSNotification *)readBtnClickNotification
{
    NSLog(@"%@",readBtnClickNotification.userInfo);
}


#pragma mark -- HLSelectViewDataSource

- (NSArray * _Nullable)datasWithSelectView:(HLSelectView *)selectView {
    return self.datas;
}

- (UIView *)responseViewWithPoint:(CGPoint)point andEvent:(UIEvent *)event
{
    return nil;
}

- (NSDictionary *)dictionaryWithCellValuesForKeys
{
    return @{
             HLCellKeyOfFirstSubview:@"sourceName",
             HLCellKeyOfSecondSubview:@"sourceUrl",
             HLCellKeyOfThirdSubview:@"selectedStr"
             };
}



@end
