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
@property (nonatomic,assign)CGFloat cellsWidthCount;

@property (nonatomic,assign)NSInteger cellcount;
@property (nonatomic,strong)UITapGestureRecognizer *tapGesture;
@end

@implementation SWColumnView
{
    struct {
        unsigned int dlgDidSelectIndex : 1;
        unsigned int dlgWillLoadIndex : 1;
        unsigned int dlgDidLoadIndex : 1;
        unsigned int dlgWillUnLoadIndex : 1;
        unsigned int dlgDidUnLoadIndex : 1;
        
        unsigned int dtsWidthForColumnAtIndex : 1;
        unsigned int dtsConfigColumn : 1;
        
        unsigned int flagDataLoad : 1;
    } _flags;
    
    id <SWColumnViewDelegate> _delegate;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _reusableCells = [[NSMutableDictionary alloc] init];
        _visibleCells = [[NSMutableArray alloc] init];
        
    }
    return self;
}

- (void)addTapGesture
{
    if (!_tapGesture) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
        tap.delegate = self;
        tap.cancelsTouchesInView=NO;
        [self addGestureRecognizer:tap];
        _tapGesture=tap;
    }
}

- (void)setDelegate:(id<SWColumnViewDelegate>)delegate
{
    [super setDelegate:delegate];
    _delegate=delegate;
    _flags.dlgDidSelectIndex=[delegate respondsToSelector:@selector(columnView:didSelectIndex:)];
    if (_flags.dlgDidSelectIndex) {
        [self addTapGesture];
    }
    _flags.dlgWillLoadIndex=[delegate respondsToSelector:@selector(columnView:willLoadIndex:)];
    _flags.dlgDidLoadIndex=[delegate respondsToSelector:@selector(columnView:didLoadIndex:)];
    _flags.dlgWillUnLoadIndex=[delegate respondsToSelector:@selector(columnView:willUnLoadIndex:)];
    _flags.dlgDidUnLoadIndex=[delegate respondsToSelector:@selector(columnView:didUnLoadIndex:)];
}

- (id<SWColumnViewDelegate>)delegate
{
    return _delegate;
}

- (void)setDataSource:(id<SWColumnViewDataSource>)dataSource
{
    _dataSource=dataSource;
    _flags.dtsWidthForColumnAtIndex=[dataSource respondsToSelector:@selector(columnView:widthForColumnAtIndex:)];
    _flags.dtsConfigColumn=[dataSource respondsToSelector:@selector(columnView:configColumn:)];
}


- (void)dealloc
{
    _delegate=nil;
    super.delegate=nil;
    self.dataSource=nil;
}

