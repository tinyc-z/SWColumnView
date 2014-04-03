//
//  SWPagingView.m
//  SinaWeather
//
//  Created by iBcker on 14-4-2.
//
//

#import "SWPagingView.h"
#import "SWColumnView.h"
#import "SWPagingViewCell.h"


@interface SWPagingView()<SWColumnViewDelegate>
@end

@implementation SWPagingView

@synthesize delegate=delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.pagingEnabled=YES;
        self.enqueueReusablePadding=0;
    }
    return self;
}


- (void)dealloc
{
    super.delegate=nil;
    delegate=nil;
}

- (void)setDelegate:(id)d
{
    super.delegate=self;
    delegate=d;
}

- (id)delegate
{
    return  super.delegate;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}


- (CGFloat)contentBundsLeft
{
    return self.clipsBundsLeft-self.enqueueReusablePadding;
}

- (CGFloat)contentBundsRight
{
    return self.clipsBundsRight+self.enqueueReusablePadding;
}

- (CGFloat)clipsBundsLeft
{
    return self.contentOffset.x;
}

- (CGFloat)clipsBundsRight
{
    return self.contentOffset.x+CGRectGetWidth(self.bounds);
}

- (CGFloat)widthForColumnAtIndex:(NSUInteger)index
{
    return self.frame.size.width;
}



- (void)layoutVisibleCells
{
    [super layoutVisibleCells];
    if (self.enqueueReusablePadding>0) {
        CGFloat frameLeft,frameRight,tmpL,tmpR;
        frameLeft=self.clipsBundsLeft;
        frameRight=self.clipsBundsRight;
        NSArray *cells = self.visibleCells;
        for(SWPagingViewCell *cell in cells){
            tmpL=CGRectGetMinX(cell.frame);
            tmpR=CGRectGetMaxX(cell.frame);
            if((tmpL<frameRight&&tmpL>frameLeft)||(tmpR>frameLeft&&tmpL<frameRight)){
                if (!cell.isInClipBounds) {
                    cell.isInClipBounds=YES;
                    if ([delegate respondsToSelector:@selector(pageView:didAppearIndex:)]) {
                        [delegate pageView:self didAppearIndex:cell.index];
                    }
                }
            }else{
                if (cell.isInClipBounds) {
                    cell.isInClipBounds=NO;
                    if ([delegate respondsToSelector:@selector(pageView:didDisAppearIndex:)]) {
                        [delegate pageView:self didDisAppearIndex:cell.index];
                    }
                }
            }
            
        }
    }
}

//SWColumnViewDelegate
- (void)columnView:(SWColumnView *)columnView didSelectIndex:(NSInteger)index
{
    if([delegate respondsToSelector:@selector(pageView:didSelectIndex:)]){
        [delegate pageView:self didSelectIndex:index];
    }
}

- (void)columnView:(SWColumnView *)columnView willLoadIndex:(NSInteger)index
{
    if([delegate respondsToSelector:@selector(pageView:willLoadIndex:)]){
        [delegate pageView:self willLoadIndex:index];
    }
}

- (void)columnView:(SWColumnView *)columnView didLoadIndex:(NSInteger)index
{
    if([delegate respondsToSelector:@selector(pageView:didLoadIndex:)]){
        [delegate pageView:self didLoadIndex:index];
    }
}

- (void)columnView:(SWColumnView *)columnView willUnLoadIndex:(NSInteger)index
{
    if([delegate respondsToSelector:@selector(pageView:willUnLoadIndex:)]){
        [delegate pageView:self willUnLoadIndex:index];
    }
}

- (void)columnView:(SWColumnView *)columnView didUnLoadIndex:(NSInteger)index
{
    if([delegate respondsToSelector:@selector(pageView:didUnLoadIndex:)]){
        [delegate pageView:self didUnLoadIndex:index];
    }
}

#pragma mark --UIScrollView delegate--
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if([delegate respondsToSelector:@selector(pageView:didStopInIndex:)]){
        [delegate pageView:self didStopInIndex:0];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if([delegate respondsToSelector:@selector(pageViewDidScroll:)]){
        [delegate pageViewDidScroll:self];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        [self scrollViewDidEndDecelerating:scrollView];
    }
}


@end
