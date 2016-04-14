//
//  JJWaterflowView.m
//  JJWaterFlowView
//
//  Created by LIUJIANJIAN on 15/11/22.
//  Copyright © 2015年 LIUJIANJIAN. All rights reserved.
//

#import "JJWaterflowView.h"
#import "JJWaterflowViewCell.h"

#define kJJWaterflowViewDefaultCellHeight       70 // cell默认高度
#define kJJWaterflowViewDefaultMargin           8  // 默认间距
#define kJJWaterflowViewDefaultNumberOfColumns  3  // 默认列数

@interface JJWaterflowView()
/**
 *  存储所有cell的frame
 */
@property (nonatomic, strong) NSMutableArray *cellFrames;
/**
 *  当前显示在屏幕上的cell，防止手指不离开屏幕上下滚动重复创建cell
 */
@property (nonatomic, strong) NSMutableDictionary *displayingCells;
/**
 *  复用池
 */
@property (nonatomic, strong) NSMutableSet *reusableCells;

/**
 *  列数
 *
 *  @return 列数
 */
- (NSUInteger)numberOfColumns;
/**
 *  间距
 *
 *  @param type 间距类型
 *
 *  @return 间距
 */
- (CGFloat)marginForType:(JJWaterflowViewMarginType)type;
/**
 *  单个cell的高度
 *
 *  @param index cell下标
 *
 *  @return 单个cell的高度
 */
- (CGFloat)heightAtIndex:(NSUInteger)index;
/**
 *  判断frame是否在屏幕上
 *
 *  @param frame frame
 *
 *  @return 判断frame是否在屏幕上
 */
- (BOOL)isInScreen:(CGRect)frame;

@end

@implementation JJWaterflowView
@dynamic delegate;

#pragma mark - 懒加载

- (NSMutableArray *)cellFrames {
    if (!_cellFrames) {
        self.cellFrames = [NSMutableArray array];
    }
    return _cellFrames;
}
- (NSMutableDictionary *)displayingCells
{
    if (_displayingCells == nil) {
        self.displayingCells = [NSMutableDictionary dictionary];
    }
    return _displayingCells;
}
- (NSMutableSet *)reusableCells
{
    if (_reusableCells == nil) {
        self.reusableCells = [NSMutableSet set];
    }
    return _reusableCells;
}
- (void)willMoveToSuperview:(UIView *)newSuperview {
    [self reloadData];
}
#pragma mark - 公共方法
/**
 *  数据刷新
 */
