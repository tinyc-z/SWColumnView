//
//  SWPagingView.m
//  SinaWeather
//
//  Created by iBcker on 14-4-2.
//
//

#import "SWPagingView.h"
#import "SWColumnView.h"
#import <objc/runtime.h>


@implementation SWColumnViewCell (uitls)
@dynamic isShow;


static NSString *const kColumnViewIsShowKey;

- (void)setIsShow:(BOOL)b
{
    objc_setAssociatedObject(self, &kColumnViewIsShowKey,@(b),OBJC_ASSOCIATION_ASSIGN);
}
- (BOOL)isShow
{
    return [objc_getAssociatedObject(self, &kColumnViewIsShowKey) boolValue];
}

@end

@interface SWPagingView()<SWColumnViewDelegate>
//@property(nonatomic,assign)BOOL pagingEadbled;
@end

@implementation SWPagingView

@synthesize delegate=delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.pagingEnabled=YES;
        self.enqueueReusableCellPaddingLeft=0;
        self.enqueueReusableCellPaddingRight=0;
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

- (CGFloat)contentBundsLeft
{
    return self.clipsBundsLeft-_enqueueReusableCellPaddingLeft;
}

- (CGFloat)contentBundsRight
{
    return self.clipsBundsRight+_enqueueReusableCellPaddingRight;
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
    
    CGFloat frameLeft,frameRight,tmpL,tmpR;
    frameLeft=self.clipsBundsLeft;
    frameRight=self.clipsBundsRight;
    
    for(SWColumnViewCell *cell in self.visibleCells){
        tmpL=CGRectGetMinX(cell.frame);
        tmpR=CGRectGetMaxX(cell.frame);
        if((tmpL<frameRight&&tmpL>frameLeft)||(tmpR>frameLeft&&tmpL<frameRight)){
            if (!cell.isShow) {
                cell.isShow=YES;
                if ([delegate respondsToSelector:@selector(pageView:didAppearIndex:)]) {
                    [delegate pageView:self didAppearIndex:cell.index];
                }
            }
        }else{
            if (cell.isShow) {
                cell.isShow=NO;
                 if ([delegate respondsToSelector:@selector(pageView:didDisAppearIndex:)]) {
                     [delegate pageView:self didDisAppearIndex:cell.index];
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

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        [self scrollViewDidEndDecelerating:scrollView];
    }
}


@end
