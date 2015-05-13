//
//  LoginViewController.m
//  Cancer
//
//  Created by hu su on 14-10-15.
//  Copyright (c) 2014年 parsec. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>
#import "LoginViewController.h"
#import "UtilTool.h"
#import "SBJson.h"
#import "UIWaitView.h"
#import "MyMD5.h"

@interface LoginViewController ()

@end

@implementation LoginViewController {

}



@synthesize colorArray = _colorArray;

@synthesize txtMobile = _txtMobile;
@synthesize txtPwd = _txtPwd;
@synthesize loginBut = _loginBut;
@synthesize remenberView = _remenberView;
@synthesize checkBoxImageView = _checkBoxImageView;

@synthesize remenbered = _remenbered;

@synthesize curSelectedTabIndex = _curSelectedTabIndex;

@synthesize waitView = _waitView;

@synthesize pwd = _pwd;

@synthesize remenberPwdView = _remenberPwdView;

@synthesize checkBoxRemember = _checkBoxRemember;

@synthesize rememberPwd = _rememberPwd;

@synthesize userPwdDic = _userPwdDic;

- (void)viewDidLoad {
    [super viewDidLoad];

    self.remenbered = NO;
    self.rememberPwd = NO;

    self.colorArray = @[@"196798",@"16b7e5"];

//    self.tab1.backgroundColor = [UtilTool colorWithHexString:[self.colorArray objectAtIndex:0] ];
//    self.tab2.backgroundColor = [UtilTool colorWithHexString:[self.colorArray objectAtIndex:1]];
//    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTabView:)];
//
//    [self.tabView addGestureRecognizer:tapGestureRecognizer];
//
//
//    self.tabView.userInteractionEnabled = YES;



    UITapGestureRecognizer *checkTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCheckView:)];
    self.remenberView.userInteractionEnabled = YES;
    self.remenberView.tag = 1;

    [self.remenberView addGestureRecognizer:checkTap];


    UITapGestureRecognizer *checkTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCheckView:)];
    self.remenberPwdView.userInteractionEnabled = YES;
    self.remenberPwdView.tag=2;
    [self.remenberPwdView addGestureRecognizer:checkTap1];



    UITapGestureRecognizer *loginButTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loginButTap:)];
    self.loginBut.userInteractionEnabled = YES;
    [self.loginBut addGestureRecognizer:loginButTap];





    self.curSelectedTabIndex = 0;

}

- (void)viewDidAppear:(BOOL)animated {


    NSMutableDictionary *pwdInf =  [self getUserPwd];
    if(pwdInf){
        if(pwdInf[@"phone"] && [pwdInf[@"phone"] length]>0){
            self.txtPwd.text = pwdInf[@"pwd"];
            self.txtMobile.text = pwdInf[@"phone"];
            self.checkBoxRemember.image = [UIImage imageNamed:@"checkedbox.png"];
            self.rememberPwd = YES;
        }
    }




    NSMutableDictionary *userDic = [[UtilTool getUserDic] mutableCopy];
    if(userDic){
        if([userDic[@"remember"] boolValue]){
            NSDictionary *user = [userDic[@"user"] objectAtIndex:0];

//            NSString *phone= [user objectForKey:@"phone"];
//
//
//            self.txtMobile.text= phone;
            self.pwd =[user valueForKey:@"password"];
//            self.txtPwd.text = [user valueForKey:@"pwd"];



            self.checkBoxImageView.image = [UIImage imageNamed:@"checkedbox.png"];
            self.remenbered = YES;

            BOOL notAutoLogin= NO;
            if(userDic[@"notAuto"] != [NSNull null]){
                notAutoLogin = [userDic[@"notAuto"] boolValue];
            }

            if(notAutoLogin){

                userDic[@"notAuto"] = @(NO);
                [UtilTool saveUserDic:userDic];
                return;
            }





            self.waitView = [[UIWaitView alloc] init:self.view.frame];
            [self.waitView.aiv startAnimating];
            [self.view addSubview:self.waitView];





            [self performSelector:@selector(doLogin) withObject:nil afterDelay:0.5];
        }else{
            self.checkBoxImageView.image = [UIImage imageNamed:@"checkbox.png"];
            self.remenbered = NO;

        }
    }else{
        self.checkBoxImageView.image = [UIImage imageNamed:@"checkbox.png"];
        self.remenbered = NO;

    }
    [super viewDidAppear:YES];
}


