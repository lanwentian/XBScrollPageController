//
//  XBScrollPageController.h
//  XBScrollPageController
//
//  Created by Scarecrow on 14/9/6.
//  Copyright (c) 2014年 xiu8. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XBScrollPageController : UIViewController

@property (nonatomic,strong) UIFont *normalTitleFont; /**< 正常(非选中)标签字体  default is 13*/
@property (nonatomic,strong) UIFont *selectedTitleFont; /**< 选中状态标签字体  default is 18*/

@property (nonatomic,strong) UIColor *normalTitleColor; /**< 正常(非选中)标签字体颜色  default is darkGrayColor*/
@property (nonatomic,strong) UIColor *selectedTitleColor; /**< 选中状态标签字体颜色及下方滑块颜色  default is redColor*/

@property (nonatomic,assign) UIEdgeInsets tagViewSectionInset; /**< 整个标签view缩进 default is UIEdgeInsetsZero  */

@property (nonatomic,assign) UIEdgeInsets tagItemSectionInset; /**< 每个tag标签的缩进,不设置的话选中状态可能会导致文字显示不全... default is UIEdgeInsetsMake(0, 10, 0, 10),如果设置了tagItemSize属性则该属性失效*/

@property (nonatomic,assign) CGSize tagItemSize; /**< 每个tag标签的size,如果不设置则会根据文本长度计算,设置该属性后tagItemSectionInset失效*/


//由于性能方面的考虑,设置定时器每10s检测一次缓存,所以如需使用该属性请尽量设置较大值,或按需修改源码
@property (nonatomic,assign) NSTimeInterval graceTime;  /**< 控制器缓存时间,如果在该段时间内缓存的控制器依旧没有被展示,则会从内存中销毁,默认不设置,即默认在内存中缓存所有展示过的控制器*/

@property (nonatomic,strong) UIColor *backgroundColor;  /**< 背景色  */


/**
 *  设置滚动到某个tag
 */

- (void)scrollToTagByIndex:(NSInteger)index;

/**
 *  刷新界面
 */
- (void)reloadDataWith:(NSArray *)titleArray andSubViewdisplayClassNames:(NSArray *)classNames;

/**
 *   15-09-07 09:09:12
 *
 *  require!
 *
 */
- (instancetype)initWithTitles:(NSArray *)titleArray andSubViewdisplayClassNames:(NSArray *)classNames andTagViewHeight:(CGFloat)tagViewHeight;

@end
