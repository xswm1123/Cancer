//
//  ViewController.m
//  Cancer
//
//  Created by hu su on 14-10-13.
//  Copyright (c) 2014年 parsec. All rights reserved.
//

#import "ViewController.h"
#import "UtilTool.h"
#import "SBJsonParser.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize logoImage=_logoImage;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    curPage = 1;
    showTimes=0;
   
    
    self.logoImage.animationImages =@[[UIImage imageNamed:@"firstPageLogo1.png"],[UIImage imageNamed:@"firstPageLogo2.png"],[UIImage imageNamed:@"firstPageLogo3.png"]];
    
    [UIView setAnimationDelegate:self];
    self.logoImage.animationDuration = 0.25f;
    self.logoImage.animationRepeatCount = 9;
    [self.logoImage startAnimating];
    [self performSelector:@selector(goRootNav) withObject:nil afterDelay:3.0];
    
    
    
//    curTimer = [NSTimer scheduledTimerWithTimeInterval:0.10 target:self selector:@selector(playAnimate) userInfo:nil repeats:YES];
    
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)saveFirstLaunch{
    NSUUID *curUUID =  [[UIDevice currentDevice] identifierForVendor];
    NSString *uuid = curUUID.UUIDString;


    NSString *url = [NSString stringWithFormat:@"%@installRecord/save",[UtilTool getHostURL]];

    NSString *para = nil;

    if(isPad){
        para= [NSString stringWithFormat:@"json={'phone_number':'','app_type':'内部版','device_type':'iPad','device_code':'%@'}",uuid];
    }else{
        para =  [NSString stringWithFormat:@"json={'phone_number':'','app_type':'内部版','device_type':'iPhone','device_code':'%@'}",uuid];
    }

    NSNumber *err;
    NSString *jsonString = [UtilTool sendUrlRequestByCache:url paramValue:para method:HTTPRequestMethodPost isReload:YES status:&err];

    SBJsonParser *parser = [[SBJsonParser alloc] init];
    if(jsonString && [jsonString length]>0){
        NSDictionary *dic = [parser objectWithString:jsonString];
        if(dic && [dic[@"status"] integerValue]==200){
            [UtilTool saveDeviceToken:uuid];
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)goRootNav{

    [self performSegueWithIdentifier:@"login" sender:nil];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];

    NSDictionary *dic = [UtilTool getDeviceToken];
    if(!(dic && dic[@"token"] && [dic[@"token"] length]>0)){ //没有uuid

        [self performSelector:@selector(saveFirstLaunch) withObject:nil afterDelay:0.3];

    }
}


@end
