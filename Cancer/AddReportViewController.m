//
//  AddReportViewController.m
//  Cancer
//
//  Created by zpj on 14/10/31.
//  Copyright (c) 2014年 parsec. All rights reserved.
//

#import "AddReportViewController.h"

@interface AddReportViewController ()

@end

@implementation AddReportViewController

@synthesize reportTitle;
@synthesize reportContent;
@synthesize recScrollView;
@synthesize ccScrollView;
@synthesize reportView;

@synthesize enterBtn;
@synthesize cancelBtn;
@synthesize waitView;

@synthesize topConstraint;
@synthesize isReciver;
@synthesize recArray;
@synthesize ccArray;
@synthesize contactsTitleName;
@synthesize enterBtnRightConstraint;
@synthesize reportContentHeightConstraint;

//float topValue;
bool isFirstAppear;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.hideRightBut=YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(enterClick:)];
    [enterBtn addGestureRecognizer:tap];

    tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelClick:)];
    [cancelBtn addGestureRecognizer:tap];

    tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(recBtnClick:)];
    [recScrollView addGestureRecognizer:tap];

    tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ccBtnClick:)];
    [ccScrollView addGestureRecognizer:tap];

    waitView = [[UIWaitView alloc]initWithFrame:self.view.frame];

    self.navTitle = @"新建汇报";

    tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeKeyboard)];
    [self.view addGestureRecognizer:tap];




}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

//    topValue = topConstraint.constant;
//    NSLog(@"%f==", reportContentBottomConstraint.constant);
//    reportContentBottomConstraint.constant = 180;

    enterBtnRightConstraint.constant = (self.view.frame.size.width)/3 + 10;
    topConstraint.constant =  10;

    isFirstAppear = YES;

    if (self.view.frame.size.height > 480.0f) {
        reportContentHeightConstraint.constant = self.view.frame.size.height / 480.0f  * 160.0f;
    }


//    NSLog(@"%F + %F ", reportContentHeightConstraint.constant, self.view.frame.size.height);

}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];



//    NSLog(@"%F", reportContentHeightConstraint.constant);

    [reportTitle becomeFirstResponder];

//     NSLog(@"%f==", reportContentBottomConstraint.constant);
//    NSLog(@"w:%f, h:%f, x:%f, y:%f" , self.view.frame.size.width, self.view.frame.size.height, self.view.frame.origin.x, self.view.frame.origin.y);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//导航栏左边按钮
-(void)clickBack:(UITapGestureRecognizer *)gesture
{
    [self.navigationController popViewControllerAnimated:YES];
}

//导航栏右边按钮
-(void)share:(UITapGestureRecognizer *)gesture
{

}

// textfeild reportTitle代理 点击next
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{

    [reportContent becomeFirstResponder];
    return NO;
}

//------------------
//textview 代理 关闭键盘
//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
//{
//
//    if ( [text isEqualToString:@"\n"] ) {
//        [textView resignFirstResponder];
//    }
//    return YES;
//}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    isFirstAppear = NO;
    topConstraint.constant = -125.0f;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [self closeKeyboard];
}
//------------------
-(void)closeKeyboard
{
    [reportTitle resignFirstResponder];
    [reportContent resignFirstResponder];

    topConstraint.constant =  10;

//    if ([[[UIDevice currentDevice]systemVersion] integerValue]<8 && !isFirstAppear) {
//        topConstraint.constant =  -80;
//    }

}

//------------------------ 各种事件 -------------

-(IBAction)enterClick:(id)sender
{
    if (reportTitle.text.length < 4) {
        [UtilTool ShowAlertView:nil setMsg:@"汇报标题不得少于4个字"];
        return;
    }
    if (reportContent.text.length < 10) {
        [UtilTool ShowAlertView:nil setMsg:@"汇报内容不得少于10个字"];
        return;

    }
    if (recArray == nil || recArray.count < 1) {
        [UtilTool ShowAlertView:nil setMsg:@"汇报至少要有一个收件人"];
        return;
    }
    [waitView.aiv startAnimating];
    [self.view addSubview:waitView];
    [self performSelector:@selector(addReport) withObject:NULL afterDelay:0.1];
}

