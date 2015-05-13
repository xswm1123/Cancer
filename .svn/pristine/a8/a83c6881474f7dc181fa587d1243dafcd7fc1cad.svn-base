//
//  ReadAttachOnLineViewController.m
//  Cancer
//
//  Created by hu su on 14/11/2.
//  Copyright (c) 2014年 parsec. All rights reserved.
//

#import "ReadAttachOnLineViewController.h"
#import "UIWaitView.h"

@interface ReadAttachOnLineViewController ()

@end

@implementation ReadAttachOnLineViewController

@synthesize attachView = _attachView;

@synthesize waitView = _waitView;

@synthesize attachUrl = _attachUrl;


@synthesize fileName = _fileName;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.hideRightBut = YES;
    self.navTitle =@"查看附件";
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];


    self.waitView = [[UIWaitView alloc] init:self.view.frame];
    [self.waitView.aiv startAnimating];
    [self.attachView addSubview:self.waitView];


    if(self.attachUrl && [self.attachUrl length]>0) {

        NSURL *url = [NSURL URLWithString:self.attachUrl];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [self.attachView loadRequest:request];
    }


    if(self.fileName && [self.fileName length]>0){
        NSArray *arr  = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentPath = arr[0];
        NSString *path = [documentPath stringByAppendingString:[NSString stringWithFormat:@"/%@",self.fileName]  ];

        NSURL *url =[NSURL fileURLWithPath:path];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];

        [self.attachView loadRequest:request];
    }

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.waitView.aiv stopAnimating];
    [self.waitView removeFromSuperview];

}


@end
