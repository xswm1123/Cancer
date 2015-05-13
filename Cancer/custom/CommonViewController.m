//
//  CommonViewController.m
//  auriga
//
//  Created by hu su on 14-6-30.
//  Copyright (c) 2014 parsec. All rights reserved.
//

#import "CommonViewController.h"
#import "UtilTool.h"

@implementation CommonViewController
@synthesize navTitle = _navTitle;

@synthesize hideRightBut = _hideRightBut;


@synthesize rightImage = _rightImage;

@synthesize customViewRight = _customViewRight;

@synthesize rightImageRect = _rightImageRect;

@synthesize leftImage = _leftImage;
@synthesize customViewLeft = _customViewLeft;

@synthesize leftImageRect = _leftImageRect;

@synthesize navTitleLabel = _navTitleLabel;




- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    if(!self.leftImage) {
        self.customViewLeft = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        self.customViewLeft.image = [UIImage imageNamed:@"返回.png"];
    } else{
        self.customViewLeft = [[UIImageView alloc] initWithFrame:self.leftImageRect];
        self.customViewLeft.image = self.leftImage;
    }

    UIBarButtonItem *leftbut= [[UIBarButtonItem alloc] initWithCustomView:self.customViewLeft];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickBack:)];
    tap.numberOfTapsRequired=1;
    [self.customViewLeft addGestureRecognizer:tap];
    [self.navigationItem setLeftBarButtonItem:leftbut];

//    CGSize oldSize=  self.navigationItem.titleView.frame.size;
//    CGPoint oldOrgin = self.navigationItem.titleView.frame.origin;

    self.navTitleLabel = [[UILabel alloc]  initWithFrame:CGRectMake(30, 0, 260, 30)];
    self.navTitleLabel.text=self.navTitle;
    self.navTitleLabel.backgroundColor = [UIColor clearColor];
    self.navTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.navTitleLabel.textColor = [UIColor whiteColor];

    if(isPad){
        self.navTitleLabel.font  = [UtilTool currentSystemFont:18.0];
    }


    [self.navigationItem setTitleView:self.navTitleLabel];


    //初始化右侧按钮

    if(!self.rightImage){
        self.customViewRight = [[UIImageView alloc] initWithFrame:CGRectMake(320-53, 0, 30, 30)];

        self.customViewRight.image = [UIImage imageNamed:@"放大镜"];
    }else{
        self.customViewRight = [[UIImageView alloc] initWithFrame:self.rightImageRect];

        self.customViewRight.image = self.rightImage;
    }


    UIBarButtonItem *rightbut= [[UIBarButtonItem alloc] initWithCustomView:self.customViewRight];

    UITapGestureRecognizer *tapRight = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(share:)];
    tapRight.numberOfTapsRequired=1;
    [self.customViewRight addGestureRecognizer:tapRight];
    [self.navigationItem setRightBarButtonItem:rightbut];

    if(self.hideRightBut){
        self.navigationItem.rightBarButtonItem.customView.hidden = YES;
    }

}

- (void)clickBack:(UITapGestureRecognizer *)gesture {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)share:(UITapGestureRecognizer *)gesture {

}

-(void)setRightButImage:(UIImage *)image imageWidth:(CGFloat)width imageHeight:(CGFloat)height{
    self.rightImage = image;
    self.rightImageRect = CGRectMake(320-width,0,width,height);
}

- (void)setLeftButImage:(UIImage *)image imageWidth:(CGFloat)width imageHeight:(CGFloat)height {
    self.leftImage = image;
    self.leftImageRect = CGRectMake(0, 0, width, height);
}


-(void)viewDidLoad {

    [super viewDidLoad];

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hideRightBut = YES;
    }

    return self;
}


@end
