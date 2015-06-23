//
//  SWPagingDataSourceProtocol.h
//  SWColumnViewDemo
//
//  Created by iBcker on 14-4-3.
//  Copyright (c) 2014年 iBcker. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SWPagingContentViewProtocol <NSObject>
@optional
@property(nonatomic,assign)CGFloat offset;

@required
-(void)setContent:(id)data ext:(id)ext;
@end
