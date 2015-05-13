//
//  ContactsViewController.m
//  Cancer
//
//  Created by zpj on 14/11/5.
//  Copyright (c) 2014年 parsec. All rights reserved.
//

#import "ContactsViewController.h"

@interface ContactsViewController ()

@end

@implementation ContactsViewController

@synthesize contactsTable;
@synthesize enterBtn;
@synthesize cancelBtn;
@synthesize displayArray;
@synthesize btnCenterConstraint;
@synthesize waitView;
@synthesize selectDict;
@synthesize addReportViewController;
@synthesize titleName;
@synthesize titlelabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    titlelabel.text = titleName;
    
    waitView =[[UIWaitView alloc]initWithFrame:self.view.frame];
    displayArray = [[NSMutableArray alloc]init];
    // Do any additional setup after loading the view.
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cacelClick)];
    [cancelBtn addGestureRecognizer:tap];
    
    tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(enterClick)];
    [enterBtn addGestureRecognizer:tap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewDidAppear:(BOOL)animated
{
    btnCenterConstraint.constant = contactsTable.frame.size.width/3.0f*2.0f-10.0f;
    [waitView.aiv startAnimating];
    [self.view addSubview:waitView];
    [self performSelector:@selector(getConstactsList) withObject:NULL afterDelay:0.1];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//获取联系人列表
-(void)getConstactsList
{
    [displayArray removeAllObjects];
    NSDictionary *userDic = [UtilTool getUserDic];
    NSString *token = [userDic objectForKey:@"token"];
    NSDictionary *user = [[userDic objectForKey:@"user"] objectAtIndex:0];
    NSString *url=[[NSString alloc]initWithFormat:@"%@manager/jobReport/userList",[UtilTool getHostURL]];
    
    NSMutableString *param = [[NSMutableString alloc]init];
    [param appendFormat:@"json={"];
    [param appendFormat:@"\"token\":\"%@\" ,", token];
    [param appendFormat:@"\"userId\":%i", [[user objectForKey:@"id"] intValue] ];
    [param appendFormat:@"}"];
    
    
    NSNumber *num = nil;
    NSString *str = [UtilTool sendUrlRequestByCache:url paramValue:param method:HTTPRequestMethodPost isReload:YES status:&num];
    
    [waitView.aiv stopAnimating];
    [waitView removeFromSuperview];
    
    SBJsonParser *parser=[[SBJsonParser alloc]init];
    NSDictionary *jsonDict=[parser objectWithString:str];
    NSNumber *result = [jsonDict objectForKey:@"status"];
    if ([result intValue]== 200) {
        NSArray *array = [jsonDict objectForKey:@"list"];
        if (array != nil) {
            for (int i = 0; i < array.count; i++) {
                NSMutableDictionary *dict = [array objectAtIndex:i];
                NSNumber *nb = [dict objectForKey:@"id"];
                
                if ([selectDict objectForKey:nb.stringValue] == nil) {
                    [dict setObject:@"NO" forKey:@"select"];
                }else{
                    [dict setObject:@"YES" forKey:@"select"];
                }
                
                if ([[user objectForKey:@"id"] intValue] != nb.intValue) {
                    [displayArray addObject:dict];
                }
                
            }
        }
        [contactsTable reloadData];
    }else{
        // 请求不成功后返回什么错误？统一api
        if([jsonDict valueForKey:@"msg"] != nil)
            [UtilTool ShowAlertView:nil setMsg:[jsonDict valueForKey:@"msg"]];
        else
            [UtilTool ShowAlertView:nil setMsg:@"系统繁忙,请稍后重试"];
        
    }
    
}


-(void)cacelClick
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}

-(void)enterClick
{
    [self dismissViewControllerAnimated:YES completion:^{
        
        NSMutableArray *tmp = [[NSMutableArray alloc]init];
        if (displayArray != nil) {
            for (int i = 0; i < displayArray.count; i++) {
                NSDictionary *dict = [displayArray objectAtIndex:i];
                if ([@"YES" isEqualToString:[dict objectForKey:@"select"]]) {
                    [tmp addObject:dict];
                }
            }
        }
        
        if (addReportViewController.isReciver) {
            addReportViewController.recArray = tmp;
        }else{
            addReportViewController.ccArray = tmp;
        }
        
        [addReportViewController updateContacts];
    }];
}

//--------------------现实tableview 的各种代理-----------
/**
 * 列表分段中条目数
 **/
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (displayArray == nil) {
        return 0;
    }
    return displayArray.count;
}

/**
 * 列表中的条目视图
 **/
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    
    NSInteger row = [indexPath row];
    NSDictionary *dict = [displayArray objectAtIndex:row];
    
    cell.textLabel.text = [dict objectForKey:@"name"];
    cell.detailTextLabel.text = [dict objectForKey:@"position"];
    if ([@"YES" isEqualToString:[dict objectForKey:@"select"]])
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    return cell;
}

/**
 * 点击列表中的条目视图
 **/
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger row = [indexPath row];
    NSMutableDictionary *dict = [displayArray objectAtIndex:row];

    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([@"YES" isEqualToString:[dict objectForKey:@"select"]]) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        [dict setObject:@"NO" forKey:@"select"];
    }else{
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [dict setObject:@"YES" forKey:@"select"];
    }
}


@end
