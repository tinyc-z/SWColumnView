//
//  SWPagingViewCell.h
//  SWColumnViewDemo
//
//  Created by iBcker on 14-4-2.
//  Copyright (c) 2014年 iBcker. All rights reserved.
//

#import "SWColumnViewCell.h"
#import "SWPagingProtocol.h"

@interface SWPagingViewCell : SWColumnViewCell

@property (nonatomic,strong)UIView<SWPagingContentViewProtocol> *contentView;

@property (nonatomic,assign)UIEdgeInsets contentInsets;
@property (nonatomic,assign)BOOL isInClipBounds;

/**
 *
 *  @param SWPagingContentViewProtocol view
 *
 *  @return cell
 */
-(id)initWithContentView:(UIView<SWPagingContentViewProtocol> *)view;

@end
