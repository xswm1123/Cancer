//
//  PwdController.m
//  Cancer
//
//  Created by Parsec on 14-11-4.
//  Copyright (c) 2014年 parsec. All rights reserved.
//

#import "PwdController.h"

#import "UtilTool.h"
#import "Constants.h"
#import "SBJsonParser.h"
#import "MyMD5.h"

@implementation PwdController{
    NSArray *errorMsg;
    NSDictionary *user;
}

@synthesize phoneLabel;

@synthesize oldPwdText;

@synthesize nPwdText;

@synthesize n2PwdText;

@synthesize waitView;

-(void)viewDidLoad{
    
    self.navTitle=PWD_VC_TITLE;
    self.hideRightBut=YES;
    
    NSDictionary *userDic = [UtilTool getUserDic];
    user = [[userDic objectForKey:@"user"] objectAtIndex:0];
    self.phoneLabel.text=[user objectForKey:@"phone"];
    
    [self.oldPwdText becomeFirstResponder];
    
    errorMsg=@[@"原密码不能为空",
               @"请输入8到16位含字母与数字的新密码且以字母开头",
               @"请输入8到16位含字母与数字的确认密码且以字母开头",
               @"两次新密码不相同"];
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
}

-(void)updatePwd:(id)sender{
    NSString *oldPwd=[self.oldPwdText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *newPwd=[self.nPwdText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *new2Pwd=[self.n2PwdText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    NSString *msg=@"";
    if(oldPwd.length==0)
        msg=[errorMsg objectAtIndex:0];
    else if(newPwd.length<8||![self validatePwd:newPwd])
        msg=[errorMsg objectAtIndex:1];
    else if(new2Pwd.length<8||![self validatePwd:new2Pwd])
        msg=[errorMsg objectAtIndex:2];
    else if(![newPwd isEqualToString:new2Pwd])
        msg=[errorMsg objectAtIndex:3];
    if(msg.length!=0){
        [UtilTool ShowAlertView:ALERT_WARN_TITLE setMsg:msg];
        return ;
    }
    
    NSString *account= [user objectForKey:@"phone"];
    
    oldPwd =[[MyMD5 md5:[NSString stringWithFormat:@"%@{%@}",oldPwd,account]] uppercaseString];
    
    NSMutableString *json=[NSMutableString stringWithFormat:@"{'account':'%@','password':'%@','newPassword':'%@','token':'%@'}",account,oldPwd,newPwd,[UtilTool getToken]];
    
    waitView =[[UIWaitView alloc]init:self.view.frame];
    [self.view addSubview:waitView];
    [waitView.aiv startAnimating];
    [self performSelector:@selector(savePwd:) withObject:json afterDelay:0.5];
}
//提交修改密码
-(void)savePwd:(NSString *)json{
    NSMutableString *url=[NSMutableString stringWithFormat:@"%@%@",[UtilTool getHostURL],@"manager/login/update?"];
    [url appendFormat:@"json=%@",json];
    NSNumber *state;
    json=[UtilTool sendUrlRequestByCache:url paramValue:nil method:HTTPRequestMethodPost isReload:YES status:&state];
    
    SBJsonParser *parser=[[SBJsonParser alloc]init];
    NSDictionary *dic =[parser objectWithString:json];
    
    if([[dic objectForKey:@"status"]intValue]==500){
        [UtilTool ShowAlertView:ALERT_WARN_TITLE setMsg:[dic objectForKey:@"reason"]];
    }else{
        [UtilTool ShowAlertView:ALERT_WARN_TITLE setMsg:ALERT_SAVE_SUCCESSMSG];
    }
    [waitView.aiv stopAnimating];
    [waitView removeFromSuperview];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if(textField==oldPwdText)
        [nPwdText becomeFirstResponder];
    else if(textField==nPwdText)
        [n2PwdText becomeFirstResponder];
    else{
        [n2PwdText resignFirstResponder];
    }
    return YES;
}

//验证密码是否由数字和字母组成且以字母开头
-(BOOL)validatePwd:(NSString *)pwd{
    NSString *regex = @"(^[A-Za-z0-9]{8,16}$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL b=[predicate evaluateWithObject:pwd];
    
    unichar c=[pwd characterAtIndex:0];
    if((c<'A'||c>'Z')&&(c<'a'||c>'z'))
        b=NO;
    
    return b;
}

@end
