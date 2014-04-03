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
        [tmp addObject:@{kSWPCellIdentifierKey:@"MyPageText",
                        kSWPCellContentKey:@"hello1"
                        }];
        [tmp addObject:@{kSWPCellIdentifierKey:@"MyPageImge",
                         kSWPCellContentKey:[UIImage imageNamed:@"yellowBoy.jpg"]
                         }];
        [tmp addObject:@{kSWPCellIdentifierKey:@"MyPageText",
                         kSWPCellContentKey:@"hello2"
                         }];
        [tmp addObject:@{kSWPCellIdentifierKey:@"MyPageImge",
                         kSWPCellContentKey:[UIImage imageNamed:@"yellowBoy.jpg"]
                         }];
        [tmp addObject:@{kSWPCellIdentifierKey:@"MyPageText",
                         kSWPCellContentKey:@"hello3"
                         }];
        self.objs=tmp;
    }
    return self;
}

- (void)onCreate:(SWPagingViewCell *)cell atIndex:(NSInteger)index
{
    cell.backgroundColor=[UIColor colorWithRed:(rand()%10)/10.f green:(rand()%10)/10.f blue:(rand()%10)/10.f alpha:1];
}

@end
