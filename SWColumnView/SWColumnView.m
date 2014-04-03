//
//  SWColumnView.m
//  SWColumnView Demo
//
//  Created by iBcker on 14-3-29.
//  Copyright (c) 2014年 iBcker. All rights reserved.
//

#import "SWColumnView.h"
#import "SWColumnViewCell.h"

NSString * const kCContentOffset = @"contentOffset";
NSString * const kCCellIndexKey = @"index";


@interface SWColumnView()<UIGestureRecognizerDelegate>

@property (nonatomic,strong)NSMutableDictionary *reusableCells;
@property (nonatomic,strong)NSMutableArray *visibleCells;

@property (nonatomic,strong)NSArray *cellsWidth;
@property (nonatomic,assign)CGFloat cellsHeight;

@property (nonatomic,assign)NSInteger cellcount;

@property (nonatomic,assign)BOOL loadData;
@end

@implementation SWColumnView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _reusableCells = [[NSMutableDictionary alloc] init];
        _visibleCells = [[NSMutableArray alloc] init];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
        tap.delegate = self;

        [self addGestureRecognizer:tap];
//        [self addObserver:self forKeyPath:kCContentOffset options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    }
    return self;
}


- (void)dealloc
{
//    [self removeObserver:self forKeyPath:kCContentOffset];
    self.delegate=nil;
    self.dataSource=nil;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [self layoutVisibleCells];
}

- (CGFloat)contentBundsLeft
{
    return self.contentOffset.x;
}

- (CGFloat)contentBundsRight
{
    return self.contentOffset.x+CGRectGetWidth(self.bounds);
}

- (void)layoutVisibleCells
{
    if (!self.loadData) {
        [self reloadData];
        return;
    }
    
    CGFloat contentBundsLeft = [self contentBundsLeft];
    CGFloat contentBundsRight = [self contentBundsRight];
    
    CGFloat offsetL = 0.f,offsetR;
    
    SWColumnViewCell *cell;
    BOOL isASC=YES;
    while (YES) {
        cell = isASC?[_visibleCells firstObject]:[_visibleCells lastObject];
        if (!cell) {
            break;
        }
        offsetL = CGRectGetMinX(cell.frame);
        offsetR = CGRectGetMaxX(cell.frame);
        if (offsetL>=contentBundsRight||offsetR<=contentBundsLeft) {
            [self enqueueReusableCell:cell];
            [cell removeFromSuperview];
            [_visibleCells removeObject:cell];
            if ([self.delegate respondsToSelector:@selector(columnView:didUnLoadIndex:)]) {
                [self.delegate columnView:self didUnLoadIndex:cell.index];
            }
//            NSLog(@"remove cell %@",[cell valueForKey:kCCellIndexKey]);
        }else{
            if (isASC) {
                isASC = NO;
            }else{
                break;
            }
        }
    }


    offsetL = 0.f;
    NSInteger index = 0;
    CGFloat tmpfloat;
    if ([_visibleCells count]>0) {
        //ASC search
        SWColumnViewCell *cell = [_visibleCells lastObject];
        index = cell.index;
        offsetL = CGRectGetMaxX(cell.frame);
        
        index++;
        for (NSInteger i= index; i<_cellcount; i++) {
            tmpfloat = [_cellsWidth[i] floatValue];
            offsetR = offsetL + tmpfloat;
            if (offsetL<contentBundsRight&&offsetR>contentBundsLeft) {
                //visible
                cell=[self insertCellAtLineIndex:i withFrame:CGRectMake(offsetL, 0, tmpfloat, _cellsHeight)];
                [_visibleCells addObject:cell];
                [self didLoadCell:i];
            }else{
                break;
            }
            offsetL = offsetR;
        }
        
        //DESC search
        cell = [_visibleCells firstObject];
        index = cell.index;
        offsetR = CGRectGetMinX(cell.frame);
        
        index--;
        for (NSInteger i= index; i>=0; i--) {
            tmpfloat = [_cellsWidth[i] floatValue];
            offsetL = offsetR - tmpfloat;
            if (offsetL<contentBundsRight&&offsetR>contentBundsLeft) {
                //visible
                cell=[self insertCellAtLineIndex:i withFrame:CGRectMake(offsetL, 0, tmpfloat, _cellsHeight)];
                [_visibleCells insertObject:cell atIndex:0];
                [self didLoadCell:i];
            }else{
                break;
            }
            offsetR = offsetL;
        }
        
    }else{
        BOOL start = NO,end = NO;
        for (NSInteger i= 0; i<_cellcount; i++) {
            tmpfloat = [_cellsWidth[i] floatValue];
            offsetR = offsetL+ tmpfloat;
            if (offsetL<contentBundsRight&&offsetR>contentBundsLeft) {
                //visible
                cell=[self insertCellAtLineIndex:i withFrame:CGRectMake(offsetL, 0, tmpfloat, _cellsHeight)];
                [_visibleCells addObject:cell];
                [self didLoadCell:i];
                start=YES;
            }else{
                if (start) {
                    end=YES;
                }
            }
            if (start&&end) {
                break;
            }
            offsetL = offsetR;
        }
    }
}

