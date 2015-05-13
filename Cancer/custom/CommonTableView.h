//
//  CommonTableView.h
//  CommonViewController
//
//  Created by hsyouyou on 13-4-18.
//  Copyright (c) 2013年 parsec. All rights reserved.
//



#import <UIKit/UIKit.h>

@protocol PullRefreshDelegate <NSObject>
-(void)refreshTableView:(id)sender;
-(void)gotoNextPage:(id)sender;
@end

@interface CommonTableView : UITableView{
    BOOL isLoading;
    BOOL isDragging;
}
@property(nonatomic,strong)UILabel *pullRefreshLabel;
@property(nonatomic,strong)UIActivityIndicatorView *refreshSpinner;
@property(nonatomic,strong)UIView *refreshHeaderView;
@property(nonatomic,strong) id<PullRefreshDelegate> customDelegate;
@property BOOL shutRefresh;
-(void)refreshSuccessed;
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;
-(void)scrollViewDidScroll:(UIScrollView *)scrollView;
-(void)showDataLoading;
@end

