//
//  ViewController.m
//  SWColumnViewDemo
//
//  Created by iBcker on 14-3-31.
//  Copyright (c) 2014年 iBcker. All rights reserved.
//

#import "ViewController.h"
#import "SWPagingView.h"
#import "MyPageDataSource.h"


@interface ViewController ()<SWColumnViewDataSource,SWColumnViewDelegate>
@property (nonatomic,strong)SWColumnView *tableView;
@property (nonatomic,strong)NSMutableArray *datas;
@property (nonatomic,strong)MyPageDataSource *dataSource;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView = [[SWColumnView alloc] initWithFrame:CGRectInset(self.view.bounds, 50, 50)];
    
     self.dataSource = [[MyPageDataSource alloc] init];

//    self.tableView.dataSource=self.dataSource;

    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    
    self.tableView.layer.borderColor=[UIColor blackColor].CGColor;
    self.tableView.layer.borderWidth=0.5;
    self.tableView.pagingEnabled=YES;
    
    [self.view addSubview:self.tableView];

    NSLog(@"viewDidLoad");
    self.datas=[[NSMutableArray alloc] init];
    for (NSInteger i=0; i<50000; i++) {
        [self.datas addObject:@(i)];
    }
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)columnViewNumberOfColumns:(SWColumnView *)tableView
{
    return [self.datas count];
}

- (SWColumnViewCell *)columnView:(SWColumnView *)columnView cellForColumnIndex:(NSInteger )index
{
    static NSString *identifiter = @"cell";
    SWPagingViewCell *cell = [columnView dequeueReusableCellWithIdentifier:identifiter];
    if (!cell) {
        cell = [[SWPagingViewCell alloc] initWithReuseIdentifier:identifiter];
        cell.isAccessibilityElement=YES;
        cell.backgroundColor=[UIColor colorWithRed:(rand()%10)/10.f green:(rand()%10)/10.f blue:(rand()%10)/10.f alpha:1];
    }
    return cell;
}

- (CGFloat)columnView:(SWColumnView *)View widthForColumnAtIndex:(NSInteger )index
{
    return (self.view.frame.size.width-100)/3;
}

- (void)pageView:(SWColumnView *)view didSelectIndex:(NSInteger)index
{
    NSLog(@"didSelectIndex%@",[view indexsForVisibleRows]);
    
    [self.datas removeObjectAtIndex:index];
    
    [view scrollToStart:YES];
}

- (void)pageView:(SWPagingView *)page didStopInIndex:(NSInteger)index
{
    NSLog(@"%@",NSStringFromSelector(_cmd));
}

- (void)pageView:(SWPagingView *)page didLoadIndex:(NSInteger)index
{
    NSLog(@"%@",NSStringFromSelector(_cmd));
}

//- (void)pageView:(SWColumnView *)page didUnLoadIndex:(NSInteger)index
//{
//    NSLog(@"%@",NSStringFromSelector(_cmd));
//}


//- (void)pageView:(SWPagingView *)page didAppearIndex:(NSInteger)index
//{
//    NSLog(@"%@:%d",NSStringFromSelector(_cmd),index);
//}
//- (void)pageView:(SWColumnView *)columnView didDisAppearIndex:(NSInteger)index
//{
//    NSLog(@"%@:%d",NSStringFromSelector(_cmd),index);
//}


@end
