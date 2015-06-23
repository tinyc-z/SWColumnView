//
//  SWClipView.m
//  SinaWeather
//
//  Created by iBcker on 14-4-2.
//
//

#import "SWClipView.h"

@implementation SWClipView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.clipsToBounds=NO;
    }
    return self;
}

- (void)layoutVisibleCells
{
    [super layoutVisibleCells];
    NSArray *cells=[self visibleCells];
    for (SWPagingViewCell *item in cells) {
        UIView <SWPagingContentViewProtocol> *contentView=item.contentView;
        if ([contentView respondsToSelector:@selector(setOffset:)]) {
            CGFloat offset = -(self.contentOffset.x-CGRectGetMinX(item.frame))/(item.frame.size.width);
            if (isnan(offset)&&isinf(offset)) {
                offset=0;
            }
            contentView.offset=offset;
//            NSLog(@"%p offset=%f",item,offset);
        }
    }
}

- (void)setClipPadding:(CGFloat)clipPadding
{
    _clipPadding=clipPadding;
    self.clipInset=UIEdgeInsetsMake(0, clipPadding, 0, clipPadding);
}


- (void)setClipInset:(UIEdgeInsets)clipInset
{
    _clipInset=clipInset;
    self.enqueueReusableInset=clipInset;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *resp=[super hitTest:point withEvent:event];
    if (!resp&&self.extendClipTouch) {
        //TODO:: 当clipPadding>self.width时会出bug
        resp=[super hitTest:(CGPoint){point.x+self.clipInset.left,point.y} withEvent:event]
            ?:[super hitTest:(CGPoint){point.x-self.clipInset.left,point.y} withEvent:event];
    }
    return resp;
}

@end
