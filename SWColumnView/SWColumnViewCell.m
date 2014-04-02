//
//  SWColumnViewCell.m
//  SWColumnView Demo
//
//  Created by iBcker on 14-3-30.
//  Copyright (c) 2014年 iBcker. All rights reserved.
//

#import "SWColumnViewCell.h"
@interface SWColumnViewCell()

@end


@implementation SWColumnViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if(self=[self initWithFrame:CGRectZero]){
        _reuseIdentifier = reuseIdentifier;
    }
    return self;
}

- (void)prepareForReuse
{
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
