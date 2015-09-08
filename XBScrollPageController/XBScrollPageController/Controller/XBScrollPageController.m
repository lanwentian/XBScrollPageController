//
//  XBScrollPageController.m
//  XBScrollPageController
//
//  Created by Scarecrow on 14/9/6.
//  Copyright (c) 2014年 xiu8. All rights reserved.
//

#import "XBScrollPageController.h"
#import "XBConst.h"
#import "XBTagTitleCell.h"
#import "XBPageCell.h"
#import "XBTagTitleModel.h"
@interface XBScrollPageController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong) UICollectionView *tagCollectionView; /**< 标签View */
@property (nonatomic,strong) UICollectionViewFlowLayout *tagFlowLayout;


@property (nonatomic,strong) UICollectionView *pageCollectionView; /**< 页面展示View  */
@property (nonatomic,strong) UICollectionViewFlowLayout *pageFlowLayout;


@property (nonatomic,strong) NSMutableArray *tagTitleModelArray; /**< 标题模型数组  */


@property (nonatomic,strong) NSArray *displayClassNames; /**< 要展示的子控制器名称数组,如果只传一个则表示重复使用该控制器类  */

@property (nonatomic,assign) CGFloat tagViewHeight;   /**< 标签高度  */

@property (nonatomic,strong) NSMutableDictionary *viewControllersCaches;    /**< 控制器缓存  */

@property (nonatomic,assign) NSIndexPath* selectedIndex;   /**< 记录tag当前选中的cell索引  */

@property (nonatomic,strong) NSTimer *graceTimer;

@property (nonatomic,strong) UIView *selectionIndicator;  /**< 选择指示器  */

@property (nonatomic,strong) NSMutableDictionary *frameCaches;    /**< size缓存  */

@end

