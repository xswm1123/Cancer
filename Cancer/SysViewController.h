//
//  SysViewController.h
//  Cancer
//
//  Created by Parsec on 14-11-5.
//  Copyright (c) 2014年 parsec. All rights reserved.
//

#import "CommonViewController.h"
#import "UIWaitView.h"

@interface SysViewController : CommonViewController

@property(nonatomic,strong)IBOutlet UILabel *versionLabel;

@property(nonatomic,strong)IBOutlet UIWebView *infoWebView;

@property(nonatomic,strong)UIWaitView *waitView;

@property(nonatomic,strong)IBOutlet UILabel *msgLabel;

@end