-(IBAction)cancelClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
//添加收件人
-(IBAction)recBtnClick:(id)sender
{

    isReciver = YES;
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    if (recArray != nil) {
        for (int i = 0; i < recArray.count; i++) {
            NSMutableDictionary *d = [recArray objectAtIndex:i];
            NSNumber *n = [d objectForKey:@"id"];
            [params setObject:d forKey:n.stringValue];
        }
    }

    contactsTitleName = @"主送";
    [self performSegueWithIdentifier:@"showContacts" sender:params];
}

//添加抄送人
-(IBAction)ccBtnClick:(id)sender
{

    isReciver = NO;
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    if (ccArray != nil) {
        for (int i = 0; i < ccArray.count; i++) {
            NSMutableDictionary *d = [ccArray objectAtIndex:i];
            NSNumber *n = [d objectForKey:@"id"];
            [params setObject:d forKey:n.stringValue];
        }
    }

    contactsTitleName = @"抄送";
    [self performSegueWithIdentifier:@"showContacts" sender:params];
}

//更新联系人
-(void)updateContacts
{

    CGFloat fontSize = 12.0f;
    if(isPad){
        fontSize= 16.0f;
    }

    if (isReciver) {

        [recScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];



        if (recArray != nil) {

            float offset = 0;
            for (int i = 0; i < recArray.count; i++) {
                NSDictionary *tmp = [recArray objectAtIndex:i];
                UILabel *lab = [[UILabel alloc]init];
                lab.font = [UtilTool currentSystemFont:fontSize];

                NSString *name = nil;

                if (i != recArray.count - 1) {
                    name = [NSString stringWithFormat:@" %@,", [tmp objectForKey:@"name"]];
                }else{
                    name = [NSString stringWithFormat:@" %@", [tmp objectForKey:@"name"]];
                }
//                CGSize size = [name sizeWithFont:lab.font constrainedToSize:CGSizeMake(MAXFLOAT, recScrollView.frame.size.height)];

                NSDictionary *attribute = @{NSFontAttributeName: [UtilTool currentSystemFont:fontSize]};
                CGSize maxSize =CGSizeMake(MAXFLOAT, recScrollView.frame.size.height);
                CGSize size = [name boundingRectWithSize:maxSize options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;


                lab.frame = CGRectMake(offset, 0, size.width, recScrollView.frame.size.height);
                lab.text = name;
                lab.textColor = [UIColor blackColor];
                lab.textAlignment = NSTextAlignmentLeft;
                offset = offset + size.width;
                [recScrollView addSubview:lab];
            }

            recScrollView.contentSize = CGSizeMake(offset, recScrollView.frame.size.height);
        }

    }else{

        [ccScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];


        if (ccArray != nil) {

            float offset = 0;
            for (int i = 0; i < ccArray.count; i++) {

                NSDictionary *tmp = [ccArray objectAtIndex:i];
                UILabel *lab = [[UILabel alloc]init];
                lab.font = [UtilTool currentSystemFont:fontSize];

                NSString *name = nil;

                if (i != ccArray.count - 1) {
                    name = [NSString stringWithFormat:@" %@,", [tmp objectForKey:@"name"]];
                }else{
                    name = [NSString stringWithFormat:@" %@", [tmp objectForKey:@"name"]];
                }


                NSDictionary *attribute = @{NSFontAttributeName: [UtilTool currentSystemFont:fontSize]};
                CGSize maxSize =CGSizeMake(MAXFLOAT, ccScrollView.frame.size.height);
                CGSize size = [name boundingRectWithSize:maxSize options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;




                lab.frame = CGRectMake(offset, 0, size.width, ccScrollView.frame.size.height);
                lab.text = name;
                lab.textColor = [UIColor blackColor];
                lab.textAlignment = NSTextAlignmentLeft;
                offset = offset + size.width;
                [ccScrollView addSubview:lab];
            }
        }
    }
}

/**
*给ViewController传递参数
*/
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showContacts"]) {

        ContactsViewController *ctv = (ContactsViewController *)segue.destinationViewController;
        ctv.addReportViewController = self;
        ctv.titleName = contactsTitleName;
        ctv.selectDict = (NSMutableDictionary *)sender;
    }
}

