# WaterFlow
瀑布流
UIScrollView封装的瀑布流控件，仿tableview实现自定义cell和复用功能

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, JJWaterflowViewMarginType) {
    JJWaterflowViewMarginTypeTop,
    JJWaterflowViewMarginTypeLeft,
    JJWaterflowViewMarginTypeBottom,
    JJWaterflowViewMarginTypeRight,
    JJWaterflowViewMarginTypeColumn,
    JJWaterflowViewMarginTypeRow,
};

@class JJWaterflowView, JJWaterflowViewCell;

@protocol JJWaterflowViewDataSource <NSObject>
@required
/**
 *  item数目
 *
 *  @param waterflowView 实例
 *
 *  @return item数目
 */
- (NSUInteger)numberOfItemsInWaterflowView:(JJWaterflowView *)waterflowView;
/**
 *  实例cell
 *
 *  @param waterflowView 实例
 *  @param index         item的下标
 *
 *  @return 实例cell
 */
- (JJWaterflowViewCell *)waterflowView:(JJWaterflowView *)waterflowView itemAtIndex:(NSUInteger)index;

@optional
/**
 *  列数
 *
 *  @param waterflowView 实例
 *
 *  @return 列数
 */
- (NSUInteger)numberOfColumnInWaterflowView:(JJWaterflowView *)waterflowView;

@end

@protocol JJWaterflowViewDelegate <UIScrollViewDelegate>
@optional
/**
 *  item的点击事件
 *
 *  @param waterflowView 实例
 *  @param index         item的下标
 */
- (void)waterflowView:(JJWaterflowView *)waterflowView didSelectItemAtIndex:(NSUInteger)index;
/**
 *  单个item的高
 *
 *  @param waterflowView 实例
 *  @param index         item的下标
 *
 *  @return 单个item的高
 */
- (CGFloat)waterflowView:(JJWaterflowView *)waterflowView heightForColumnAtIndex:(NSUInteger)index;
/**
 *  间距
 *
 *  @param waterflowView 实例
 *  @param type          间距类型
 *
 *  @return 间距类型对应的间距
 */
- (CGFloat)waterflowView:(JJWaterflowView *)waterflowView marginForType:(JJWaterflowViewMarginType)type;

@end


@interface JJWaterflowView : UIScrollView
/**
 *  代理方法
 */
@property(nonatomic, weak)id<JJWaterflowViewDelegate> delegate;
/**
 *  数据源方法
 */
@property(nonatomic, weak)id<JJWaterflowViewDataSource> dataSouce;
/**
 *  数据刷新
 */
- (void)reloadData;
/**
 *  cell的复用标示
 *
 *  @param identifier 标示
 *
 *  @return cell实例
 */
- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier;





@end
