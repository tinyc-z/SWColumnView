//
//  SWPagingDataSourceProtocol.h
//  SWColumnViewDemo
//
//  Created by iBcker on 14-4-3.
//  Copyright (c) 2014年 iBcker. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SWPagingContentViewProtocol <NSObject>

@required
///fill data
-(void)setContent:(id)data;

@end
