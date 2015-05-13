//
//  FirstViewController.h
//  Cancer
//
//  Created by hu su on 14/10/21.
//  Copyright (c) 2014年 parsec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonViewController.h"
#import "PagePhotosDataSource.h"

@class UIWaitView;
@class PagePhotosView;
@class BubbleView;

@interface FirstViewController : CommonViewController<UITableViewDataSource,UITableViewDelegate,PagePhotosDataSource,UIAlertViewDelegate,NSURLConnectionDataDelegate>{
    NSString *curIndexListUrl;
    NSString *curAdUrl;
    NSArray *colorArry;
    NSArray *imageArray;
    NSTimer *curTimer;
    NSInteger curWorkReportNum;

    UIView *workReportView;

    NSInteger curMsgIndex;

    UIImageView *workReportImageView;

    NSString * _downloadUrl;
    BOOL _downloading;

    NSURLConnection *_connection;

    NSMutableData * _receiveData;

    double  _fileLength;
    double _receivedLength;

    UILabel *_downloadLabel;

}
@property (nonatomic, strong) IBOutlet UITableView *myTable;
@property (nonatomic, strong) IBOutlet UIView *msgNoticeView;
@property (nonatomic, strong) IBOutlet UILabel *movingMsgLabel;

@property (nonatomic, strong) NSMutableDictionary *firstPageDataDic;

@property (nonatomic, strong) NSArray *adArray;
@property (nonatomic, strong) UIWaitView *waitView;
@property (nonatomic, strong) PagePhotosView *advertiseView;


@property (nonatomic, strong) NSMutableArray *msgArray;

@property (nonatomic, strong) BubbleView *bubbleView;



@end