//
//  InSideMsgDetailViewController.h
//  Cancer
//
//  Created by Parsec on 14-10-31.
//  Copyright (c) 2014年 parsec. All rights reserved.
//

#import "CommonViewController.h"
#import "UIWaitView.h"

@interface InSideMsgDetailViewController : CommonViewController

@property(nonatomic,strong)IBOutlet UILabel *titleLabel;

@property(nonatomic,strong)IBOutlet UILabel *timeLabel;

@property(nonatomic,strong)IBOutlet UITextView *instroTextView;

@property UIWaitView *waitView;

@property NSString *msgTitle;

@property long messageId;

@end
