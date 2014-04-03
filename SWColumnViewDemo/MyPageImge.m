//
//  MyPage2.m
//  SWColumnViewDemo
//
//  Created by iBcker on 14-4-3.
//  Copyright (c) 2014年 iBcker. All rights reserved.
//

#import "MyPageImge.h"
@interface MyPageImge()
@property (nonatomic,strong)UIImageView *image;
@end

@implementation MyPageImge

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.image = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.image.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self addSubview:self.image];
        // Initialization code
    }
    return self;
}

- (void)setContent:(UIImage *)data
{
    self.image.image=data;
}


@end
