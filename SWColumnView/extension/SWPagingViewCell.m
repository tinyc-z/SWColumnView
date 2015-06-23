//
//  SWPagingViewCell.m
//  SWColumnViewDemo
//
//  Created by iBcker on 14-4-2.
//  Copyright (c) 2014年 iBcker. All rights reserved.
//

#import "SWPagingViewCell.h"

@interface SWPagingViewCell()

@end

@implementation SWPagingViewCell


-(id)initWithContentView:(UIView<SWPagingContentViewProtocol> *)view
{
    if (self=[super initWithReuseIdentifier:NSStringFromClass(view.class)]) {
        self.contentView = view;
        [self addSubview:self.contentView];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    self.contentView.frame=UIEdgeInsetsInsetRect(self.bounds, self.contentInsets);
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    self.isInClipBounds=NO;
}

@end
