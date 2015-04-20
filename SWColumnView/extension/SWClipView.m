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