- (void)reloadData {
    
    [self.displayingCells.allValues makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.displayingCells   removeAllObjects];
    [self.reusableCells     removeAllObjects];
    [self.cellFrames        removeAllObjects];
    
    /// cell个数
    NSUInteger numberOfCells = [self.dataSouce numberOfItemsInWaterflowView:self];
    /// 列数
    NSUInteger numberOfColumns = [self numberOfColumns];
    /// 间距
    CGFloat topMargin       = [self marginForType:JJWaterflowViewMarginTypeTop];
    CGFloat leftMargin      = [self marginForType:JJWaterflowViewMarginTypeLeft];
    CGFloat bottomMargin    = [self marginForType:JJWaterflowViewMarginTypeBottom];
    CGFloat rightMargin     = [self marginForType:JJWaterflowViewMarginTypeRight];
    CGFloat rowMargin       = [self marginForType:JJWaterflowViewMarginTypeRow];
    CGFloat columnMargin    = [self marginForType:JJWaterflowViewMarginTypeColumn];
    /// cell宽度
    CGFloat cellWith = (self.bounds.size.width - leftMargin - rightMargin - columnMargin * (numberOfColumns - 1)) / numberOfColumns;
    // 创建数组，存放列的高度
    CGFloat heightOfColumns[numberOfColumns];
    for (int i = 0; i < numberOfColumns; i++) { // 数组赋初值
        heightOfColumns[i] = 0.0f;
    }
    /***********************
     *  计算所有cell的frame
     ***********************/
    /*
     width：已经计算出
     height：通过代理可以得到
     需要记录每个cell对应的列（计算X坐标）
     需要记录每个列的最短高度（计算Y坐标）
     没有cell对应的frame存入数组
     */
    for (int i = 0; i < numberOfCells; i++) { // 遍历所有cell
        NSUInteger cellColumn = 0; // 默认第0列,cell对应的列
        CGFloat minHeightOfColumn = heightOfColumns[0]; //默认取第一列
        // 计算最小高度、对应列
        for (int j = 1; j < numberOfColumns; j++) {
            if (minHeightOfColumn > heightOfColumns[j]) { // 如果比第一列还小
                cellColumn = j;
                minHeightOfColumn = heightOfColumns[j];
            }
        }
        // 通过代理拿到cell高
        CGFloat cellHeight = [self heightAtIndex:i];
        // cell frame
        CGFloat cellX = leftMargin + (cellWith + columnMargin) * cellColumn;
        CGFloat cellY = topMargin; // 默认在第一行
        if (minHeightOfColumn != 0) {
            cellY = minHeightOfColumn + rowMargin; // Y坐标：上一次的最短列+行间距
        }
        CGRect frame = CGRectMake(cellX, cellY, cellWith, cellHeight);
        [self.cellFrames addObject:[NSValue valueWithCGRect:frame]];
        heightOfColumns[cellColumn] = CGRectGetMaxY(frame);
    }
    // 设置contentSize
    // 计算最高列
    CGFloat maxHight = heightOfColumns[0]; //默认取第一列
    for (int j = 1; j < numberOfColumns; j++) {
        if (maxHight < heightOfColumns[j]) { // 如果比第一列还小
            maxHight = heightOfColumns[j];
        }
    }
    maxHight += bottomMargin;
    self.contentSize = CGSizeMake(self.bounds.size.width, maxHight);
}
// scrollview滚动会调用该方法
- (void)layoutSubviews {
    [super layoutSubviews];
    
    for (int i = 0; i < self.cellFrames.count; i++) {
        
        CGRect frame = [[self.cellFrames objectAtIndex:i] CGRectValue];
        //key值就是其下标（防止其手指原地来回拖动）
        JJWaterflowViewCell *cell = self.displayingCells[@(i)];
        if ([self isInScreen:frame]) { // 当前屏幕
            if (cell == nil) {
                // 通过数据源代理拿到cell
                cell = [self.dataSouce waterflowView:self itemAtIndex:i];
                cell.frame = frame;
                [self addSubview:cell];
                // 存入字典
//                NSLog(@"%@ -- %@", @(i), cell);
//                [self.displayingCells setObject:cell forKey:@(i)];
                self.displayingCells[@(i)] = cell;
            }
        } else { // 不在屏幕
            if (cell) {
                // 从屏幕中删除
                [cell removeFromSuperview];
                [self.displayingCells removeObjectForKey:@(i)];
                // 存入缓存
                [self.reusableCells addObject:cell];
            }
        }
    }
    
}
- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier {
    __block JJWaterflowViewCell *cell = nil;
    [self.reusableCells enumerateObjectsUsingBlock:^(id  _Nonnull obj, BOOL * _Nonnull stop) {
        JJWaterflowViewCell *reusableCell = obj;
        if ([reusableCell.identifier isEqualToString:identifier]) {
            cell = obj;
            *stop = YES;
        }
    }];
    if (cell) { // 从缓存池删除
        [self.reusableCells removeObject:cell];
    }
    return cell;
}

#pragma mark - 私有方法

- (NSUInteger)numberOfColumns {
    NSUInteger numberOfColumns = kJJWaterflowViewDefaultNumberOfColumns;
    if ([self.dataSouce respondsToSelector:@selector(numberOfColumnInWaterflowView:)]) {
        numberOfColumns = [self.dataSouce numberOfColumnInWaterflowView:self];
    }
    return numberOfColumns;
}

- (CGFloat)marginForType:(JJWaterflowViewMarginType)type {
    CGFloat margin = kJJWaterflowViewDefaultMargin;
    if ([self.delegate respondsToSelector:@selector(waterflowView:marginForType:)]) {
        margin = [self.delegate waterflowView:self marginForType:type];
    }
    return margin;
}

- (CGFloat)heightAtIndex:(NSUInteger)index
{
    CGFloat height = kJJWaterflowViewDefaultCellHeight;
    if ([self.delegate respondsToSelector:@selector(waterflowView:heightForColumnAtIndex:)]) {
        height = [self.delegate waterflowView:self heightForColumnAtIndex:index];
    }
    return height;
}
- (BOOL)isInScreen:(CGRect)frame
{
    return (CGRectGetMaxY(frame) > self.contentOffset.y) &&
    (CGRectGetMinY(frame) < self.contentOffset.y + self.bounds.size.height);
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if ([self.delegate respondsToSelector:@selector(waterflowView:didSelectItemAtIndex:)]) {
        UITouch *touch = [touches anyObject];
        CGPoint point = [touch locationInView:self];
        __block NSNumber *selectedIndex = nil;
        [self.displayingCells enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
          
            
            UIView *view = obj;
            
            
//            if ([view pointInside:point withEvent:event]) {
//                selectedIndex = key;
//                *stop = YES;
//            }
            
            if (CGRectContainsPoint(view.frame, point)) {
                selectedIndex = key;
                *stop = YES;
            }
        }];
        if (selectedIndex) {
            [self.delegate waterflowView:self didSelectItemAtIndex:selectedIndex.unsignedIntegerValue];
        }
    }
    return;
}






@end
