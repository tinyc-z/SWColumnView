//
//  SWColumnViewCell.m
//  SWColumnView Demo
//
//  Created by iBcker on 14-3-30.
//  Copyright (c) 2014年 iBcker. All rights reserved.
//

#import "SWColumnViewCell.h"
@interface SWColumnViewCell()
@property(nonatomic,assign)NSInteger index;

@end


@implementation SWColumnViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.title=[[UILabel alloc] initWithFrame:CGRectZero];
        self.title.textAlignment = NSTextAlignmentCenter;
        self.title.backgroundColor=[UIColor clearColor];
        [self addSubview:self.title];

    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.title.frame=CGRectMake(0, 10, self.frame.size.width, 30);
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
    self.title.text=nil;
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
