//
//  SWPagingView.h
//  SinaWeather
//
//  Created by iBcker on 14-4-2.
//
//

#import "SWColumnView.h"
#import "SWPagingViewCell.h"

@class SWPagingView;

@protocol SWPagingViewDelegate <NSObject,UIScrollViewDelegate>

@optional
//SWColumnViewDelegate forward
- (void)pageView:(SWColumnView *)page didSelectIndex:(NSInteger)index;

- (void)pageView:(SWColumnView *)page willLoadIndex:(NSInteger)index;
- (void)pageView:(SWColumnView *)page didLoadIndex:(NSInteger)index;

- (void)pageView:(SWColumnView *)page willUnLoadIndex:(NSInteger)index;
- (void)pageView:(SWColumnView *)page didUnLoadIndex:(NSInteger)index;


- (void)pageViewDidScroll:(SWPagingView *)page;
- (void)pageView:(SWPagingView *)page didStopInIndex:(NSInteger)index;

/**
 *  在enqueueReusableCellPadding>0时，下一个界面生成会先与到达clipsToBounds边界，所以
 *  在enqueueReusableCellPadding>0的时候会起错用，用于检测页面进入clipsToBounds范围。
 */
- (void)pageView:(SWColumnView *)page didAppearIndex:(NSInteger)index;
- (void)pageView:(SWColumnView *)page didDisAppearIndex:(NSInteger)index;


@end


@interface SWPagingView : SWColumnView
/**
 *  定义距离可视范围边界还有远时生成界面
 */
@property (nonatomic,assign)CGFloat enqueueReusablePadding;
@property (nonatomic,weak)id delegate;

@end