//-------------------------------------------
//提交汇报
-(void)addReport
{
    NSDictionary *userDic = [UtilTool getUserDic];
    NSString *token = [userDic objectForKey:@"token"];
    NSDictionary *user = [[userDic objectForKey:@"user"] objectAtIndex:0];
    NSString *url=[[NSString alloc]initWithFormat:@"%@manager/jobReport/save2",[UtilTool getHostURL]];

    NSMutableString *param = [[NSMutableString alloc]init];
    [param appendFormat:@"json={"];
    [param appendFormat:@"\"token\":\"%@\" ,", token];
    [param appendFormat:@"\"userId\":%i ,", [[user objectForKey:@"id"] intValue] ];
    [param appendFormat:@"\"title\":\"%@\" ,", reportTitle.text];
    [param appendFormat:@"\"content\":\"%@\" ,", reportContent.text];


    NSMutableString *tmp = [[NSMutableString alloc]init];
    if (recArray != nil ) {
        for (int i = 0; i < recArray.count; i++) {
            NSDictionary *dict = [recArray objectAtIndex:i];
            NSNumber *n = [dict objectForKey:@"id"];
            [tmp appendString:n.stringValue];
            [tmp appendString:@","];
        }
    }
    NSLog(@"%@", [tmp substringToIndex:tmp.length - 1]);


    if (ccArray != nil ) {
        [param appendFormat:@"\"mainReceiver\":\"%@\" ,", [tmp substringToIndex:tmp.length - 1]];
        tmp = [[NSMutableString alloc]init];

        for (int i = 0; i < ccArray.count; i++) {
            NSDictionary *dict = [ccArray objectAtIndex:i];
            NSNumber *n = [dict objectForKey:@"id"];
            [tmp appendString:n.stringValue];
            [tmp appendString:@","];
        }
        NSLog(@"%@", [tmp substringToIndex:tmp.length - 1]);
        [param appendFormat:@"\"copyReceiver\":\"%@\" ", [tmp substringToIndex:tmp.length - 1]];
    }else{
        [param appendFormat:@"\"mainReceiver\":\"%@\" ,", [tmp substringToIndex:tmp.length - 1]];
        [param appendFormat:@"\"copyReceiver\":\"%@\" ", @""];
    }

    [param appendFormat:@"}"];


    NSNumber *num = nil;
    NSString *str = [UtilTool sendUrlRequestByCache:url paramValue:param method:HTTPRequestMethodPost isReload:YES status:&num];

    [waitView.aiv stopAnimating];
    [waitView removeFromSuperview];

    SBJsonParser *parser=[[SBJsonParser alloc]init];
    NSDictionary *jsonDict=[parser objectWithString:str];

    NSNumber *result = [jsonDict objectForKey:@"status"];
    if ([result intValue]== 200) {

        [UtilTool  ShowAlertView:nil setMsg:@"您的汇报已发送！"];
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        // 请求不成功后返回什么错误？统一api
        if([jsonDict valueForKey:@"msg"] != nil)
            [UtilTool ShowAlertView:nil setMsg:[jsonDict valueForKey:@"msg"]];
        else
            [UtilTool ShowAlertView:nil setMsg:@"系统繁忙,请稍后重试"];

    }

}


@end
