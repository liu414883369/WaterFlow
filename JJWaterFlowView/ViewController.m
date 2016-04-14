//
//  ViewController.m
//  JJWaterFlowView
//
//  Created by LIUJIANJIAN on 15/11/22.
//  Copyright © 2015年 LIUJIANJIAN. All rights reserved.
//

#import "ViewController.h"
#import "JJWaterflowView.h"
#import "JJWaterflowViewCell.h"

@interface ViewController ()<JJWaterflowViewDataSource, JJWaterflowViewDelegate>
@property(nonatomic, strong)JJWaterflowView *watewflowView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    JJWaterflowView *waterflowView = [[JJWaterflowView alloc] init];
    waterflowView.backgroundColor = [UIColor whiteColor];
    waterflowView.frame = self.view.bounds;
    waterflowView.delegate = self;
    waterflowView.dataSouce = self;
    [self.view addSubview:waterflowView];
    self.watewflowView = waterflowView;
    
    
//    [waterflowView reloadData];
}

#pragma mark - JJWaterflowView dataSource
/**
 *  item数目
 *
 *  @param waterflowView 实例
 *
 *  @return item数目
 */
- (NSUInteger)numberOfItemsInWaterflowView:(JJWaterflowView *)waterflowView {
    return 200;
}
/**
 *  实例cell
 *
 *  @param waterflowView 实例
 *  @param index         item的下标
 *
 *  @return 实例cell
 */
- (JJWaterflowViewCell *)waterflowView:(JJWaterflowView *)waterflowView itemAtIndex:(NSUInteger)index {
    
    static NSString *ID = @"CELL";
    JJWaterflowViewCell *cell = [waterflowView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[JJWaterflowViewCell alloc] init];
        cell.identifier = ID;
        cell.backgroundColor = [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1];
        cell.backgroundColor = [UIColor lightGrayColor];
        
        
        
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 60)];
//        lab.backgroundColor = [UIColor redColor];
        lab.textColor = [UIColor whiteColor];
        lab.tag = 111;
        [cell addSubview:lab];
    }
    UILabel *lab = [cell viewWithTag:111];
    lab.font = [UIFont boldSystemFontOfSize:20.0];
    
    lab.text = [NSString stringWithFormat:@"%lu", (unsigned long)index];
    
    NSLog(@"%p----%lu", cell, (unsigned long)index);
    
    return cell;
}
/**
 *  列数
 *
 *  @param waterflowView 实例
 *
 *  @return 列数
 */
- (NSUInteger)numberOfColumnInWaterflowView:(JJWaterflowView *)waterflowView {
    return 3;
}

#pragma mark - JJWaterflowView delegate

/**
 *  item的点击事件
 *
 *  @param waterflowView 实例
 *  @param index         item的下标
 */
- (void)waterflowView:(JJWaterflowView *)waterflowView didSelectItemAtIndex:(NSUInteger)index {
    NSLog(@"didSelectItemAtIndex = %lu", (unsigned long)index);
}
/**
 *  单个item的高
 *
 *  @param waterflowView 实例
 *  @param index         item的下标
 *
 *  @return 单个item的高
 */
- (CGFloat)waterflowView:(JJWaterflowView *)waterflowView heightForColumnAtIndex:(NSUInteger)index {
    CGFloat h = arc4random()%200;
    if (h > 60) {
        return h;
    }
    return  60;
}
/**
 *  间距
 *
 *  @param waterflowView 实例
 *  @param type          间距类型
 *
 *  @return 间距类型对应的间距
 */
- (CGFloat)waterflowView:(JJWaterflowView *)waterflowView marginForType:(JJWaterflowViewMarginType)type {
    /*
     JJWaterflowViewMarginTypeTop,
     JJWaterflowViewMarginTypeLeft,
     JJWaterflowViewMarginTypeBottom,
     JJWaterflowViewMarginTypeRight,
     JJWaterflowViewMarginTypeColumn,
     JJWaterflowViewMarginTypeRow,
     */
    switch (type) {
        case JJWaterflowViewMarginTypeTop:
        {
            return 10;
        }
            break;
        case JJWaterflowViewMarginTypeLeft:
        {
            return 10;
        }
            break;
        case JJWaterflowViewMarginTypeBottom:
        {
            return 10;
        }
            break;
        case JJWaterflowViewMarginTypeRight:
        {
            return 10;
        }
            break;
        case JJWaterflowViewMarginTypeColumn:
        {
            return 10;
        }
            break;
        case JJWaterflowViewMarginTypeRow:
        {
            return 10;
        }
            break;
            
        default: return 0;
            break;
    }
}

















@end
