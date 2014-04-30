//
//  SWCDataSource.h
//  SWColumnViewDemo
//
//  Created by iBcker on 14-4-3.
//  Copyright (c) 2014年 iBcker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SWColumnView.h"

extern NSString *const kSWPCellIdentifierKey;
extern NSString *const kSWPCellContentKey;
extern NSString *const kSWPCellExextendDataKey;

extern NSDictionary *SWPCellMake(NSString *identifier, id content, id ext);

@interface SWPagingDataSource : NSObject<SWColumnViewDataSource>
@property(nonatomic,strong)NSArray *objs;

- (void)onCreate:(id)cell atIndex:(NSInteger)index;
- (void)onConfig:(id)cell atIndex:(NSInteger)index;

@end
