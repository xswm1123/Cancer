//
//  CommonTableView.m
//  CommonViewController
//
//  Created by hsyouyou on 13-4-18.
//  Copyright (c) 2013年 parsec. All rights reserved.
//

#import "CommonTableView.h"

@implementation CommonTableView
@synthesize refreshHeaderView=_refreshHeaderView;
@synthesize refreshSpinner=_refreshSpinner;
@synthesize customDelegate=_customDelegate;
@synthesize shutRefresh=_shutRefresh;
bool firstLoad=YES;
- (id)initWithFrame:(CGRect)frame
{
    isLoading = NO;
    isDragging = NO;
    self = [super initWithFrame:frame];
    if (self) {
//       [self addPullToRefreshHeader];
    }
    return self;
}



// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
 
    isLoading = NO;
    isDragging =NO;
    [self addPullToRefreshHeader];
    firstLoad = NO;

}


- (void)addPullToRefreshHeader {
    
    if (self.shutRefresh) {
        return;
    }
    
    //    UITableView *tableView = (UITableView *)self.view;
    self.refreshHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 52.0f*(-1),  self.frame.size.width, 52.0f)];
    self.refreshHeaderView.backgroundColor = [UIColor clearColor];
    
    self.pullRefreshLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 52.0f)];
    self.pullRefreshLabel.backgroundColor = [UIColor clearColor];
    self.pullRefreshLabel.font = [UIFont boldSystemFontOfSize:12.0];
    self.pullRefreshLabel.textAlignment = NSTextAlignmentCenter;
    
    self.pullRefreshLabel.textColor = [UIColor blackColor];
    self.pullRefreshLabel.text = @"下拉刷新";
    self.refreshSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.refreshSpinner.frame = CGRectMake((52.0f - 20) / 2, (52.0f - 20) / 2, 20, 20);
    self.refreshSpinner.hidesWhenStopped = YES;
    
    [self.refreshHeaderView addSubview:self.pullRefreshLabel];
    
    [self.refreshHeaderView addSubview:self.refreshSpinner];
    [self addSubview:self.refreshHeaderView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (self.shutRefresh) {
        return;
    }
    
    if (isLoading) return;
    
    if (isDragging && (scrollView.contentOffset.y <= -52.0f)) {
      self.contentInset = UIEdgeInsetsMake(53, 0, 0, 0);
        
        [self startLoad];
        
    }

}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (self.shutRefresh) {
        return;
    }
    
    if(isLoading)return;
    isDragging = YES;
}
-(void)startLoad{
    
    isLoading = YES;
    isDragging=NO;
    [self.refreshSpinner startAnimating];
    self.pullRefreshLabel.text= @"正在加载";
    [self.customDelegate refreshTableView:self];
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    
//    NSLog(@"====%lf",scrollView.contentOffset.y);
    if (self.shutRefresh) {
        return;
    }

    self.pullRefreshLabel.textColor = [UIColor grayColor];
    if (isLoading) {
        // Update the content inset, good for section headers
        if (scrollView.contentOffset.y > 0){
            self.contentInset = UIEdgeInsetsZero;
        }else if (scrollView.contentOffset.y >= 52)
            self.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        
    } else if (isDragging && scrollView.contentOffset.y < 0) {
        if (scrollView.contentOffset.y < -52) {

            self.pullRefreshLabel.text = @"释放刷新列表";
            
        }else {
            self.pullRefreshLabel.text = @"下拉刷新";
            
        }
        
        
    }else if(isDragging && (scrollView.contentOffset.y + scrollView.frame.size.height )>scrollView.contentSize.height){
        
        if(isLoading)return;
//        isLoading = YES;
        [self.customDelegate gotoNextPage:nil];
        
        
    }
}
//
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [[self nextResponder] touchesBegan:touches withEvent:event];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
    [[self nextResponder] touchesEnded:touches withEvent:event];
}

-(void)refreshSuccessed{
    [self.refreshSpinner stopAnimating];
    self.contentInset = UIEdgeInsetsZero;
    isLoading = NO;
    isDragging = NO;
    self.pullRefreshLabel.text = @"下拉刷新";
}


-(void)showDataLoading{
     self.contentInset = UIEdgeInsetsMake(53, 0, 0, 0);
    [self.refreshSpinner startAnimating];
    self.pullRefreshLabel.text = @"正在加载";
}

@end
