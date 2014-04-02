//
//  SWPagingViewCell.m
//  SWColumnViewDemo
//
//  Created by iBcker on 14-4-2.
//  Copyright (c) 2014年 iBcker. All rights reserved.
//

#import "SWPagingViewCell.h"

@implementation SWPagingViewCell

- (void)prepareForReuse
{
    [super prepareForReuse];
    self.isInClipBounds=NO;
}

@end