- (void)enqueueReusableCell:(SWColumnViewCell *)cell
{
    if ([self.delegate respondsToSelector:@selector(columnView:willUnLoadIndex:)]) {
        [self.delegate columnView:self willUnLoadIndex:cell.index];
    }
    NSMutableArray *cells = _reusableCells[cell.reuseIdentifier];
    if (cells) {
        [cells addObject:cell];
    }else{
        NSMutableArray *cells = [[NSMutableArray alloc] init];
        [cells addObject:cell];
        _reusableCells[cell.reuseIdentifier]=cells;
    }
}

- (SWColumnViewCell *)loadCell:(NSInteger)index
{
    if ([self.delegate respondsToSelector:@selector(columnView:willLoadIndex:)]) {
        [self.delegate columnView:self willLoadIndex:index];
    }
    SWColumnViewCell *cell =[self.dataSource columnView:self cellForColumnIndex:index];
    return cell;
}


- (void)didLoadCell:(NSInteger)index
{
    if ([self.delegate respondsToSelector:@selector(columnView:didLoadIndex:)]) {
        [self.delegate columnView:self didLoadIndex:index];
    }
}

- (SWColumnViewCell *)insertCellAtLineIndex:(NSInteger)index withFrame:(CGRect)frame
{
//    NSLog(@"insertCellAtLineIndex:%d",index);
    SWColumnViewCell *cell =[self loadCell:index];
    cell.frame=frame;
    [self insertSubview:cell atIndex:0];
    cell.index=index;
    return cell;
}

- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier
{
    NSMutableArray *cells = self.reusableCells[identifier];

    SWColumnViewCell *cell = [cells lastObject];
    [cells removeObject:cell];
    
    [cell prepareForReuse];
    return cell;
}

- (CGFloat)widthForColumnAtIndex:(NSInteger)index
{
    if([self.dataSource respondsToSelector:@selector(columnView:widthForColumnAtIndex:)]) {
        return [self.dataSource columnView:self widthForColumnAtIndex:index];
    }else{
        return CGRectGetWidth(self.frame);
    }
}


- (void)reloadData
{
    self.loadData=YES;
//    NSLog(@"--%@",NSStringFromSelector(_cmd));
    _cellcount = [self.dataSource columnViewNumberOfColumns:self];
    
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    CGFloat widthCount = 0,cotentInsetY;
    
    cotentInsetY = self.contentInset.bottom+self.contentInset.top;

    CGFloat tmp;
    for (NSInteger i =0;i<_cellcount;i++) {
        tmp = [self widthForColumnAtIndex:i];
        arr[i]=@(tmp);
        widthCount+=tmp;
    }
    
    _cellsWidth = arr;
    _cellsHeight = CGRectGetHeight(self.bounds)-cotentInsetY;
    
    
    for (SWColumnViewCell *cell in _visibleCells) {
        [self enqueueReusableCell:cell];
        [cell removeFromSuperview];
        if ([self.delegate respondsToSelector:@selector(columnView:didUnLoadIndex:)]) {
            [self.delegate columnView:self didUnLoadIndex:cell.index];
        }
    }
    
    [_visibleCells removeAllObjects];
    
    self.contentSize=CGSizeMake(widthCount,_cellsHeight);

    [self layoutVisibleCells];
}


- (NSArray *)visibleCells
{
    return _visibleCells;
}


- (NSArray *)indexsForVisibleRows
{
    return [self.visibleCells valueForKeyPath:kCCellIndexKey];
}

- (void)scrollToColumn:(NSInteger)index animate:(BOOL)animate
{
    CGFloat offsetX=0;
    for (NSInteger i = 0 ; i<index ; i++) {
        offsetX+=[_cellsWidth[i] floatValue];
    }
    CGPoint offset = CGPointMake(offsetX-self.contentInset.left, -self.contentInset.top);
    [self setContentOffset:offset animated:animate];
}

- (void)scrollToStart:(BOOL)animate
{
    [self scrollToColumn:0 animate:animate];
}

- (void)scrollToEnd:(BOOL)animate
{
    CGFloat offsetX=0;
    for (NSInteger i = 0 ; i<_cellcount ; i++) {
        offsetX+=[_cellsWidth[i] floatValue];
    }
    offsetX-=CGRectGetWidth(self.frame);
    CGPoint offset = CGPointMake(offsetX, -self.contentInset.top);
    [self setContentOffset:offset animated:animate];
}

- (void)removeColumn:(NSInteger)index animate:(BOOL)animate
{
    if (animate) {
//            [self reloadData];
    }else{
        [self reloadData];
    }
}


- (void)onTap:(UITapGestureRecognizer *)gesture
{
    if ([self.delegate respondsToSelector:@selector(columnView:didSelectIndex:)]) {
        CGPoint location = [gesture locationInView:self];
        for (SWColumnViewCell *v in _visibleCells) {
            if (CGRectContainsPoint(v.frame, location)) {
                [self.delegate columnView:self didSelectIndex:v.index];
                return;
            }
        }
    }
}

//-(UIView*)hitTest:(CGPoint)point withEvent:(UIEvent*)event
//{
//    UIView* child = [super hitTest:point withEvent:event];
//    if (child == self){
//    	return self;
//    }else{
//        return child;
//    }
//}


#pragma mark observer
//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
//{
//    [self layoutVisibleCells];
//}

@end