@implementation XBScrollPageController
#pragma - mark LazyLoad
- (NSMutableArray *)tagTitleModelArray
{
    if (!_tagTitleModelArray) {
        _tagTitleModelArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _tagTitleModelArray;
}

- (NSMutableDictionary *)viewControllersCaches
{
    if (!_viewControllersCaches) {
        _viewControllersCaches = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    return _viewControllersCaches;
}

- (NSMutableDictionary *)frameCaches
{
    if (!_frameCaches) {
        _frameCaches = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    return _frameCaches;
}

#pragma - mark getter&setter

- (void)setNormalTitleFont:(UIFont *)normalTitleFont
{
    _normalTitleFont = normalTitleFont;
    [self.tagTitleModelArray enumerateObjectsUsingBlock:^(XBTagTitleModel *obj, NSUInteger idx, BOOL *stop) {
        obj.normalTitleFont = normalTitleFont;
    }];
}
- (void)setSelectedTitleFont:(UIFont *)selectedTitleFont
{
    _selectedTitleFont = selectedTitleFont;
    [self.tagTitleModelArray enumerateObjectsUsingBlock:^(XBTagTitleModel *obj, NSUInteger idx, BOOL *stop) {
        obj.selectedTitleFont = selectedTitleFont;
    }];
}
- (void)setNormalTitleColor:(UIColor *)normalTitleColor
{
    _normalTitleColor = normalTitleColor;
    [self.tagTitleModelArray enumerateObjectsUsingBlock:^(XBTagTitleModel *obj, NSUInteger idx, BOOL *stop) {
        obj.normalTitleColor = normalTitleColor;
    }];
}
- (void)setSelectedTitleColor:(UIColor *)selectedTitleColor
{
    _selectedTitleColor = selectedTitleColor;
    [self.tagTitleModelArray enumerateObjectsUsingBlock:^(XBTagTitleModel *obj, NSUInteger idx, BOOL *stop) {
        obj.selectedTitleColor = selectedTitleColor;
    }];
}

- (void)setTagViewSectionInset:(UIEdgeInsets)tagViewSectionInset
{
    _tagViewSectionInset = tagViewSectionInset;
}

- (void)setTagItemSectionInset:(UIEdgeInsets)tagItemSectionInset
{
    _tagItemSectionInset = tagItemSectionInset;
}

- (void)setGraceTime:(NSTimeInterval)graceTime
{
    _graceTime = graceTime;
    [self.graceTimer setFireDate:[NSDate distantPast]];
}

- (void)setSelectedIndex:(NSIndexPath *)selectedIndex
{

    _selectedIndex = selectedIndex;
}

- (UIView *)selectionIndicator
{
    if (!_selectionIndicator) {
        _selectionIndicator = [[UIView alloc]init];
        _selectionIndicator.backgroundColor = self.selectedTitleColor;
        [self.tagCollectionView addSubview:_selectionIndicator];
    }
    return _selectionIndicator;
}

- (NSTimer *)graceTimer
{
 
    if (self.graceTime) {
        if (!_graceTimer) {
            _graceTimer = [NSTimer timerWithTimeInterval:5.f target:self selector:@selector(updateViewControllersCaches) userInfo:nil repeats:YES];
            [_graceTimer setFireDate:[NSDate distantFuture]];
            [[NSRunLoop mainRunLoop] addTimer:_graceTimer forMode:NSDefaultRunLoopMode];
        }
        return _graceTimer;
    }
    return nil;
}

#pragma - mark 初始化方法
- (instancetype)initWithTitles:(NSArray *)titleArray andSubViewdisplayClassNames:(NSArray *)classNames andTagViewHeight:(CGFloat)tagViewHeight
{
    if (self = [super init]) {
        
#warning 因为之后的代码会使用这两个方法设置的数据,所以顺序必须在前面执行
        //设置默认值
        [self setupDefaultProperties];
        
        //将titleArray转换成模型Array
        [self convertKeyValue2Model:titleArray];
        
        //初始化两个CollectionView
        [self setupCollectionView];
        
        self.tagViewHeight = tagViewHeight;
 
        self.tagViewHeight = tagViewHeight;
        self.displayClassNames = classNames;
        
        }
    return self;
}

- (void)setupDefaultProperties
{
    self.normalTitleFont = [UIFont systemFontOfSize:13];
    self.selectedTitleFont = [UIFont systemFontOfSize:18];
    self.normalTitleColor = [UIColor darkGrayColor];
    self.selectedTitleColor = [UIColor redColor];
    self.tagViewSectionInset = UIEdgeInsetsZero;
    self.tagItemSectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
    self.tagItemSize = CGSizeZero;
}


- (void)setupCollectionView
{
    //初始化标签布局
    UICollectionViewFlowLayout *tagFlowLayout = [[UICollectionViewFlowLayout alloc]init];
    tagFlowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    tagFlowLayout.minimumLineSpacing = 0;
    tagFlowLayout.minimumInteritemSpacing = 0;
    tagFlowLayout.sectionInset = self.tagViewSectionInset;
    self.tagFlowLayout = tagFlowLayout;
    
    
    //初始化标签View
    UICollectionView *tagCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:tagFlowLayout];
    [tagCollectionView registerClass:[XBTagTitleCell class] forCellWithReuseIdentifier:kTagCollectionViewCellIdentifier];
    tagCollectionView.backgroundColor = [UIColor whiteColor];
    tagCollectionView.showsHorizontalScrollIndicator = NO;
    tagCollectionView.dataSource = self;
    tagCollectionView.delegate = self;
    self.tagCollectionView = tagCollectionView;
    [self.view addSubview:self.tagCollectionView];
    
    //初始化页面布局
    UICollectionViewFlowLayout *pageFlowLayout = [[UICollectionViewFlowLayout alloc]init];
    pageFlowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    pageFlowLayout.minimumLineSpacing = 0;
    pageFlowLayout.minimumInteritemSpacing = 0;
    self.pageFlowLayout = pageFlowLayout;
    
    //初始化页面View
    UICollectionView *pageCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:pageFlowLayout];
    [pageCollectionView registerClass:[XBPageCell class] forCellWithReuseIdentifier:kPageCollectionViewCellIdentifier];
    pageCollectionView.backgroundColor = [UIColor whiteColor];
    pageCollectionView.showsHorizontalScrollIndicator = NO;
    pageCollectionView.dataSource = self;
    pageCollectionView.delegate = self;
    pageCollectionView.pagingEnabled = YES;
    self.pageCollectionView = pageCollectionView;
    
    [self.view addSubview:self.pageCollectionView];
}



#pragma - mark LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.tagCollectionView.frame = CGRectMake(0, 0, XBScreenWidth, self.tagViewHeight);
    self.pageCollectionView.frame = CGRectMake(0, self.tagViewHeight, XBScreenWidth, XBScreenHeight - self.tagViewHeight);
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    self.selectedIndex = indexPath;


}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.tagTitleModelArray.count != 0) {
        self.selectedIndex = [NSIndexPath indexPathForItem:0 inSection:0];
        [self collectionView:self.tagCollectionView didSelectItemAtIndexPath:self.selectedIndex];
    }
}


