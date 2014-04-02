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

- (SWColumnViewCell *)columnView:(SWColumnView *)columnView cellForColumnIndex:(NSInteger )index;

@optional
- (CGFloat)columnView:(SWColumnView *)columnView widthForColumnAtIndex:(NSInteger )index;

@end


@protocol SWColumnViewDelegate <NSObject,UIScrollViewDelegate>

@optional
- (void)columnView:(SWColumnView *)columnView didSelectIndex:(NSInteger)index;

- (void)columnView:(SWColumnView *)columnView willLoadIndex:(NSInteger)index;
- (void)columnView:(SWColumnView *)columnView didLoadIndex:(NSInteger)index;

- (void)columnView:(SWColumnView *)columnView willUnLoadIndex:(NSInteger)index;
- (void)columnView:(SWColumnView *)columnView didUnLoadIndex:(NSInteger)index;

@end

@interface SWColumnView : UIScrollView

@property (nonatomic,assign)id <SWColumnViewDataSource> dataSource;
@property (nonatomic,assign)id <SWColumnViewDelegate> delegate;

- (void)layoutVisibleCells;//不提倡手动调用

- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier;

- (void)scrollToColumn:(NSInteger)index animate:(BOOL)animate;
- (void)scrollToStart:(BOOL)animate;
- (void)scrollToEnd:(BOOL)animate;

- (void)removeColumn:(NSInteger)index animate:(BOOL)animate;

- (void)reloadData;

- (NSArray *)visibleCells;
- (NSArray *)indexsForVisibleRows;

@end
