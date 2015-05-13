//
//  CheckVIewController.h
//  Cancer
//  考情接口类
//  Created by hu su on 14/10/27.
//  Copyright (c) 2014年 parsec. All rights reserved.
//

#import "CommonViewController.h"

#import "UIWaitView.h"

@interface CheckVIewController : CommonViewController<UITableViewDataSource,UITableViewDelegate>{
    UIActivityIndicatorView *ai;
}

@property(nonatomic,strong)IBOutlet UITableView *attendanceTableView;

//考勤数据
@property(nonatomic,strong)NSMutableArray *attences;

@property UIWaitView *waitView;

@property long totalPages;
@property long curPage;
@property long pageSize;

@end
