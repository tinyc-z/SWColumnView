//
//  SWCDataSource.m
//  SWColumnViewDemo
//
//  Created by iBcker on 14-4-3.
//  Copyright (c) 2014年 iBcker. All rights reserved.
//

#import "SWPagingDataSource.h"
#import "SWPagingViewCell.h"
#import "SWPagingView.h"

@implementation SWPCellObj
@end

SWPCellObj *SWPCellMake(NSString *identifier, id content, id ext)
{
    SWPCellObj *obj =[SWPCellObj new];
    obj.identifier=identifier;
    obj.content=content;
    obj.ext=ext;
    return obj;
}

@interface SWPagingDataSource()
@end


@implementation SWPagingDataSource

- (NSInteger)columnViewNumberOfColumns:(SWColumnView *)columnView
{
    return [self.objs count];
}

- (void)onCreate:(SWPagingViewCell *)cell atIndex:(NSInteger)index
{
    
}

- (void)onConfig:(SWPagingViewCell *)cell atIndex:(NSInteger)index
{
    
}

- (id)columnView:(SWPagingView *)page cellForColumnIndex:(NSInteger )index
{
    SWPCellObj *item = self.objs[index];
    NSString *identifier = item.identifier;
    Class clazz = NSClassFromString(identifier);
    SWPagingViewCell *cell = [page dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        UIView<SWPagingContentViewProtocol> *content = [[clazz alloc] initWithFrame:CGRectZero];
        cell = [[SWPagingViewCell alloc] initWithContentView:content];
        [self onCreate:cell atIndex:index];
    }
    return cell;
}

- (void)columnView:(SWColumnView *)columnView configColumn:(SWPagingViewCell*)cell
{
    NSInteger index = cell.index;
    [self onConfig:cell atIndex:index];
    if ([cell.contentView respondsToSelector:@selector(setContent:ext:)]) {
        SWPCellObj *item = self.objs[index];
        id data = item.content;
        [cell.contentView setContent:data ext:item.ext];
    }
}

@end