#pragma mark - UICollectionViewDataSource Protocol Methods
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
//    NSAssert(self.tagTitleModelArray.count != self.displayClassNames.count, @"标题与控制器数量不一致!");
    
    return self.tagTitleModelArray?self.tagTitleModelArray.count:0;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{

    
    NSInteger index = indexPath.item;
    if ([self isTagView:collectionView]) {     //标签
        
        XBTagTitleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kTagCollectionViewCellIdentifier forIndexPath:indexPath];
        
        if (iOS7x) {
            [self collectionView:collectionView willDisplayCell:cell forItemAtIndexPath:indexPath];
        }
        
        [self saveCachedFrame:cell.frame ByIndexPath:indexPath];
        
        XBTagTitleModel *tagTitleModel = self.tagTitleModelArray[index];
        cell.tagTitleModel = tagTitleModel;
        cell.backgroundColor = self.backgroundColor;
        return cell;
    }else{                                              //页面
        XBPageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kPageCollectionViewCellIdentifier forIndexPath:indexPath];
        if (iOS7x) {
            [self collectionView:collectionView willDisplayCell:cell forItemAtIndexPath:indexPath];
        }

        return cell;
        
    }
    return nil;
}


#pragma mark - UICollectionViewDelegateFlowLayout Protocol Methods
//cell Size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    NSInteger index = indexPath.item;
    if ([self isTagView:collectionView]) {     //标签
        if (CGSizeEqualToSize(CGSizeZero, self.tagItemSize)) {      //如果用户没有手动设置tagItemSize
            
            CGRect cellFrameCache;
            //先取缓存,没有才计算
            cellFrameCache = [self getCachedFrameByIndexPath:indexPath];
            if (!CGRectEqualToRect(cellFrameCache, CGRectZero)) { //有缓存
                return cellFrameCache.size;
            }
            
            XBTagTitleModel *tagTitleModel = self.tagTitleModelArray[index];
            NSString *title = tagTitleModel.tagTitle;
            CGSize titleSize = [self sizeForTitle:title withFont:((tagTitleModel.normalTitleFont.pointSize >= tagTitleModel.selectedTitleFont.pointSize)?tagTitleModel.normalTitleFont:tagTitleModel.selectedTitleFont)];
            return CGSizeMake(titleSize.width + self.tagItemSectionInset.right + self.tagItemSectionInset.left, self.tagViewHeight);;
        }else
        {
            return self.tagItemSize;
        }

    }else
    {
        return collectionView.frame.size;
    }
}

