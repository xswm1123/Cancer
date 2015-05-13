//
//  PagePhotosDataSource.h
//  PagePhotosDemo
//
//  Created by junmin liu on 10-8-23.
//  Copyright 2010 Openlab. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PagePhotosView;


@protocol PagePhotosDataSource

// 有多少页
//
- (int)numberOfPages:(PagePhotosView *)photosView;

// 每页的图片
//
- (NSString *)imageAtIndex:(int)index PagePhotosView:(PagePhotosView *)photosView;



-(void)selectImageView:(NSInteger)page pagePhotosView:(PagePhotosView *)photosView;

@end