-(void)layoutSubviews
{
    //NSLog(@"SWColumnView %p layoutSubviews",self);
    [super layoutSubviews];
    if (_flags.flagDataLoad) {
        [self layoutVisibleCells];
    }else{
        [self reloadData];
    }
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
    if (!self.window) {
        return;
    }
    _cellsHeight = CGRectGetHeight(self.bounds)-(self.contentInset.bottom+self.contentInset.top);
    
    CGSize size=CGSizeMake(_cellsWidthCount,_cellsHeight);
    if (!CGSizeEqualToSize(self.contentSize, size)) {
        self.contentSize=size;
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
            //            [cell removeFromSuperview];
            cell.hidden=YES;
            [_visibleCells removeObject:cell];
            if (_flags.dlgDidUnLoadIndex) {
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
                cell=[self insertCellAtIndex:i withFrame:CGRectMake(offsetL, 0, tmpfloat, _cellsHeight)];
                [_visibleCells addObject:cell];
                [self didLoadCell:cell index:i];
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
                cell=[self insertCellAtIndex:i withFrame:CGRectMake(offsetL, 0, tmpfloat, _cellsHeight)];
                [_visibleCells insertObject:cell atIndex:0];
                [self didLoadCell:cell index:i];
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
                cell=[self insertCellAtIndex:i withFrame:CGRectMake(offsetL, 0, tmpfloat, _cellsHeight)];
                [_visibleCells addObject:cell];
                [self didLoadCell:cell index:i];
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

- (void)didMoveToWindow
{
    [super didMoveToWindow];
    if (!self.hidden) {
        [self setNeedsLayout];
    }
}

- (void)enqueueReusableCell:(SWColumnViewCell *)cell
{
    [cell prepareForRecycle];
    if (_flags.dlgWillUnLoadIndex) {
        [self.delegate columnView:self willUnLoadIndex:cell.index];
    }
    NSMutableArray *cells = _reusableCells[cell.reuseIdentifier];
    if (cells) {
        [cells addObject:cell];
    }else{
        if (cell.reuseIdentifier) {
            NSMutableArray *cells = [[NSMutableArray alloc] init];
            [cells addObject:cell];
            _reusableCells[cell.reuseIdentifier]=cells;
        }
    }
}

- (SWColumnViewCell *)loadCell:(NSInteger)index
{
    if (_flags.dlgWillLoadIndex) {
        [self.delegate columnView:self willLoadIndex:index];
    }
    SWColumnViewCell *cell =[self.dataSource columnView:self cellForColumnIndex:index];
    return cell;
}


- (void)didLoadCell:(SWColumnViewCell *)cell index:(NSInteger)i
{
    [cell setNeedsLayout];
    if (_flags.dlgDidLoadIndex) {
        [self.delegate columnView:self didLoadIndex:i];
    }
}

- (SWColumnViewCell *)insertCellAtIndex:(NSInteger)index withFrame:(CGRect)frame
{
    //    NSLog(@"insertCellAtLineIndex:%d",index);
    SWColumnViewCell *cell =[self loadCell:index];
    cell.index=index;
    if (cell.hidden) {
        cell.hidden=NO;
    }else{
        [self addSubview:cell];
    }
    cell.frame=frame;
    if (_flags.dtsConfigColumn) {
        [self.dataSource columnView:self configColumn:cell];
    }
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
    if (_flags.dtsWidthForColumnAtIndex) {
        return [self.dataSource columnView:self widthForColumnAtIndex:index];
    }else{
        return CGRectGetWidth(self.frame);
    }
}


- (void)reloadData
{
    //    NSLog(@"--%@",NSStringFromSelector(_cmd));
    _cellcount = [self.dataSource columnViewNumberOfColumns:self];
    
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    CGFloat widthCount = 0;
    CGFloat tmp;
    for (NSInteger i =0;i<_cellcount;i++) {
        tmp = [self widthForColumnAtIndex:i];
        arr[i]=@(tmp);
        widthCount+=tmp;
    }
    
    _cellsWidthCount=widthCount;
    
    _cellsWidth = arr;
    
    for (SWColumnViewCell *cell in _visibleCells) {
        [self enqueueReusableCell:cell];
        //        [cell removeFromSuperview];
        cell.hidden=YES;
        if (_flags.dlgDidUnLoadIndex) {
            [self.delegate columnView:self didUnLoadIndex:cell.index];
        }
    }
    
    [_visibleCells removeAllObjects];
    _flags.flagDataLoad=YES;
    [self setNeedsLayout];
}


- (SWColumnViewCell *)cellAtIndex:(NSUInteger)index
{
    SWColumnViewCell *targetCell = nil;
    for (SWColumnViewCell *cell in _visibleCells) {
        if (cell.index == index) {
            targetCell = cell;
            break;
        }
    }
    return targetCell;
}

- (NSArray *)visibleCells
{
    return [_visibleCells copy];
}

- (NSArray *)indexsForVisibleRows
{
    return [_visibleCells valueForKeyPath:kCCellIndexKey];
}

- (void)scrollToColumn:(NSInteger)index animate:(BOOL)animate
{
    NSUInteger count = [_cellsWidth count];
    if (count==0) {
        return;
    }
    if (index>=count) {
        index = count-1;
    }
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
    //    if (animate) {
    //            [self reloadData];
    //    }else{
    [self reloadData];
    //    }
}


- (void)onTap:(UITapGestureRecognizer *)gesture
{
    if (_flags.dlgDidSelectIndex) {
        CGPoint location = [gesture locationInView:self];
        for (SWColumnViewCell *v in _visibleCells) {
            if (CGRectContainsPoint(v.frame, location)) {
                [self.delegate columnView:self didSelectIndex:v.index];
                return;
            }
        }
    }
}

- (void)setContentOffset:(CGPoint)contentOffset
{
    [super setContentOffset:contentOffset];
    [self setNeedsLayout];
}

@end