#pragma mark - UICollectionViewDelegate Protocol Methods
//选中tag
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self isTagView:collectionView]) {                     //选中某个标签
        [self updateSelectionIndicatorWithOldSelectedIndex:self.selectedIndex
                                            newNSIndexPath:indexPath];
        self.selectedIndex = indexPath;

        [collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
        [self.pageCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionRight animated:NO];
        
        //算了半天,发现上面三行代码就完美实现了下面这么多注释的功能,一万只草泥马呼啸而过
        
        /*
        //清中之前的选中状态
        XBTagTitleCell *preCell = (XBTagTitleCell *)[collectionView cellForItemAtIndexPath:self.selectedIndex];

        //如果之前选中的当前可见,则修改状态,否则将在endDisplay中修改
        preCell.selected = ![collectionView.visibleCells containsObject:preCell];
        
        
        int factor = (self.selectedIndex.item == indexPath.item)?1:-1;
        
        
        //更新现在的选中状态
        self.selectedIndex = indexPath;
        XBTagTitleCell *currentCell = (XBTagTitleCell *)[collectionView cellForItemAtIndexPath:indexPath];
        //currentCell为空表示要滑动到的cell当前no visible,
        if (!currentCell) {
            [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
            return;
            
        }
        
        
        [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        return;
        

        currentCell.selected = YES;
        
        
        
        //让选中的tagItem居中
        CGFloat shouldScorllDistance = currentCell.center.x - XBScreenWidth * 0.5;
        if ((currentCell.center.x > XBScreenWidth * 0.5)&&(currentCell.center.x < collectionView.contentSize.width - XBScreenWidth * 0.5)) {
            XBLog(@"%f",shouldScorllDistance);

            collectionView.contentOffset = CGPointMake(shouldScorllDistance, 0);
        }
        
        [self.pageCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionRight animated:NO];
        
        */

    }
}
//即将展示的Cell iOS8 available
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(id)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self isTagView:collectionView]) {
        [cell setSelected:(self.selectedIndex.item == indexPath.item)?YES:NO];
    }else
    {
        //更新page状态
        NSString *displayClassName = (self.displayClassNames.count == 1)?[self.displayClassNames firstObject]:self.displayClassNames[indexPath.item];
        
        Class className = NSClassFromString(displayClassName);
        
        //取缓存
        UIViewController *cachedViewController = [self getCachedVCByIndexPath:indexPath];
        if (!cachedViewController) {   //如果缓存里不存在,生成新的VC,并加入缓存(如果缓存里存在,表明之前alloc过,直接使用 )
            cachedViewController = [[className alloc]init];
        }
         //更新缓存
        [self saveCachedVC:cachedViewController ByIndexPath:indexPath];
        [self addChildViewController:cachedViewController];
        [cell configCellWithController:cachedViewController];
        
        }
}


//消失的cell
- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self isTagView:collectionView]) {          //tag
        cell.selected = NO;
    }
    else{                                               //page
        //从缓存中取出instaceController
        UIViewController *cachedViewController = [self getCachedVCByIndexPath:indexPath];

        if (!cachedViewController) {
            return;
        }
        
        //更新缓存时间
        [self saveCachedVC:cachedViewController ByIndexPath:indexPath];
        
        //从父控制器中移除
        [cachedViewController removeFromParentViewController];
        [cachedViewController.view removeFromSuperview];
    }
}

#pragma - mark UIScrollerViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == self.pageCollectionView) {
        int index = scrollView.contentOffset.x / self.pageCollectionView.frame.size.width;
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
        
        [self collectionView:self.tagCollectionView didSelectItemAtIndexPath:indexPath];
    }
}


#pragma mark - Private Methods
- (CGSize)sizeForTitle:(NSString *)title withFont:(UIFont *)font
{
    CGRect titleRect = [title boundingRectWithSize:CGSizeMake(FLT_MAX, FLT_MAX)
                                           options:NSStringDrawingUsesLineFragmentOrigin
                                        attributes:@{NSFontAttributeName : font}
                                           context:nil];
    
    return CGSizeMake(titleRect.size.width,
                      titleRect.size.height);
}

- (void)convertKeyValue2Model:(NSArray *)titleArray
{
    
    [self.tagTitleModelArray removeAllObjects];
    for (int i = 0; i < titleArray.count; i++) {
        XBTagTitleModel *tag = [XBTagTitleModel modelWithtagTitle:titleArray[i] andNormalTitleFont:self.normalTitleFont andSelectedTitleFont:self.selectedTitleFont andNormalTitleColor:self.normalTitleColor andSelectedTitleColor:self.selectedTitleColor];
        [self.tagTitleModelArray addObject:tag];
    }
}

