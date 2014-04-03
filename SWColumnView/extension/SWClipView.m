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
    self.enqueueReusablePadding=clipPadding;
}


@end
