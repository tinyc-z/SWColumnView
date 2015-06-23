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
#import "UIView+Sizes.h"


@interface SWPagingView()<SWColumnViewDelegate>
@end

@implementation SWPagingView
{
    struct {
        unsigned int dlgdidSelectIndex : 1;
        unsigned int dlgWillLoadIndex : 1;
        unsigned int dlgDidLoadIndex : 1;
        unsigned int dlgWillUnLoadIndex : 1;
        unsigned int dlgDidUnLoadIndex : 1;
        unsigned int dlgDidScroll : 1;
        unsigned int dlgDidStopInIndex : 1;
        unsigned int dlgDidAppearIndex : 1;
        unsigned int dlgDidDisAppearIndex : 1;
    } _flags;
}

@synthesize delegate=delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.pagingEnabled=YES;
        self.enqueueReusableInset=UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return self;
}


- (void)dealloc
{
    super.delegate=nil;
    delegate=nil;
    self.dataSource=nil;
}

- (void)setDelegate:(id)d
{
    if (d) {
        super.delegate=self;
    }else{
        super.delegate=nil;
    }
    delegate=d;
    _flags.dlgdidSelectIndex=[d respondsToSelector:@selector(pageView:didSelectIndex:)];
    _flags.dlgWillLoadIndex=[d respondsToSelector:@selector(pageView:willLoadIndex:)];
    _flags.dlgDidLoadIndex=[d respondsToSelector:@selector(pageView:didLoadIndex:)];
    _flags.dlgWillUnLoadIndex=[d respondsToSelector:@selector(pageView:willUnLoadIndex:)];
    _flags.dlgDidUnLoadIndex=[d respondsToSelector:@selector(pageView:didUnLoadIndex:)];
    _flags.dlgDidScroll=[d respondsToSelector:@selector(pageViewDidScroll:)];

    _flags.dlgDidStopInIndex=[d respondsToSelector:@selector(pageView:didStopInIndex:)];
    _flags.dlgDidAppearIndex=[d respondsToSelector:@selector(pageView:didAppearIndex:)];
    _flags.dlgDidDisAppearIndex=[d respondsToSelector:@selector(pageView:didDisAppearIndex:)];
}

- (id)delegate
{
    return  super.delegate;
}

- (CGFloat)contentBundsLeft
{
    return self.clipsBundsLeft-self.enqueueReusableInset.left;
}

- (CGFloat)contentBundsRight
{
    return self.clipsBundsRight+self.enqueueReusableInset.right;
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


- (NSUInteger)currentPageIndex
{
    CGPoint offset = self.contentOffset;
    NSUInteger currentPage = roundf((offset.x) / (self.size.width));
    return currentPage;
}

- (void)layoutVisibleCells
{
    [super layoutVisibleCells];
    if (!self.window) {
        return;
    }
    if (self.enqueueReusableInset.left>0||self.enqueueReusableInset.right>0) {
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
                    if (_flags.dlgDidAppearIndex) {
                        [delegate pageView:self didAppearIndex:cell.index];
                    }
                }
            }else{
                if (cell.isInClipBounds) {
                    cell.isInClipBounds=NO;
                    if (_flags.dlgDidDisAppearIndex) {
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
    if (_flags.dlgdidSelectIndex) {
         [delegate pageView:self didSelectIndex:index];
    }
}

- (void)columnView:(SWColumnView *)columnView willLoadIndex:(NSInteger)index
{
    if (_flags.dlgWillLoadIndex) {
        [delegate pageView:self willLoadIndex:index];
    }
}

- (void)columnView:(SWColumnView *)columnView didLoadIndex:(NSInteger)index
{
    if (_flags.dlgDidLoadIndex) {
        [delegate pageView:self didLoadIndex:index];
    }
}

- (void)columnView:(SWColumnView *)columnView willUnLoadIndex:(NSInteger)index
{
    if (_flags.dlgWillUnLoadIndex) {
        [delegate pageView:self willUnLoadIndex:index];
    }
}

- (void)columnView:(SWColumnView *)columnView didUnLoadIndex:(NSInteger)index
{
    if (_flags.dlgDidUnLoadIndex) {
        [delegate pageView:self didUnLoadIndex:index];
    }
}

#pragma mark --UIScrollView delegate--
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (_flags.dlgDidStopInIndex) {
        NSInteger index = (scrollView.contentOffset.x-scrollView.contentInset.left)/CGRectGetWidth(self.frame);
        [delegate pageView:self didStopInIndex:index];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_flags.dlgDidScroll) {
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
