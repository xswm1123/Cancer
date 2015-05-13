//
//  WorkReportListViewController.m
//  Cancer
//
//  Created by hu su on 14/10/21.
//  Copyright (c) 2014年 parsec. All rights reserved.
//

#import "WorkReportListViewController.h"
#import "UtilTool.h"
#import "WorkReportTableCell.h"
#import "WorkReportDetailViewController.h"
#import "AppDelegate.h"

@interface WorkReportListViewController ()

@end

@implementation WorkReportListViewController

@synthesize tabSelectView;
@synthesize tabSelectName;
@synthesize receiveReportArray;
@synthesize sendReportArray;
@synthesize waitView;
@synthesize addReportBtn;
@synthesize table;
@synthesize selIndex;
@synthesize displayArray;
@synthesize recPageIndex;
@synthesize recTotalPage;
@synthesize sendPageIndex;
@synthesize sendTotalPage;
@synthesize pageSize;

@synthesize searchTable;
@synthesize searchText;
@synthesize searchView;
@synthesize searchArray;

@synthesize isSearch;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    isSearch = NO;
    
    self.tabSelectName = @[@"收到的汇报",@"发送的汇报"];
    self.tabSelectView.customDelegate = self;
    
    
    table.customDelegate = self;
    
    // Do any additional setup after loading the view.
    
    table.backgroundColor = [UIColor clearColor];
    
    searchView.alpha = 0.0f;
    
    pageSize = 10;
    sendPageIndex = 1;
    recPageIndex = 1;
    
    displayArray = [[NSMutableArray alloc]init];
    receiveReportArray  = [[NSMutableArray alloc]init];
    sendReportArray = [[NSMutableArray alloc]init];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addReportBtnClick)];
    [addReportBtn addGestureRecognizer:tap];
    
    waitView = [[UIWaitView alloc]initWithFrame:self.view.frame];
    selIndex = 0;
    
    self.navTitle = @"汇报列表";
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [waitView.aiv startAnimating];
    [self.view addSubview:waitView];
    
    [self performSelector:@selector(getDataList:) withObject:[NSNumber numberWithInt:0] afterDelay:0.1];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//---- tab 组件代理
- (void)selectTab:(NSInteger)selectIndex selectView:(UIScrollView *)selectView {
    
    selIndex  = selectIndex;
    [displayArray removeAllObjects];
    
    if (selIndex == 0) {
        
        if (receiveReportArray.count < 1) {
            
            [waitView.aiv startAnimating];
            [self.view addSubview:waitView];
            [self performSelector:@selector(getDataList:) withObject:[NSNumber numberWithInt:0] afterDelay:0.1];
            
        }else{
            [displayArray addObjectsFromArray:receiveReportArray];
            [table reloadData];
        }
        
        
   
    }
    if (selIndex == 1) {

        if (sendReportArray.count < 1) {
            [waitView.aiv startAnimating];
            [self.view addSubview:waitView];
            [self performSelector:@selector(getDataList:) withObject:[NSNumber numberWithInt:0] afterDelay:0.1];
        }else{
            [displayArray addObjectsFromArray:sendReportArray];
            [table reloadData];
        }
        
    }
    
    

}

- (NSString *)getLabelName:(NSInteger)index SelectView:(UIScrollView *)selectView {
    return [self.tabSelectName objectAtIndex:index];
}

