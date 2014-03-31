//
//  ViewController.m
//  SWColumnViewDemo
//
//  Created by iBcker on 14-3-31.
//  Copyright (c) 2014年 iBcker. All rights reserved.
//

#import "ViewController.h"
#import "SWColumnView.h"

@interface ViewController ()<SWColumnViewDataSource,SWColumnViewDelegate>
@property (nonatomic,strong)SWColumnView *tableView;
@property (nonatomic,strong)NSMutableArray *datas;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView = [[SWColumnView alloc] initWithFrame:self.view.bounds];
    //    self.tableView.alwaysBounceHorizontal=YES;
//    self.tableView.contentInset=UIEdgeInsetsMake(10, 50, 5, 0);
    //    UILabel *item=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    //    item.backgroundColor=[UIColor redColor];
    
    //    [self.tableView addSubview:item];
    self.tableView.dataSource=self;
    //    self.tableView.pagingEnabled=YES;
    self.tableView.delegate=self;
    [self.view addSubview:self.tableView];
	// Do any additional setup after loading the view, typically from a nib.
    NSLog(@"viewDidLoad");
    self.datas=[[NSMutableArray alloc] init];
    for (NSInteger i=0; i<50; i++) {
        [self.datas addObject:@(i)];
    }
    
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

- (SWColumnViewCell *)columnView:(SWColumnView *)pagingView cellForLineAtIndex:(NSInteger)index
{
    static NSString *identifiter = @"cell";
    SWColumnViewCell *cell = [pagingView dequeueReusableCellWithIdentifier:identifiter];
    if (!cell) {
        cell = [[SWColumnViewCell alloc] initWithReuseIdentifier:identifiter];
        cell.backgroundColor=[UIColor colorWithRed:(rand()%10)/10.f green:(rand()%10)/10.f blue:(rand()%10)/10.f alpha:1];
    }
    return cell;
}

- (CGFloat)columnView:(SWColumnView *)View widthForLineAtIndex:(NSInteger )index
{
    return 20+index*5;
}

- (void)columnView:(SWColumnView *)view didSelectIndex:(NSInteger)index
{
    NSLog(@"didSelectIndex%@",[view indexsForVisibleRows]);
    
    [self.datas removeObjectAtIndex:index];
    
    [view scrollToStart:YES];
}

@end
