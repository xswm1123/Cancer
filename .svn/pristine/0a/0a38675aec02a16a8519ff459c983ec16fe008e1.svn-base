//
//  ContactsViewController.h
//  Cancer
//
//  Created by zpj on 14/11/5.
//  Copyright (c) 2014年 parsec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIWaitView.h"
#import "UtilTool.h"
#import "SBJsonParser.h"
#import "AddReportViewController.h"

@class AddReportViewController;

@interface ContactsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) IBOutlet UITableView *contactsTable;//联系人显示列表

@property(nonatomic, strong) IBOutlet UIImageView *enterBtn;

@property(nonatomic, strong) IBOutlet UIImageView *cancelBtn;

@property(nonatomic, strong) NSMutableArray *displayArray;

@property(nonatomic, strong) NSDictionary *selectDict;

@property(nonatomic, strong) IBOutlet NSLayoutConstraint *btnCenterConstraint;

@property(nonatomic, strong) UIWaitView *waitView;

@property AddReportViewController *addReportViewController;

@property(nonatomic, strong) IBOutlet UILabel *titlelabel;

@property(nonatomic, strong) NSString *titleName;

-(void)cacelClick;

-(void)enterClick;

@end
