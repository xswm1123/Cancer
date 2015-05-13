//
// Created by hu su on 14-6-18.
// Copyright (c) 2014 parsec. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class CustomSelectView;
@protocol CustomSelectViewDelegate;


@interface CustomSelectView : UIScrollView {

}
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) id<CustomSelectViewDelegate> customDelegate;
@property (nonatomic, strong)UIView *lineView;


-(void)reload;

-(void)selectIndex:(NSInteger)index;

-(void)initContentView;

@end