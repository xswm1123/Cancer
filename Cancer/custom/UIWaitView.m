//
//  UIWaitView.m
//  smartdog
//
//  Created by  on 12-7-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UIWaitView.h"
#import "UtilTool.h"

@implementation UIWaitView

@synthesize aiv;
@synthesize backView=_backView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        aiv = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self setFrame:frame];


        [aiv setFrame:CGRectMake(25,5, 50, 50)];



        self.backView.frame = CGRectMake(25, 5, 80, 80);



        [self.backView.layer setCornerRadius:10];
        [self.backView.layer setMasksToBounds:YES];

        [self.backView setBackgroundColor:[UIColor blackColor]];
        self.backView.alpha = 0.7;
        
        
        [[self layer]setCornerRadius:10];
        [[self layer]setBorderWidth:0];
//        [[self layer]setBorderColor:[[UIColor redColor] CGColor]];
        [[self layer]setMasksToBounds:YES];
        
        [self addSubview:aiv];
        [self addSubview:self.backView];
        [self setBackgroundColor:[UIColor clearColor]];
//        [self setAlpha:0.6f];

    }
    return self;
}

-(id)init:(CGRect)superViewFrame
{
    self = [super init];
    aiv = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [self setFrame:CGRectMake((superViewFrame.size.width - 100) / 2, (superViewFrame.size.height - 200) / 2, 100, 60)];





   
    self.backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,100,60)];
    self.backView.backgroundColor = [UIColor blackColor];
    self.backView.alpha = 0.6f;
    
    [aiv setFrame:CGRectMake(25,5, 50, 50)];
    [[self.backView layer]setCornerRadius:10];
    [[self.backView layer]setBorderWidth:0];
    [[self.backView layer]setBorderColor:[[UIColor clearColor] CGColor]];
    [[self.backView layer]setMasksToBounds:YES];
    [self.backView setBackgroundColor:[UIColor blackColor]];
    self.alpha = 1.0f;
    [self addSubview:self.backView];
    [self addSubview:aiv];
//    [self setBackgroundColor:[UIColor blackColor]];

    return self;
}

- (void)startAnimating {
    [self.aiv startAnimating];
}

- (void)stopAnimating {
    [self.aiv stopAnimating];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
