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

NSString *const kSWPCellIdentifierKey   =   @"CellIdentifier";
NSString *const kSWPCellContentKey         =   @"CellContent";
NSString *const kSWPCellExextendDataKey    =   @"CellExextendData";

NSDictionary *SWPCellMake(NSString *identifier, id content, id ext)
{
    NSMutableDictionary *dicx = [[NSMutableDictionary alloc] initWithCapacity:3];
    dicx[kSWPCellIdentifierKey]=identifier;
    if(content)dicx[kSWPCellContentKey]=content;
    if(ext)dicx[kSWPCellExextendDataKey]=ext;
    return dicx;
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
    NSDictionary *item = self.objs[index];
    NSString *identifier = item[kSWPCellIdentifierKey];
    id data = item[kSWPCellContentKey];
    
    Class clazz = NSClassFromString(identifier);
    
    SWPagingViewCell *cell = [page dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        UIView<SWPagingContentViewProtocol> *content = [[clazz alloc] initWithFrame:CGRectZero];
        cell = [[SWPagingViewCell alloc] initWithContentView:content];
        [self onCreate:cell atIndex:index];
    }
    
    [self onConfig:cell atIndex:index];
    [cell.contentView setContent:data];
    
    return cell;
}



@end
