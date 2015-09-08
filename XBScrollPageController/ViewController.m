//
//  ViewController.m
//  XBScrollPageController
//
//  Created by Scarecrow on 14/9/6.
//  Copyright (c) 2014年 xiu8. All rights reserved.
//

#import "ViewController.h"
#import "TestViewController.h"
@interface ViewController ()

@end

@implementation ViewController

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

//SB创建
- (instancetype)initWithCoder:(NSCoder *)aDecoder
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
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"ScrollPageDemo";
    
//    self.tagItemSize = CGSizeMake(100, 49);
    self.selectedTitleColor = [UIColor blueColor];
    
    self.graceTime = 300;

    
    self.backgroundColor = [UIColor whiteColor];
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
    


}

- (void)dealloc
{

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