/**
* 点击登录按钮
*/
-(void)loginButTap:(UITapGestureRecognizer *)tapGesture{
    [self.txtMobile resignFirstResponder];
    [self.txtPwd resignFirstResponder];



    self.waitView = [[UIWaitView alloc] init:self.view.frame];
    [self.waitView.aiv startAnimating];
    [self.view addSubview:self.waitView];


    if (!(self.txtMobile.text && [self.txtMobile.text length] > 0)) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"手机号码不可为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];

        [self.waitView stopAnimating];
        [self.waitView removeFromSuperview];

        return;
    }

    if (!(self.txtPwd.text && [self.txtPwd.text length] > 0)) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"密码不可为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];

        [self.waitView stopAnimating];
        [self.waitView removeFromSuperview];
        return;
    }


    NSString *pwdEncoding = [NSString stringWithFormat:@"%@{%@}",self.txtPwd.text,self.txtMobile.text];

    pwdEncoding = [[MyMD5 md5:pwdEncoding] uppercaseString];

    self.pwd = pwdEncoding;


    if(self.rememberPwd){

        [self savePwd: self.txtMobile.text password:self.txtPwd.text];
    }else{
        [self savePwd:@"" password:@""];
    }


    self.loginBut.alpha = 0.5f;
    [self performSelector:@selector(doLogin) withObject:nil afterDelay:0.2];
}

/**
* 执行自动登录
*/
-(void)doLogin{


    if(self.curSelectedTabIndex==0) { //处理本系统登录






        self.loginBut.alpha = 1.0f;

        NSString *mobile = self.txtMobile.text;


        NSString *url = [NSString stringWithFormat:@"%@manager/login?json={'account':'%@','password':'%@'}", [UtilTool getHostURL],mobile,self.pwd];



        NSNumber *status;
        NSString *userJSONString = [UtilTool sendUrlRequestByCache:url paramValue:nil method:HTTPRequestMethodGet isReload:YES status:&status];


        [self.waitView stopAnimating];
        [self.waitView removeFromSuperview];





        if(status.integerValue==2){

            if(userJSONString && [userJSONString length]>0){
                SBJsonParser *parser  = [[SBJsonParser alloc] init];
                NSMutableDictionary *userDic  = [parser objectWithString:userJSONString];

                if(!userDic || [[userDic objectForKey:@"status"] isEqual:@"1"]){
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"错误" message:@"登录名或密码错误,请重新登录" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alertView show];
                    return;
                }


                [userDic setObject:[NSNumber numberWithBool:self.remenbered] forKey:@"remember"];
                userDic[@"notAuto"] = @(NO);

                [UtilTool saveUserDic:userDic];


                [self performSegueWithIdentifier:@"login2Main" sender:self];

            }

        }else{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"错误" message:@"登录名或密码错误,请重新登录" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show];
            self.txtPwd.text=@"";
            return;
        }



    }else{ //处理ESOP登录

    }

}

/**
* 点击选项卡
*/

//-(void)tapTabView:(UITapGestureRecognizer *)gesture{
//    CGPoint point =  [gesture locationInView:self.tabView];
//    CGFloat totalWidth = self.tabView.frame.size.width;
//    int x = point.x/(totalWidth/2);
//
//
//        self.tab1.backgroundColor = [UtilTool colorWithHexString:[self.colorArray objectAtIndex:(x==0?0:1)]];
//        self.tab2.backgroundColor = [UtilTool colorWithHexString:[self.colorArray objectAtIndex:x==0?1:0]];
//
//    self.curSelectedTabIndex =  x;
//
//}

/**
* 点击是否记住密码checkbox
*/
-(void)tapCheckView:(UITapGestureRecognizer *)tapGestureRecognizer{


    if(tapGestureRecognizer.view.tag==1) {
        if (self.remenbered) {
            self.checkBoxImageView.image = [UIImage imageNamed:@"checkbox.png"];
            self.remenbered = NO;
        } else {
            self.checkBoxImageView.image = [UIImage imageNamed:@"checkedbox.png"];
            self.remenbered = YES;

            self.checkBoxRemember.image = [UIImage imageNamed:@"checkedbox.png"];
            self.rememberPwd = YES;
        }
    }else{
        if (self.rememberPwd) {
            self.checkBoxRemember.image = [UIImage imageNamed:@"checkbox.png"];
            self.rememberPwd = NO;

            self.checkBoxImageView.image = [UIImage imageNamed:@"checkbox.png"];
            self.remenbered = NO;


        } else {
            self.checkBoxRemember.image = [UIImage imageNamed:@"checkedbox.png"];
            self.rememberPwd = YES;
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

/**
* 保存用户名与密码
*/
-(void)savePwd:(NSString *)phone password:(NSString *)pwd{



    NSMutableDictionary *userInf = [[NSMutableDictionary alloc] init];
    [userInf setObject:phone forKey:@"phone"];
    [userInf setObject:pwd forKey:@"pwd"];

    NSArray *arr  = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [arr objectAtIndex:0];
    NSString *path = [documentPath stringByAppendingString:@"/UserPwd.plist"];

    [userInf writeToFile:path atomically:YES];

}

-(NSMutableDictionary *)getUserPwd{
    NSArray *arr  = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [arr objectAtIndex:0];
    NSString *path = [documentPath stringByAppendingString:@"/UserPwd.plist"];
    return  [NSMutableDictionary dictionaryWithContentsOfFile:path];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    [_txtMobile resignFirstResponder];
    [_txtPwd resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if(textField.returnKeyType==UIReturnKeyDone){
        [textField resignFirstResponder];
    }
    return NO;
}


@end