- (NSInteger)getLabelCount:(UIScrollView *)selectView {
    return [self.tabSelectName count];
}
//--------
-(void)getDataList:(NSNumber *) paramPageIndex
{
    
    
    NSDictionary *userDic = [UtilTool getUserDic];
    NSString *token = [userDic objectForKey:@"token"];
    NSDictionary *user = [[userDic objectForKey:@"user"] objectAtIndex:0];
    NSString *url=[[NSString alloc]initWithFormat:@"%@manager/jobReport/list",[UtilTool getHostURL]];
    
    NSMutableString *param = [[NSMutableString alloc]init];
    [param appendFormat:@"json={"];
    [param appendFormat:@"\"token\":\"%@\" ,", token];
    [param appendFormat:@"\"userId\":%i ,", [[user objectForKey:@"id"] intValue] ];
    [param appendFormat:@"\"type\":%ld ,", (long)selIndex];
    [param appendFormat:@"\"pageSize\":%i ,", pageSize];
    
    if (isSearch) {
        [param appendFormat:@"\"content\":\"%@\" ,", searchText.text];
    }else{
        [param appendFormat:@"\"content\":\"%@\" ,", @""];
    }
    
    
    if (selIndex == 1) {
        [param appendFormat:@"\"pageIndex\":%i ", sendPageIndex + [paramPageIndex intValue]];
    }
    if (selIndex == 0) {
        [param appendFormat:@"\"pageIndex\":%i ", recPageIndex + [paramPageIndex intValue]];
    }
    
    
    [param appendFormat:@"}"];
    
    
    
    NSNumber *num = nil;
    NSString *str = [UtilTool sendUrlRequestByCache:url paramValue:param method:HTTPRequestMethodPost isReload:YES status:&num];
    
    [waitView.aiv stopAnimating];
    [waitView removeFromSuperview];
    
//    NSLog(@"%@", str);
    
//    NSLog(@"%@",str);
//    str = @"{\"status\":200,\"msg\":\"\",\"totalPage\":1,\"list\":[{\"id\":-6,\"userId\":-3,\"userName\":\"李小龙\",\"readMark\":1,\"organizeName\":\"绵阳分公司\",\"title\":\"标题6\",\"content\":\"内容16\",\"createDate\":1389856350000,\"showCreateDate\":\"2014-01-16 15:12:30\",\"mainReceivers\":[{\"id\":3,\"name\":\"李小龙\",\"position\":\"功夫巨星\",\"phone\":\"13800138002\",\"crashPhone\":\"13800138007\",\"status\":\"E\",\"createDate\":1388505600000,\"createUser\":\"18782182518\",\"password\":\"123456\"}],\"attachedReceivers\":[{\"id\":3,\"name\":\"李小龙\",\"position\":\"功夫巨星\",\"phone\":\"13800138002\",\"crashPhone\":\"13800138007\",\"status\":\"E\",\"createDate\":1388505600000,\"createUser\":\"18782182518\",\"password\":\"123456\"}]}]}";

    
    SBJsonParser *parser=[[SBJsonParser alloc]init];
    NSDictionary *jsonDict=[parser objectWithString:str];
    
    NSNumber *result = [jsonDict objectForKey:@"status"];
    if ([result intValue]== 200) {
        
        NSArray *retlist = [jsonDict objectForKey:@"list"];
        
        if (isSearch) {
            searchArray = retlist;
            [searchTable reloadData];
        }else{
            
            [displayArray removeAllObjects];
            
            if (selIndex == 1) {//发件
                
                sendTotalPage = [[jsonDict objectForKey:@"totalPage"] intValue];
                
                //判断是否是加载更多
                if ([paramPageIndex intValue] == 1) {
                    sendPageIndex ++;
                }else{
                    sendPageIndex = 1;
                    [sendReportArray removeAllObjects];
                }
                [sendReportArray addObjectsFromArray:retlist];
                
                [displayArray addObjectsFromArray:sendReportArray];
            }
            
            if (selIndex == 0) {//收件
                
                recTotalPage = [[jsonDict objectForKey:@"totalPage"] intValue];
                
                if ([paramPageIndex intValue] == 1) {
                    recPageIndex ++;
                }else{
                    recPageIndex = 1;
                    [receiveReportArray removeAllObjects];
                }
                [receiveReportArray addObjectsFromArray:retlist];
                
                [displayArray addObjectsFromArray:receiveReportArray];
            }

            
            [table reloadData];
        }
        
        
    }else{
        // 请求不成功后返回什么错误？统一api
        if([jsonDict valueForKey:@"msg"] != nil)
            [UtilTool ShowAlertView:nil setMsg:[jsonDict valueForKey:@"msg"]];
        else
            [UtilTool ShowAlertView:nil setMsg:@"系统繁忙,请稍后重试"];
        
    }

}


//导航栏左边按钮
-(void)clickBack:(UITapGestureRecognizer *)gesture
{
    [self.navigationController popViewControllerAnimated:YES];
}

//导航栏右边按钮
-(void)share:(UITapGestureRecognizer *)gesture
{
 
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    searchView.alpha = 1.0f;
    [UIView commitAnimations];

    [searchText becomeFirstResponder];
    
}

//--------------------现实tableview 的各种代理-----------
/**
 * 每个单元格的高度
 **/
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90.0f;
}

/**
 * 列表分段中条目数
 **/
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 10)
    {
        if (searchArray == nil)
        {
            return 0;
        }else{
            return searchArray.count;
        }
    }
    if (tableView.tag == 20)
    {
        if (selIndex == 0 && recPageIndex < recTotalPage) {
            return ([displayArray count] + 1);
        }
        if (selIndex == 1 && sendPageIndex < sendTotalPage) {
            return ([displayArray count] + 1);
        }
        return [displayArray count];
    }
    return 0;
}

