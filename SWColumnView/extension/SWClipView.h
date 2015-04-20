//
//  SWClipView.h
//  SinaWeather
//
//  Created by iBcker on 14-4-2.
//
//

#import "SWPagingView.h"

@interface SWClipView : SWPagingView

@property (nonatomic,assign)UIEdgeInsets clipInset;//左右回收距离
@property (nonatomic,assign)CGFloat clipPadding;//clipInset=UIEdgeInsetsMake(clipPadding,0,clipPadding,0)

@property (nonatomic,assign)BOOL extendClipTouch; //回收边界内响应点击、default=NO

@end
