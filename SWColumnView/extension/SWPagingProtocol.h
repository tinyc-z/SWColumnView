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
@property(nonatomic,assign)CGFloat offset; //可以实现setter辅助实现两边缩小效果（配合clipInset使用）

///fill data 二选一
@optional
-(void)setContent:(id)data;//废弃
@required
-(void)setContent:(id)data ext:(id)ext;
@end
