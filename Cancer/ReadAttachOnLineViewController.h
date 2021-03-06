//
//  ReadAttachOnLineViewController.h
//  Cancer
//
//  Created by hu su on 14/11/2.
//  Copyright (c) 2014年 parsec. All rights reserved.
//

#import "CommonViewController.h"

@class UIWaitView;

@interface ReadAttachOnLineViewController : CommonViewController<UIWebViewDelegate>

@property (nonatomic, strong) IBOutlet UIWebView *attachView;
@property (nonatomic, strong) UIWaitView *waitView;
@property (nonatomic, strong) NSString *attachUrl;
@property (nonatomic, strong) NSString *fileName;


@end
