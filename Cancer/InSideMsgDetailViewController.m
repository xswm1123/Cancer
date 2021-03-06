//
//  InSideMsgDetailViewController.m
//  Cancer
//
//  Created by Parsec on 14-10-31.
//  Copyright (c) 2014年 parsec. All rights reserved.
//

#import "InSideMsgDetailViewController.h"
#import "UIWaitView.h"

#import "UtilTool.h"
#import "SBJsonParser.h"

@interface InSideMsgDetailViewController ()

@end

@implementation InSideMsgDetailViewController

@synthesize titleLabel;

@synthesize timeLabel;

@synthesize instroTextView;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitle=self.msgTitle;
    self.hideRightBut=YES;
    
    self.waitView = [[UIWaitView alloc] init:self.view.frame];
    [self.waitView.aiv startAnimating];
    [self.view addSubview:self.waitView];
    [self performSelector:@selector(getMsg) withObject:nil afterDelay:0.5];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)getMsg{
    NSString *url=[NSString stringWithFormat:@"manager/message/details?json={'messageId':%ld,'token':'%@'}",self.messageId,[UtilTool getToken]];
    url = [NSMutableString stringWithFormat:@"%@%@",[UtilTool getHostURL],url];
    NSNumber *state;
    NSString *jsonString = [UtilTool sendUrlRequestByCache:url paramValue:nil method:HTTPRequestMethodGet isReload:YES status:&state];


    
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    if(jsonString && [jsonString length]>0){
        NSDictionary *dic = [parser objectWithString:jsonString];
        dic=[dic objectForKey:@"message"];
        self.titleLabel.text=[dic objectForKey:@"title"];
        NSString *date=[dic objectForKey:@"createDate"];
        self.timeLabel.text=[date substringWithRange:NSMakeRange(0, 10)];
        NSAttributedString * content = [[NSAttributedString alloc] initWithData:[[dic objectForKey:@"content"] dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
        self.instroTextView.attributedText=content;



        NSMutableDictionary *allReadMsgDic =  [UtilTool getMsgReadStatus]; //所有用户是否阅读信息的字典
        NSMutableDictionary *userDic =[[UtilTool getUserDic] mutableCopy];

        NSDictionary *user = [userDic[@"user"] objectAtIndex:0];


        NSMutableDictionary *userReadStatusDic= nil;  //保存某个用户是否阅读信息状态的字典
        if(!allReadMsgDic){
            allReadMsgDic = [[NSMutableDictionary alloc] init];
            userReadStatusDic = [[NSMutableDictionary alloc] init];

        }else{
            if( allReadMsgDic[[NSString stringWithFormat:@"k%ld",(long)[user[@"id"] integerValue] ]]!= [NSNull null]) {
                userReadStatusDic = allReadMsgDic[[NSString stringWithFormat:@"k%ld", (long)[user[@"id"] integerValue]]];
            }

            if(!userReadStatusDic){
                userReadStatusDic = [[NSMutableDictionary alloc] init];
            }

        }

        userReadStatusDic[[NSString stringWithFormat:@"k%ld",(long)[dic[@"id"] integerValue]]] = @(YES); //将某个用户的阅读状态保存到Dic
        allReadMsgDic[[NSString stringWithFormat:@"k%ld",(long)[user[@"id"] integerValue] ]] = userReadStatusDic; //保存所有的阅读信息

        [UtilTool saveMsgReadStatus:allReadMsgDic];

    }





    
    [_waitView.aiv stopAnimating];
    [_waitView removeFromSuperview];
}



-(void)clickBack:(UITapGestureRecognizer *)gesture{
    [self.navigationController popViewControllerAnimated:YES];
}

@end