- (BOOL)isTagView:(UICollectionView *)collectionView
{
    if (self.tagCollectionView == collectionView) {
        return YES;
    }
    return NO;
}

- (UIViewController *)getCachedVCByIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *cachedDic = [self.viewControllersCaches objectForKey:@(indexPath.item)];
    UIViewController *cachedViewController = [cachedDic objectForKey:kCachedVCName];
    return cachedViewController;
}

- (void)saveCachedVC:(UIViewController *)viewController ByIndexPath:(NSIndexPath *)indexPath
{
    NSDate *newTime =[NSDate date];
    NSDictionary *newCacheDic = @{kCachedTime:newTime,
                                  kCachedVCName:viewController};
    [self.viewControllersCaches setObject:newCacheDic forKey:@(indexPath.item)];

}

- (void)saveCachedFrame:(CGRect)frame ByIndexPath:(NSIndexPath *)indexPath
{
    [self.frameCaches setObject:[NSValue valueWithCGRect:frame] forKey:@(indexPath.item)];
}

- (CGRect)getCachedFrameByIndexPath:(NSIndexPath *)indexPath
{
    NSValue *frameValue = [self.frameCaches objectForKey:@(indexPath.item)];
    return [frameValue CGRectValue];
}


- (void)dealloc
{
    [self.graceTimer invalidate];
    self.graceTimer = nil;
}


- (void)updateViewControllersCaches
{
    NSDate *currentDate = [NSDate date];
    __weak typeof(self) weakSelf = self;
    
    NSMutableDictionary *tempDic = self.viewControllersCaches;
    
    
    [self.viewControllersCaches enumerateKeysAndObjectsUsingBlock:^(NSNumber *key, NSDictionary *obj, BOOL *stop) {
        UIViewController *vc = [obj objectForKey:kCachedVCName];
        NSDate *cachedTime = [obj objectForKey:kCachedTime];
        NSInteger keyInteger = [key integerValue];
        NSInteger selectionInteger = weakSelf.selectedIndex.item;
        
        if (keyInteger != selectionInteger) {         //当前不是当前正在展示的cell
            NSTimeInterval timeInterval = [currentDate timeIntervalSinceDate:cachedTime];
            if (timeInterval >= weakSelf.graceTime) {
                //宽限期到了销毁控制器
                [tempDic removeObjectForKey:key];
                [vc.view removeFromSuperview];
                [vc removeFromParentViewController];
            }
        }
    }];
    self.viewControllersCaches = tempDic;
}

- (void)updateSelectionIndicatorWithOldSelectedIndex:(NSIndexPath *)oldSelectedIndex
                                      newNSIndexPath:(NSIndexPath *)newSelectedIndex
{
    CGRect oldFrame = [self getCachedFrameByIndexPath:oldSelectedIndex];
    CGRect oldf = oldFrame;
    oldf.size.height = 2;
    oldf.origin.y = self.tagViewHeight - 2;
    oldFrame = oldf;
    
    CGRect newFrame = [self getCachedFrameByIndexPath:newSelectedIndex];
    CGRect newf = newFrame;
    newf.size.height = 2;
    newf.origin.y = self.tagViewHeight - 2;
    newFrame = newf;


    self.selectionIndicator.frame = oldFrame;

    
    
    [UIView animateWithDuration:0.2 animations:^{
        self.selectionIndicator.frame = newFrame;
    }];
    
}
#pragma mark - Public Methods
- (void)reloadDataWith:(NSArray *)titleArray andSubViewdisplayClassNames:(NSArray *)classNames
{
    [self convertKeyValue2Model:titleArray];
    self.displayClassNames = classNames;
    [self.tagCollectionView reloadData];
    [self.pageCollectionView reloadData];
}


- (void)scrollToTagByIndex:(NSInteger)index
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    [self collectionView:self.tagCollectionView didSelectItemAtIndexPath:indexPath];

}

@end
