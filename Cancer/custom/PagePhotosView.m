//
//  PagePhotosView.m
//
//  Created by husu  on 13-4-01.
//  Copyright 2013 Parsec. All rights reserved.
//
#import "PagePhotosView.h"
#import <SDWebImage/UIImageView+WebCache.h>



@interface PagePhotosView (PrivateMethods)
- (void)loadScrollViewWithPage:(int)page;
- (void)scrollViewDidScroll:(UIScrollView *)sender;
@end

@implementation PagePhotosView
const int timeInterval = 3;

@synthesize dataSource;
@synthesize imageViews;
@synthesize pageControl;

- (id)initWithFrame:(CGRect)frame withDataSource:(id<PagePhotosDataSource>)_dataSource {
    if ((self = [super initWithFrame:frame])) {
		self.dataSource = _dataSource;
        // Initialization UIScrollView
		int pageControlHeight = 15;
		scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
		pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, frame.size.height - pageControlHeight, frame.size.width, pageControlHeight)];
		
        pageControl.alpha = 1.0f;
        
		[self addSubview:scrollView];
		[self addSubview:pageControl];
		
		int kNumberOfPages = [dataSource numberOfPages:self];
		
		// in the meantime, load the array with placeholders which will be replaced on demand
		NSMutableArray *views = [[NSMutableArray alloc] init];
		for (unsigned i = 0; i < kNumberOfPages; i++) {
			[views addObject:[NSNull null]];
		}
		self.imageViews = views;
		
		
		// a page is the width of the scroll view
		scrollView.pagingEnabled = YES;
		scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * kNumberOfPages, scrollView.frame.size.height);
		scrollView.showsHorizontalScrollIndicator = NO;
		scrollView.showsVerticalScrollIndicator = NO;
		scrollView.scrollsToTop = NO;
		scrollView.delegate = self;
		
		pageControl.numberOfPages = kNumberOfPages;
		pageControl.currentPage = 0;
		pageControl.backgroundColor = [UIColor clearColor];
        
        if (kNumberOfPages<2) {
            pageControl.hidden = YES;
        }else {
            pageControl.hidden = NO;
        }
        
		
		// pages are created on demand
		// load the visible page
		// load the page on either side to avoid flashes when the user starts scrolling
		[self loadScrollViewWithPage:0];
		[self loadScrollViewWithPage:1];
		
    }
    return self;
}


- (void)loadScrollViewWithPage:(int)page {
	int kNumberOfPages = [dataSource numberOfPages:self];
	
    if (page < 0) return;
    if (page >= kNumberOfPages) return;
	
//    self.pageControl.currentPage = page;
    
    // replace the placeholder if necessary
    UIImageView *view = [imageViews objectAtIndex:page];
    
  
    
    
    if ((NSNull *)view == [NSNull null]) {
		NSString *image = [dataSource imageAtIndex:page PagePhotosView:self];
        
        
        
        view = [[UIImageView alloc]init];
        if (![[[image substringToIndex:4] lowercaseString] isEqualToString:@"http"]) {
            [view setImage:[UIImage imageNamed:image]];
        }else{
            [view setImageWithURL:[NSURL URLWithString:image] placeholderImage:[UIImage imageNamed:@"adLoading.png"]];
        }
        
        [imageViews replaceObjectAtIndex:page withObject:view];
        
        UITapGestureRecognizer *guesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView:)];
        guesture.numberOfTapsRequired =1;
        view.userInteractionEnabled = YES;
        view.tag = page;
        [view addGestureRecognizer:guesture];
		
    }
	
    // add the controller's view to the scroll view
    if (nil == view.superview) {
        CGRect frame = scrollView.frame;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0;
        view.frame = frame;
        [scrollView addSubview:view];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    // We don't want a "feedback loop" between the UIPageControl and the scroll delegate in
    // which a scroll event generated from the user hitting the page control triggers updates from
    // the delegate method. We use a boolean to disable the delegate logic when the page control is used.
    if (pageControlUsed) {
        // do nothing - the scroll was initiated from the page control, not the user dragging
        return;
    }
	
    // Switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    pageControl.currentPage = page;
	
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
	
    // A possible optimization would be to unload the views+controllers which are no longer visible
}

// At the begin of scroll dragging, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    pageControlUsed = NO;
}

// At the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    pageControlUsed = NO;
}

- (IBAction)changePage:(id)sender {
    int page = (int)pageControl.currentPage;
	
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    
	// update the scroll view to the appropriate page
    CGRect frame = scrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [scrollView scrollRectToVisible:frame animated:YES];
    
	// Set the boolean used when scrolls originate from the UIPageControl. See scrollViewDidScroll: above.
    pageControlUsed = YES;
}

-(void)tapImageView:(UITapGestureRecognizer *)gesture{
    NSInteger page = gesture.view.tag;
    [dataSource selectImageView:page pagePhotosView:self];
}

-(void)slide:(NSNumber *)page{
    CGFloat pageWidth = scrollView.frame.size.width;
    NSInteger toPage= [page intValue];
    [scrollView scrollRectToVisible:CGRectMake(pageWidth*toPage, 0, pageWidth, self.frame.size.height) animated:YES];
}


-(void)reload{
    int pageControlHeight = 15;
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.frame.size.height - pageControlHeight, self.frame.size.width, pageControlHeight)];

    pageControl.alpha = 1.0f;

    [self addSubview:scrollView];
    [self addSubview:pageControl];

    int kNumberOfPages = [dataSource numberOfPages:self];

    // in the meantime, load the array with placeholders which will be replaced on demand
    NSMutableArray *views = [[NSMutableArray alloc] init];
    for (unsigned i = 0; i < kNumberOfPages; i++) {
        [views addObject:[NSNull null]];
    }
    self.imageViews = views;


    // a page is the width of the scroll view
    scrollView.pagingEnabled = YES;
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * kNumberOfPages, scrollView.frame.size.height);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.scrollsToTop = NO;
    scrollView.delegate = self;

    pageControl.numberOfPages = kNumberOfPages;
    pageControl.currentPage = 0;
    pageControl.backgroundColor = [UIColor clearColor];

    if (kNumberOfPages<2) {
        pageControl.hidden = YES;
    }else {
        pageControl.hidden = NO;
    }


    // pages are created on demand
    // load the visible page
    // load the page on either side to avoid flashes when the user starts scrolling
    [self loadScrollViewWithPage:0];
    [self loadScrollViewWithPage:1];
}

- (void)autoTurnPage:(BOOL)open {

    canAutoTurnPage = open;
    if(!open){
        if(timer && timer.isValid){
            [timer invalidate];
        }
    }else{
        if(!(timer && timer.isValid)){
            curPage=0;
            timer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(turnPage) userInfo:nil repeats:YES];
        }
    }
}

-(void)turnPage{
    if([self.dataSource numberOfPages:self]>0){
        if(canAutoTurnPage){
            curPage++;
            if(curPage>=[self.dataSource numberOfPages:self]){
                curPage=0;
            }
            [self slide:[NSNumber numberWithInt:curPage]];

        }
    }
}

@end
