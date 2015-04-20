//
//  MyPageDataSource.m
//  SWColumnViewDemo
//
//  Created by iBcker on 14-4-3.
//  Copyright (c) 2014年 iBcker. All rights reserved.
//

#import "MyPageDataSource.h"
#import "SWPagingDataSource.h"
#import "SWPagingViewCell.h"

@interface MyPageDataSource()

@end

@implementation MyPageDataSource
- (id)init
{
    if (self=[super init]) {
        NSMutableArray *tmp = [[NSMutableArray alloc] init];
        
        [tmp addObject:SWPCellMake(@"MyPageText",@"hello1",nil)];
        [tmp addObject:SWPCellMake(@"MyPageImge",[UIImage imageNamed:@"yellowBoy.jpg"],nil)];
        [tmp addObject:SWPCellMake(@"MyPageText",@"hello2",nil)];
        [tmp addObject:SWPCellMake(@"MyPageImge",[UIImage imageNamed:@"yellowBoy.jpg"],nil)];
        [tmp addObject:SWPCellMake(@"MyPageText",@"hello3",nil)];
        [tmp addObject:SWPCellMake(@"MyPageText",@"hello4",nil)];
        
        self.objs=tmp;
    }
    return self;
}

- (void)onCreate:(SWPagingViewCell *)cell atIndex:(NSInteger)index
{
    cell.backgroundColor=[UIColor colorWithRed:(rand()%10)/10.f green:(rand()%10)/10.f blue:(rand()%10)/10.f alpha:1];
}

@end
