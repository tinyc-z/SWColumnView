//
//  SWCDataSource.h
//  SWColumnViewDemo
//
//  Created by iBcker on 14-4-3.
//  Copyright (c) 2014年 iBcker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SWColumnView.h"

@interface SWPCellObj : NSObject
@property (nonatomic,strong)NSString *identifier;
@property (nonatomic,strong)id content;
@property (nonatomic,strong)id ext;
@end

extern SWPCellObj *SWPCellMake(NSString *identifier, id content, id ext);

@interface SWPagingDataSource : NSObject<SWColumnViewDataSource>
@property(nonatomic,strong)NSArray *objs;

- (void)onCreate:(id)cell atIndex:(NSInteger)index;
- (void)onConfig:(id)cell atIndex:(NSInteger)index;

@end
