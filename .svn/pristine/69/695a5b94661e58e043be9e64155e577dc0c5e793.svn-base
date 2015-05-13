//
//  SysViewController.m
//  Cancer
//
//  Created by Parsec on 14-11-5.
//  Copyright (c) 2014年 parsec. All rights reserved.
//

#import "SysViewController.h"

#import "UtilTool.h"
#import "SBJsonParser.h"
#import "Constants.h"

@implementation SysViewController{
    BOOL isLoadNewVersion;
    NSString *version;
}

@synthesize waitView;

-(void)viewDidLoad{
    
    self.navTitle=SYS_VC_TITLE;
    
    self.hideRightBut=YES;
    
    self.versionLabel.text=VERSION;
    
    [super viewDidLoad];
    [self loadData];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
}

-(void)loadData{
    NSMutableString *json=[NSMutableString stringWithFormat:@"{'packageName':'%@','version':'%@'}",VERSION_PKG,VERSION];
        
    waitView =[[UIWaitView alloc]init:self.view.frame];
    [self.view addSubview:waitView];
    [waitView.aiv startAnimating];
    [self performSelector:@selector(compareVersion:) withObject:json afterDelay:0.5];

}

//比较版本信息
-(void)compareVersion:(NSString *)json{
    NSMutableString *url=[NSMutableString stringWithFormat:@"%@%@",[UtilTool getHostURL],@"uploadApk/list2?"];
    [url appendFormat:@"json=%@",json];
    NSNumber *state;
    NSString *jsonStr=[UtilTool sendUrlRequestByCache:url paramValue:nil method:HTTPRequestMethodPost isReload:YES status:&state];
    
    SBJsonParser *parser=[[SBJsonParser alloc]init];
    NSDictionary *dic =[parser objectWithString:jsonStr];
    
    if([[dic objectForKey:@"status"]intValue]==500){
        [UtilTool ShowAlertView:ALERT_WARN_TITLE setMsg:[dic objectForKey:@"msg"]];
    }else{
        NSString *oldVersion=self.versionLabel.text;
        NSString *newVersion=[dic objectForKey:@"version"];
        if([oldVersion isEqualToString: newVersion]){
            isLoadNewVersion=false;
        }else{
            isLoadNewVersion=true;
            version=newVersion;
            newVersion =oldVersion;
        }
        NSString *newJson=[NSMutableString stringWithFormat:@"{'packageName':'%@','version':'%@'}",VERSION_PKG,newVersion];
        [self getVersion:newJson];
    }}

//得到版本信息并显示
-(void)getVersion:(NSString *)json{
    NSMutableString *url=[NSMutableString stringWithFormat:@"%@%@",[UtilTool getHostURL],@"uploadApk/info2?"];
    [url appendFormat:@"json=%@",json];
    NSNumber *state;
    json=[UtilTool sendUrlRequestByCache:url paramValue:nil method:HTTPRequestMethodPost isReload:YES status:&state];
    
    [waitView.aiv stopAnimating];
    [waitView removeFromSuperview];
    
    SBJsonParser *parser=[[SBJsonParser alloc]init];
    NSDictionary *dic =[parser objectWithString:json];

    if([dic[@"status"]intValue]==500){
        [UtilTool ShowAlertView:ALERT_WARN_TITLE setMsg:dic[@"msg"]];
    }else{
        self.versionLabel.text=dic[@"version"];
        if(![dic[@"remark"] isKindOfClass:[NSNull class]])
            [self.infoWebView loadHTMLString:dic[@"remark"] baseURL:nil];
        if(isLoadNewVersion)
            self.msgLabel.text=[NSMutableString stringWithFormat:@"最新版本%@，请下载更新...",version];
//            [UtilTool ShowAlertView:ALERT_WARN_TITLE setMsg:[NSMutableString stringWithFormat:@"最新版本%@，请下载更新...",version]];
        else
            self.msgLabel.text=@"当前已是最新版本！";
//            [UtilTool ShowAlertView:ALERT_WARN_TITLE setMsg:@"当前已是最新版本！"];
    }
}

@end
