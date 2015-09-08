# XBScrollPageController
iOS分页控制器,只需传入标题数组和控制器类名数组即可.
##特性
* 使用简单
* 增加了控制器缓存,并可自定义缓存时间,一段时间内未被重新展示的标签对应的控制器将被销毁

实现效果图如下:
</br>

![效果图](https://github.com/changjianfeishui/XBScrollPageController/raw/master/1.gif)

##使用方法

1. 在项目中导入**XBScrollPageController**文件夹(包含MVC,及常量定义文件).

2. 自定义一个控制器继承XBScrollPageController:

		@interface ViewController : XBScrollPageController


		@end
		
3. 重载自定义控制器的init方法(从代码和xib,SB创建的init方法不一样,请注意):

		//代码创建
		- (instancetype)init
		{
   			 NSArray *titleArray = @[@"All cars",
                            @"Audi",
                            @"Bitter",
                            @"BMW",
                            @"Büssing",
                            @"Gumpert",
                            @"MAN",
                            @"Mercedes-BenzMercedes-BenzMercedes-BenzMercedes-Benz",
                            @"Multicar",
                            @"Neoplan",
                            @"NSU",
                            @"Opel",
                            @"Porsche",
                            @"Robur",
                            @"Volkswagen",
                            @"Wiesmann"];
    
   			 NSArray *classNames = @[@"TestViewController"];
    
  			  self = [super initWithTitles:titleArray andSubViewdisplayClassNames:classNames andTagViewHeight:49];
    		if (self) {
        
    		}
	    	return self;
		}
		
4.在之后的viewDidLoad中可以设置相关属性,具体属性说明参见下文说明或者查看头文件,由于存在继承关系,可以直接根据self点语法使用,部分示例如下:

	self.tagItemSize = CGSizeMake(100, 49);
    self.selectedTitleColor = [UIColor blueColor];
    
    self.graceTime = 300;
    
    

##部分属性方法说明
###字体及颜色

* normalTitleFont: 正常(非选中)标签字体  default is 13,

* selectedTitleFont: 选中状态标签字体  default is 18,

* normalTitleColor: 正常(非选中)标签字体颜色  default is darkGrayColor,
* selectedTitleColor: 选中状态标签字体颜色及下方滑块颜色  default is redColor,
* tagItemSectionInset: 每个tag标签的缩进,不设置的话选中状态可能会导致文字显示不全... default is UIEdgeInsetsMake(0, 10, 0, 10),如果设置了tagItemSize属性则该属性失效

* tagItemSize: 每个tag标签的size,如果不设置则会根据文本长度计算,设置该属性后tagItemSectionInset失效

* graceTime:控制器缓存时间,如果在该段时间内缓存的控制器依旧没有被展示,则会从内存中销毁,默认不设置,即默认在内存中缓存所有展示过的控制器
* backgroundColor: 标签展示的背景色

###public方法:
* scrollToTagByIndex:(NSInteger)index: 根据索引值设置滚动到某个tag,**注意索引值不要超过初始化时设置的tag数组长度,否则会造成数组越界崩溃**
* reloadDataWith:(NSArray *)titleArray andSubViewdisplayClassNames:(NSArray *)classNames: 刷新整个界面,提供给某些应用场景比如从服务器获取tag组后需要更新界面.

##问题反馈
QQ:329735967
email:329735967@qq.com
