//
//  SWColumnView.h
//  SWColumnView Demo
//
//  Created by iBcker on 14-3-29.
//  Copyright (c) 2014年 iBcker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWColumnViewCell.h"

@class SWColumnView;

@protocol SWColumnViewDataSource <NSObject>

@required
- (NSInteger)columnViewNumberOfColumns:(SWColumnView *)columnView;

- (SWColumnViewCell *)columnView:(SWColumnView *)columnView cellForLineAtIndex:(NSInteger )index;

@optional
- (CGFloat)columnView:(SWColumnView *)columnView widthForLineAtIndex:(NSInteger )index;

@end


@protocol  SWColumnViewDelegate <NSObject,UIScrollViewDelegate>

@optional
- (void)columnView:(SWColumnView *)board didSelectIndex:(NSInteger)index;

@end

@interface SWColumnView : UIScrollView

@property (nonatomic,assign)id <SWColumnViewDataSource> dataSource;
@property (nonatomic,assign)id <SWColumnViewDelegate> delegate;

- (SWColumnViewCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier;

- (void)scrollToColumn:(NSInteger)index animate:(BOOL)animate;
- (void)scrollToStart:(BOOL)animate;
- (void)scrollToEnd:(BOOL)animate;

- (void)removeColumn:(NSInteger)index animate:(BOOL)animate;

- (void)reloadData;

- (NSArray *)visibleCells;
- (NSArray *)indexsForVisibleRows;

@end
