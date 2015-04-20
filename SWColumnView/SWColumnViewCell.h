//
//  SWColumnView.h
//  SWColumnView Demo
//
//  Created by iBcker on 14-3-30.
//  Copyright (c) 2014年 iBcker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SWColumnViewCell : UIView
@property(nonatomic,assign)NSInteger index;
@property(nonatomic,strong,readonly)NSString *reuseIdentifier;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;

- (void)prepareForReuse;
- (void)prepareForRecycle;
@end
