//
//  KnowledgeViewController.h
//  Cancer
//
//  Created by hu su on 14/10/31.
//  Copyright (c) 2014年 parsec. All rights reserved.
//

#import "CommonViewController.h"

@class UIWaitView;
@class Stack;

@interface KnowledgeViewController : CommonViewController<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,NSURLConnectionDataDelegate>{

    NSString *curIndexListUrl;
    NSURLConnection *_connection;
    NSString *_attachUrl;
    NSMutableData *_receiveData;
    double _receivedLength;

    UILabel *_downloadLabel;
    double _fileLength;

    BOOL _downloading;

    Stack *_folderNameStack;

}

@property (nonatomic, strong) IBOutlet UITableView *myTableView;
@property (nonatomic, strong) NSMutableArray *folderArray;


@property (nonatomic, strong) UIWaitView *waitView;
@property NSInteger pageNo;
@property NSInteger totalPage;
@property NSUInteger  curParentNo;
@property (nonatomic, strong) Stack * preParentStack;
@property (nonatomic, assign)NSInteger pageSize;

@end
