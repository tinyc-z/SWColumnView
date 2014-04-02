//
//  SWPagingView.h
//  SinaWeather
//
//  Created by iBcker on 14-4-2.
//
//

#import "SWColumnView.h"

@class SWPagingView;

@interface SWColumnViewCell (uitls)
@property (nonatomic,assign)BOOL isShow;
@end

@protocol SWPagingViewDelegate <NSObject,UIScrollViewDelegate>

@optional
//SWColumnViewDelegate forward
- (void)pageView:(SWColumnView *)page didSelectIndex:(NSInteger)index;

- (void)pageView:(SWColumnView *)page willLoadIndex:(NSInteger)index;
- (void)pageView:(SWColumnView *)page didLoadIndex:(NSInteger)index;

- (void)pageView:(SWColumnView *)page willUnLoadIndex:(NSInteger)index;
- (void)pageView:(SWColumnView *)page didUnLoadIndex:(NSInteger)index;


//current delegate
- (void)pageViewDidScroll:(SWPagingView *)page;
- (void)pageView:(SWPagingView *)page didStopInIndex:(NSInteger)index;

- (void)pageView:(SWColumnView *)columnView didAppearIndex:(NSInteger)index;
- (void)pageView:(SWColumnView *)columnView didDisAppearIndex:(NSInteger)index;


@end


@interface SWPagingView : SWColumnView
@property (nonatomic,assign)CGFloat enqueueReusableCellPaddingLeft;
@property (nonatomic,assign)CGFloat enqueueReusableCellPaddingRight;

@property (nonatomic,assign)id delegate;

@end