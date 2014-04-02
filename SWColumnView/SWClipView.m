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
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.clipsToBounds=NO;
    }
    return self;
}

- (void)setClipPadding:(CGFloat)clipPadding
{
    self.enqueueReusableCellPadding=clipPadding;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
