//
//  InSideMsgViewController.h
//  Cancer
//
//  Created by hu su on 14/10/28.
//  Copyright (c) 2014年 parsec. All rights reserved.
//

#import "CommonViewController.h"
#import "CommonTableView.h"
#import "UIWaitView.h"

@interface InSideMsgViewController : CommonViewController<UITableViewDataSource,UITableViewDelegate,PullRefreshDelegate>{
     UIActivityIndicatorView *ai;
}

@property (nonatomic, strong) IBOutlet CommonTableView *tableView;

@property(nonatomic,strong)NSMutableArray *inSideMsgs;

@property UIWaitView *waitView;

@property long totalPages;
@property long curPage;
@property long pageSize;
@end
