//
//  MyPage3.m
//  SWColumnViewDemo
//
//  Created by iBcker on 14-4-3.
//  Copyright (c) 2014年 iBcker. All rights reserved.
//

#import "MyPageText.h"
@interface MyPageText()
@property(nonatomic,strong)UILabel *text;
@end

@implementation MyPageText

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.text = [[UILabel alloc] initWithFrame:self.bounds];
        [self addSubview:self.text];
        self.text.textAlignment = NSTextAlignmentCenter;

    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.text.frame = self.bounds;
    
}

- (void)setContent:(id)data
{
    self.text.text=data;
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
