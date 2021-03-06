//
//  KnowledgeDetailViewController.h
//  Cancer
//
//  Created by hu su on 14/11/1.
//  Copyright (c) 2014年 parsec. All rights reserved.
//

#import "CommonViewController.h"

@class CustomUILabel;
@class UIWaitView;

@interface KnowledgeDetailViewController : CommonViewController<NSURLConnectionDataDelegate,UIAlertViewDelegate>{
    NSString *curIndexListUrl;
}
@property  NSInteger kid;

@property (nonatomic, strong) IBOutlet UIImageView *iconImageView;
@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UILabel *timeLabel;
@property (nonatomic, strong) IBOutlet UIView *readOnlineView;
@property (nonatomic, strong) IBOutlet UIView *downloadView;
@property (nonatomic, strong) IBOutlet UILabel *downloadLabel;
@property (nonatomic, strong) IBOutlet CustomUILabel *descriptionLabel;
@property (nonatomic, strong) NSMutableDictionary *knowledgeDic;

@property (nonatomic, strong) UIWaitView *waitView;
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, strong) IBOutlet UIWebView *contentWebView;
@property (nonatomic, strong) NSMutableData *receiveData;
@property (nonatomic, assign) double fileLength;
@property (nonatomic, assign) double receivedLength;
@property (nonatomic, strong) NSURLConnection *connection;

@end
