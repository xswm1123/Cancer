//
//  WorkReportListViewController.h
//  Cancer
//
//  Created by hu su on 14/10/21.
//  Copyright (c) 2014年 parsec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonViewController.h"
#import "UIWaitView.h"
#import "CustomSelectView.h"
#import "CustomSelectViewDelegate.h"
#import "UtilTool.h"
#import "SBJsonParser.h"
#import "CommonTableView.h"

@interface WorkReportListViewController : CommonViewController<UITableViewDataSource, UITableViewDelegate, CustomSelectViewDelegate, PullRefreshDelegate, UITextFieldDelegate>

@property(nonatomic, strong) NSMutableArray *receiveReportArray; //接收汇报列表数组

@property(nonatomic, strong) NSMutableArray *sendReportArray; //发送汇报列表数组

@property(nonatomic, strong) NSArray *tabSelectName;//tab分页组件的名字

@property(nonatomic,strong) UIWaitView *waitView; //等待对话框

@property(nonatomic, strong) IBOutlet UIView *addReportBtn; //加入新汇报按钮

@property(nonatomic,strong) IBOutlet CustomSelectView *tabSelectView; //tab组件

@property(nonatomic,strong) IBOutlet CommonTableView *table; //显示列表组件

@property(nonatomic, strong) NSMutableArray *displayArray; //显示列表数组

@property Boolean isSearch;

@property int pageSize; // 每页数量

@property int recPageIndex; // 接收汇报列表页面，当前的页号

@property int recTotalPage; //接收汇报总页数

@property int sendPageIndex; // 发送汇报列表页面，当前的页号

@property int sendTotalPage; //发送汇报总页数

@property NSInteger selIndex;//tab分页索引 0:收件，1:发件

@property(nonatomic,strong) IBOutlet UIView *searchView;

@property(nonatomic,strong) IBOutlet UITextField *searchText;

@property(nonatomic,strong) IBOutlet UITableView *searchTable;

@property(nonatomic, strong) NSArray *searchArray;

/**
 *点击添加汇报按钮事件
 */
-(void)addReportBtnClick;

/**
 *加载更多的按钮
 */
-(UITableViewCell *) addMoreButton;


-(IBAction)closeSearchView:(id)sender;


@end
