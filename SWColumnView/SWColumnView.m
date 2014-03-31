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
//    [self removeObserver:self forKeyPath:kZPContentOffset];
    self.delegate=nil;
    self.dataSource=nil;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [self layoutVisibleCells];
}


- (void)layoutVisibleCells
{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self reloadData];
    });

//    NSLog(@"--%@",NSStringFromSelector(_cmd));
    
    CGPoint offset= self.contentOffset;
    
    CGFloat contentBundsLeft = offset.x;
    CGFloat contentBundsRight = offset.x+CGRectGetWidth(self.bounds);
    
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
            NSLog(@"remove cell %@",[cell valueForKey:kCCellIndexKey]);
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
        index = [self getCellIndex:cell];
        offsetL = CGRectGetMaxX(cell.frame);
        
        index++;
        for (NSInteger i= index; i<_cellcount; i++) {
            tmpfloat = [_cellsWidth[i] floatValue];
            offsetR = offsetL + tmpfloat;
            if (offsetL<contentBundsRight&&offsetR>contentBundsLeft) {
                //visible
                cell=[self insertCellAtLineIndex:i withFrame:CGRectMake(offsetL, 0, tmpfloat, _cellsHeight)];
                [_visibleCells addObject:cell];
            }else{
                break;
            }
            offsetL = offsetR;
        }
        
        //DESC search
        cell = [_visibleCells firstObject];
        index = [self getCellIndex:cell];
        offsetR = CGRectGetMinX(cell.frame);
        
        index--;
        for (NSInteger i= index; i>=0; i--) {
            tmpfloat = [_cellsWidth[i] floatValue];
            offsetL = offsetR - tmpfloat;
            if (offsetL<contentBundsRight&&offsetR>contentBundsLeft) {
                //visible
                cell=[self insertCellAtLineIndex:i withFrame:CGRectMake(offsetL, 0, tmpfloat, _cellsHeight)];
                [_visibleCells insertObject:cell atIndex:0];
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
    NSMutableArray *cells = _reusableCells[cell.reuseIdentifier];
    if (cells) {
        [cells addObject:cell];
    }else{
        NSMutableArray *cells = [[NSMutableArray alloc] init];
        [cells addObject:cell];
        _reusableCells[cell.reuseIdentifier]=cells;
    }
}

- (NSInteger)getCellIndex:(SWColumnViewCell *)cell
{
    return [[cell valueForKey:kCCellIndexKey] integerValue];
}

- (SWColumnViewCell *)insertCellAtLineIndex:(NSInteger)index withFrame:(CGRect)frame
{
    NSLog(@"insertCellAtLineIndex:%d",index);
    SWColumnViewCell *cell = [self.dataSource columnView:self cellForLineAtIndex:index];
    cell.frame=frame;
    [self insertSubview:cell atIndex:0];
    [cell setValue:@(index) forKey:kCCellIndexKey];
    return cell;
}

- (SWColumnViewCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier
{
    NSMutableArray *cells = self.reusableCells[identifier];

    SWColumnViewCell *cell = [cells lastObject];
    [cells removeObject:cell];
    
    [cell prepareForReuse];
    return cell;
}

- (void)reloadData
{
    NSLog(@"--%@",NSStringFromSelector(_cmd));
    _cellcount = [self.dataSource columnViewNumberOfColumns:self];
    
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    CGFloat widthCount = 0,cotentInsetY;
    
    cotentInsetY = self.contentInset.bottom+self.contentInset.top;
    
    if([self.dataSource respondsToSelector:@selector(columnView:widthForLineAtIndex:)]) {
        CGFloat tmp;
        for (NSInteger i =0;i<_cellcount;i++) {
            tmp = [self.dataSource columnView:self widthForLineAtIndex:i];
            arr[i]=@(tmp);
            widthCount+=tmp;
        }
    }else{
        NSNumber *width =@(CGRectGetWidth(self.frame));
        for (NSInteger i =0;i<_cellcount;i++) {
            arr[i]=width;
        }
        widthCount=CGRectGetWidth(self.frame)*_cellcount;
    }
    _cellsWidth = arr;
    _cellsHeight = CGRectGetHeight(self.bounds)-cotentInsetY;
    
    self.contentSize=CGSizeMake(widthCount,_cellsHeight);
    
    for (SWColumnViewCell *cell in _visibleCells) {
        [self enqueueReusableCell:cell];
        [cell removeFromSuperview];
    }
    
    [_visibleCells removeAllObjects];
    
    [self setNeedsLayout];
}


- (NSArray *)visibleCells
{
    return [_visibleCells copy];
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
                NSInteger index  = [self getCellIndex:v];
                [self.delegate columnView:self didSelectIndex:index];
                return;
            }
        }
    }
}


#pragma mark observer
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
//    NSLog(@"-----observeValueForKeyPath");
}

@end
