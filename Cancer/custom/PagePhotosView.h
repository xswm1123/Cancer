//
//  PagePhotosView.h
//
//  Created by husu  on 13-4-01.
//  Copyright 2013 Parsec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PagePhotosDataSource.h"



@interface PagePhotosView : UIView<UIScrollViewDelegate> {
	UIScrollView *scrollView;
	UIPageControl *pageControl;
	
	id<PagePhotosDataSource> dataSource;
	NSMutableArray *imageViews;
	
	// To be used when scrolls originate from the UIPageControl
    BOOL pageControlUsed;

    BOOL canAutoTurnPage;

    NSTimer *timer;
    int curPage;
}

@property (nonatomic, strong) id<PagePhotosDataSource> dataSource;
@property (nonatomic, strong) NSMutableArray *imageViews;
@property(nonatomic,strong)UIPageControl *pageControl;


- (IBAction)changePage:(id)sender;

-(void)tapImageView:(UITapGestureRecognizer *)gesture;

- (id)initWithFrame:(CGRect)frame withDataSource:(id<PagePhotosDataSource>)_dataSource;

-(void)slide:(NSNumber *) page;

-(void)reload;

-(void)autoTurnPage:(BOOL)open;

@end
