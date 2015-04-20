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
-(void)setContent:(id)data;//废弃
-(void)setContent:(id)data ext:(id)ext;

@end
