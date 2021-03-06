//
//  XBTagTitleCell.m
//  XBScrollPageController
//
//  Created by Scarecrow on 15/9/6.
//  Copyright (c) 2015年 xiu8. All rights reserved.
//

#import "XBTagTitleCell.h"
#import "XBTagTitleModel.h"
@interface XBTagTitleCell()
@property (nonatomic, strong) UILabel *titleLabel;
@end
@implementation XBTagTitleCell
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self.contentView addSubview:_titleLabel];
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted
{
    //空方法,取消长按时自动变色
}

- (void)setSelected:(BOOL)selected
{
    if (selected) {
        self.titleLabel.font = self.tagTitleModel.selectedTitleFont;
        self.titleLabel.textColor = self.tagTitleModel.selectedTitleColor;
    }else
    {
        self.titleLabel.font = self.tagTitleModel.normalTitleFont;
        self.titleLabel.textColor = self.tagTitleModel.normalTitleColor;
    }
//    [self layoutIfNeeded];
}

- (void)setTagTitleModel:(XBTagTitleModel *)tagTitleModel
{
    _tagTitleModel = tagTitleModel;
    [self updateUI];
}

- (void)updateUI
{
    self.titleLabel.text = self.tagTitleModel.tagTitle;
    self.titleLabel.font = self.tagTitleModel.normalTitleFont;
    self.titleLabel.textColor = self.tagTitleModel.normalTitleColor;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.titleLabel.frame = self.bounds;
}

@end
