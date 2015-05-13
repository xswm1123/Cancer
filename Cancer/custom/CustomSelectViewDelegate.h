//
// Created by hu su on 14-7-1.
// Copyright (c) 2014 parsec. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CustomSelectView;
@class UIScrollView;


@protocol CustomSelectViewDelegate
-(void)selectTab:(NSInteger) selectIndex selectView:(UIScrollView *)selectView;
-(NSString *)getLabelName:(NSInteger) index  SelectView:(UIScrollView *)selectView;
-(NSInteger)getLabelCount:(UIScrollView *)selectView;

@end