/**
 * 列表中的条目视图
 **/
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    

    
    static NSString *UITableViewCellIdentifier = @"UITableViewCell";
    WorkReportTableCell *cell =  [tableView dequeueReusableCellWithIdentifier:UITableViewCellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"WorkReportTableCell" owner:self options:nil] lastObject];
    }
    
    NSInteger row = [indexPath row];
    NSMutableDictionary *dict = nil;
    if (tableView.tag == 10)//搜索的tableview
    {
        dict = [searchArray objectAtIndex:row];
        
    }
    if (tableView.tag == 20)//收发件的tableview
    {
        if (row == displayArray.count )
        {
            return  [self addMoreButton];
        }
        dict = [displayArray objectAtIndex:row];
        if (selIndex == 1) {//发件
            [dict setObject:[NSNumber numberWithInt:1] forKey:@"readMark"];
        }
    }
    
    [cell displayData:dict];
    //设置cell点击后无背景颜色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;

}

/**
 * 点击列表中的条目视图
 **/
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger row = [indexPath row];
    if (tableView.tag == 10)//搜索的tableview
    {
        NSDictionary *dict = [searchArray objectAtIndex:row];
        [self performSegueWithIdentifier:@"showWorkReportDetail" sender:dict];
    }
    if (tableView.tag == 20)//收发件的tableview
    {
        if (row < displayArray.count) {
            
            NSDictionary *dict = [displayArray objectAtIndex:row];
            [self performSegueWithIdentifier:@"showWorkReportDetail" sender:dict];
            
            
        }else{
            [self performSelector:@selector(clickMoreBtn) withObject:nil afterDelay:0.1];
        }

    }
    
    
    
    
}
/**
 *给ViewController传递参数
 */
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showWorkReportDetail"]) {
        WorkReportDetailViewController *detial = (WorkReportDetailViewController *)segue.destinationViewController;
        detial.dict = (NSDictionary *)sender;
    }
}

//-------------------------
//生成更多按钮
-(UITableViewCell *) addMoreButton
{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.frame = CGRectMake(0, 0, table.frame.size.width, 70);
    UILabel *moreBtn = [[UILabel alloc]initWithFrame:cell.frame];
//    NSLog(@"x=%f, y=%f, w=%f, h=%f", moreBtn.frame.origin.x, moreBtn.frame.origin.y, moreBtn.frame.size.width, moreBtn.frame.size.height);
    moreBtn.text = @"加载更多";
    moreBtn.textColor = [UIColor grayColor];
    moreBtn.textAlignment = NSTextAlignmentCenter;
    
//    cell.userInteractionEnabled = YES;
    
//    UITapGestureRecognizer *gest = [[UITapGestureRecognizer alloc]initWithTarget:self action:];
    [cell.contentView addSubview:moreBtn];
//    [moreBtn addGestureRecognizer:gest];

    return cell;
}
//点击更多按钮执行函数
-(void)clickMoreBtn
{
    [waitView.aiv startAnimating];
    [self.view addSubview:waitView];
    [self performSelector:@selector(getDataList:) withObject:[NSNumber numberWithInt:1] afterDelay:0.1];
    
}


//点击新建汇报按钮
-(void)addReportBtnClick
{
    [self performSegueWithIdentifier:@"showAddReoport" sender:nil];
}

//----------下拉刷新和更多加载----------
-(void)refreshTableView:(id)sender
{
    [waitView.aiv startAnimating];
    [self.view addSubview:waitView];
    
    if (selIndex == 1) {
        sendPageIndex = 1;
        [self performSelector:@selector(getDataList:) withObject:[NSNumber numberWithInt:0] afterDelay:0.1];
    }
    if (selIndex == 0) {
        recPageIndex = 1;
        [self performSelector:@selector(getDataList:) withObject:[NSNumber numberWithInt:0] afterDelay:0.1];
    }
    
    [self.table refreshSuccessed];

}
-(void)gotoNextPage:(id)sender
{
    
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [table scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [table scrollViewWillBeginDragging:scrollView];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [table scrollViewDidScroll:scrollView];
}
//-----------------------------------

//关闭搜索框
-(IBAction)closeSearchView:(id)sender
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    searchView.alpha = 0.0f;
    [UIView commitAnimations];
    
    [searchText resignFirstResponder];
    searchText.text = @"";
    searchArray = nil;
    [searchTable reloadData];
    isSearch = NO;
}

//-------------------------------------------------

/**
 * 点击文本输入法里的搜索按钮
 **/
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    isSearch = YES;
    if ([textField returnKeyType] == UIReturnKeySearch) {
        
        if (searchText.text.length < 1) {
            [UtilTool ShowAlertView:nil setMsg:@"输入不能为空"];
            return YES;
        }
        
        [waitView.aiv startAnimating];
        [self.view addSubview:waitView];
        [self performSelector:@selector(getDataList:) withObject:[NSNumber numberWithInt:0] afterDelay:0.1];
        
        [textField resignFirstResponder];
    }
    
    
    return YES;
}

-(BOOL)textFieldShouldClear:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
@end
