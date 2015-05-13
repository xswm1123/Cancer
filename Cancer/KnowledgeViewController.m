//
//  KnowledgeViewController.m
//  Cancer
//
//  Created by hu su on 14/10/31.
//  Copyright (c) 2014年 parsec. All rights reserved.
//

#import "KnowledgeViewController.h"
#import "KnowledgeFolderCell.h"
#import "UIWaitView.h"
#import "SBJsonParser.h"
#import "UtilTool.h"
#import "Stack.h"
#import "ReadAttachOnLineViewController.h"

@implementation KnowledgeViewController

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@synthesize myTableView = _myTableView;
@synthesize folderArray = _folderArray;


@synthesize waitView = _waitView;

@synthesize pageNo = _pageNo;

@synthesize totalPage = _totalPage;

@synthesize curParentNo = _curParentNo;


@synthesize preParentStack = _preParentStack;


@synthesize pageSize = _pageSize;

- (void)viewDidLoad {

    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    self.hideRightBut = YES;

    self.pageNo = 1;

    self.preParentStack = [[Stack alloc] init];


    _folderNameStack = [[Stack alloc] init];

    self.navTitle = @"业务知识";

    _curParentNo = 0;

    _pageSize = 10;


    _downloading = NO;

    self.waitView = [[UIWaitView alloc] init:self.view.frame];


    [self.waitView.aiv startAnimating];
    [self.view addSubview:self.waitView];


    NSNumber *parentNum = @(self.curParentNo);
    [self performSelector:@selector(initData:) withObject:parentNum afterDelay:0.5];


    [super viewDidLoad];



}



- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];


}

-(void)initData:(NSNumber *) parentId{
    NSDictionary *userDic = [UtilTool getUserDic];
    NSString *token = userDic[@"token"];

    //读取首页数据

    _curParentNo= (NSUInteger) [parentId integerValue];


    NSMutableString *url = [NSMutableString stringWithFormat:@"%@manager/professionKnowledge/list?json={'token':'%@','parentId':%ld,'pageIndex':%ld,'pageSize':%ld}", [UtilTool getHostURL], token, (long)parentId.integerValue, (long)self.pageNo,(long)_pageSize];
    NSNumber *status;
    NSString *jsonString = [UtilTool sendUrlRequestByCache:url paramValue:nil method:HTTPRequestMethodGet isReload:NO status:&status];

    SBJsonParser *parser = [[SBJsonParser alloc] init];
    if(jsonString && [jsonString length]>0){
        NSDictionary *curDic = [parser objectWithString:jsonString];
        if(curDic){
            self.folderArray = curDic[@"list"];
            self.totalPage = [curDic[@"totalPage"] integerValue];
        }
    }

    //如果是从缓存中读取的，则后台启动一个线程读取网络数据

    if([status intValue]==3){
        curIndexListUrl = url;
        [NSThread detachNewThreadSelector:@selector(visitIndexUrlBackground) toTarget:self withObject:nil];
    }


//    for(NSMutableDictionary *testDic in self.folderArray){
//        testDic[@"attachmentUrl"] =  @"http://www.parsec.com.cn/pc-Europa-2.doc?xxfee=343";
//
//    }


    [self reloadTableView];

    [self.waitView stopAnimating];
    [self.waitView removeFromSuperview];
}

-(void)visitIndexUrlBackground{
    NSNumber *status;
    NSString *jsonString = [UtilTool sendUrlRequestByCache:curIndexListUrl paramValue:nil method:HTTPRequestMethodGet isReload:YES status:&status];


    //如果是从缓存中读取的，则后台启动一个线程读取网络数据

    if([status intValue]==2){
        SBJsonParser *parser = [[SBJsonParser alloc] init];
        if(jsonString && [jsonString length]>0){
            NSDictionary *curDic = [parser objectWithString:jsonString];
            if(curDic){
                self.folderArray = curDic[@"list"];
                self.totalPage = [curDic[@"totalPage"] integerValue];
            }
        }


        //测试数据
//        for(NSMutableDictionary *testDic in self.folderArray){
//            testDic[@"attachmentUrl"] =  @"http://www.parsec.com.cn/pc-Europa-2.doc";
//
//        }

        [NSThread detachNewThreadSelector:@selector(reloadTableView) toTarget:self withObject:nil];
    }
}

-(void)reloadTableView{
    [self.myTableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {


    NSInteger rowNum = [self.folderArray count];

    if (self.pageNo < self.totalPage) {
        rowNum++;
    }



    return rowNum;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {


    //返回上一级的cell

    NSInteger moreLabelRow = [self.folderArray count]-1; //计算"更多"单元格出现的位置

//    if(self.curParentNo!=0){

//        moreLabelRow++;

//        if([indexPath row]==0) {
//            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"returnCell"];
//            if (!cell) {
//                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"returnCell"];
//            }
//
//            cell.textLabel.text = @"返回上级";
//            if(isPad){
//                cell.textLabel.font = [UtilTool currentSystemFont:18.0f];
//
//            }else{
//                cell.textLabel.font = [UtilTool currentSystemFont:14.0f];
//            }
//            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//
//            cell.tag = 1001;
//            return cell;
//        }
//    }



    if(self.pageNo<self.totalPage && [indexPath row]>moreLabelRow)
    {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"moreLabel"];
        cell.textLabel.text = @" 更 多 " ;
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        if(isPad){
            cell.textLabel.font = [UtilTool currentSystemFont:18.0f];

        }else{
            cell.textLabel.font = [UtilTool currentSystemFont:14.0f];

        }

        cell.tag = 1002;

        return cell;

    }




    NSInteger curIndex = [indexPath row];


    KnowledgeFolderCell *cell =(KnowledgeFolderCell *) [tableView dequeueReusableCellWithIdentifier:@"knowledgeFolder"];

    NSDictionary *kDic = (self.folderArray)[(NSUInteger) curIndex];

    cell.folderLabel.text = kDic[@"name"];

    cell.timeLabel.text = kDic[@"createDate"];


    cell.tag =1003;


    CGFloat height = 50 * self.myTableView.frame.size.width/320;
    CGFloat width = 50 * self.myTableView.frame.size.width/320;
    cell.constraintWidth.constant = width;
    cell.constraintHeight.constant = height;


    if([kDic[@"isParent"] boolValue]){

        cell.downloadBut.hidden = YES;

        cell.selectionStyle = UITableViewCellSelectionStyleGray;

        cell.iconImageView.image = [UIImage imageNamed:@"folder.png"];
    }else{


        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.downloadBut.hidden = NO;

        NSString *imageName = kDic[@"showImageUrl"];
        UIImage *iconImage = nil;

        NSArray *imageTypes = @[@"word",@"ppt",@"excel",@"pdf",@"text",@"otherFile",@"pic"];

        for(NSString *curImageType in imageTypes){
            if([[NSString stringWithFormat:@"%@.png",curImageType] isEqualToString:imageName] || [[NSString stringWithFormat:@"%@.jpg",curImageType] isEqualToString:imageName]){
                iconImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",curImageType]];
                break;
            }
        }


        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDownloadBut:)];
        cell.downloadBut.tag = curIndex;
        cell.downloadBut.userInteractionEnabled= YES;

        [cell.downloadBut addGestureRecognizer:tapGestureRecognizer];


        NSString *filePath  = nil;

        if(kDic[@"content"]!=[NSNull null]){
            filePath = [self getFileNameFromFileInfo:[kDic[@"content"]
           stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        }else{
            cell.downloadBut.hidden = YES;
        }

        if(filePath && [filePath length]>0){
            cell.downloadIngLabel.text = @"查看";
        }else{
            cell.downloadIngLabel.text = @"下载";
        }


        if(!iconImage){
            iconImage = [UIImage imageNamed:@"otherFile.png"];
        }

        cell.iconImageView.image = iconImage;

    }


    return cell;
}

-(void)tapDownloadBut:(UITapGestureRecognizer *)tapGestureRecognizer{
    UIView *view = tapGestureRecognizer.view;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    view.alpha=0.5f;
    [UIView commitAnimations];
    [self performSelector:@selector(processDownload:) withObject:view afterDelay:0.5];
}

/**
* 执行下载或查看
*/
-(void)processDownload:(UIView *)targetView{

    UILabel *curLabel = nil;

    for(UIView *eachView  in targetView.subviews){
        if(eachView.tag==33){
            curLabel = (UILabel *)eachView;
            break;
        }
    }

    if(!curLabel){
        return;
    }

    _downloadLabel = curLabel; //获得当前下载文字标签，以显示下载状态


    if((self.folderArray[targetView.tag])[@"content"] == [NSNull null]) {
        return;
    }


    _attachUrl = self.folderArray[targetView.tag][@"content"];
    _attachUrl=[_attachUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];





    targetView.alpha = 1.0f;

    if([curLabel.text isEqualToString:@"下载"]){

        if(_downloading){
            return;
        }



        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"下载" message:@"是否下载？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"下载", nil];
        alertView.tag = 2001;
        [alertView show];
    }else if([curLabel.text isEqualToString:@"查看"]){

        NSString *fileName = [self getFileNameFromFileInfo:_attachUrl];
        NSMutableDictionary *attachDic = [[NSMutableDictionary alloc] init];
        attachDic[@"attachUrl"] = fileName;
        attachDic[@"view"] = @"local";
        [self performSegueWithIdentifier:@"showAttach" sender:attachDic];
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"取消" message:@"是否取消下载？" delegate:self cancelButtonTitle:@"继续下载" otherButtonTitles:@"取消下载", nil];
        alertView.tag=100;
        [alertView show];
    }



}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];


     if(cell.tag==1002){//更多

        self.waitView = [[UIWaitView alloc] init:self.view.frame];
        [self.waitView.aiv startAnimating];
        [self.view addSubview:self.waitView];

        _pageNo++;
        if(_pageNo>_totalPage){
            _pageNo = _totalPage;
        }

        [self performSelector:@selector(loadNextPage:) withObject:@(_pageNo) afterDelay:0.5];

    }else{ //点击条目
        NSInteger curIndex = [indexPath row];

         _pageNo=1;

        NSDictionary *kDic = self.folderArray[(NSUInteger)curIndex];
        if([kDic[@"isParent"] boolValue]){ //是文件夹

            self.waitView = [[UIWaitView alloc] init:self.view.frame];
            [self.waitView.aiv startAnimating];
            [self.view addSubview:self.waitView];

            [self.preParentStack push:@(self.curParentNo)];
            [_folderNameStack push:self.navTitleLabel.text];

            self.curParentNo = 1;

            [self performSelector:@selector(initData:) withObject:kDic[@"id"] afterDelay:0.5];

            self.navTitleLabel.text = kDic[@"name"];


        }

    }

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    if([segue.identifier isEqualToString:@"knowledgeList2Detail"]){
//        KnowledgeDetailViewController *kdvc = (KnowledgeDetailViewController *)segue.destinationViewController;
//        kdvc.kid = [sender[@"id"] integerValue] ;
//        kdvc.createTime = sender[@"createDate"];
//
//    }

    if([@"showAttach" isEqualToString:segue.identifier]){

        NSMutableDictionary *dic = sender;

        ReadAttachOnLineViewController *readAttachOnLineViewController = (ReadAttachOnLineViewController *)segue.destinationViewController;
        if([dic[@"view"] isEqualToString:@"online"]) {
            readAttachOnLineViewController.fileName = nil;
            readAttachOnLineViewController.attachUrl = dic[@"attachUrl"];
        }else{
            readAttachOnLineViewController.attachUrl = nil;
            readAttachOnLineViewController.fileName = dic[@"attachUrl"];
        }
    }
}


-(void)loadNextPage:(NSNumber *)pageNO{

    NSDictionary *userDic = [UtilTool getUserDic];
    NSString *token = userDic[@"token"];

    //读取首页数据



    NSMutableString *url = [NSMutableString stringWithFormat:@"%@manager/professionKnowledge/list?json={'token':'%@','parentId':%ld,'pageIndex':%ld,'pageSize':%ld}", [UtilTool getHostURL], token, (long)_curParentNo, (long)_pageNo,(long)_pageSize];
    NSNumber *status;
    NSString *jsonString = [UtilTool sendUrlRequestByCache:url paramValue:nil method:HTTPRequestMethodGet isReload:YES status:&status];

    SBJsonParser *parser = [[SBJsonParser alloc] init];
    if(jsonString && [jsonString length]>0){
        NSDictionary *curDic = [parser objectWithString:jsonString];
        if(curDic){
            [self.folderArray addObjectsFromArray:curDic[@"list"]] ;
            self.totalPage = [curDic[@"totalPage"] integerValue];
        }
    }

    //如果是从缓存中读取的，则后台启动一个线程读取网络数据




//    for(NSMutableDictionary *testDic in self.folderArray){
//        testDic[@"attachmentUrl"] =  @"http://www.parsec.com.cn/pc-Europa-2.doc?xxfee=343";
//
//    }


    [self reloadTableView];

    [self.waitView stopAnimating];
    [self.waitView removeFromSuperview];

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 60.0f;

    return height * self.myTableView.frame.size.width/320;
}


- (void)clickBack:(UITapGestureRecognizer *)gesture {
    NSNumber *level = [self.preParentStack pop];

    NSString *folderName= [_folderNameStack pop];

    if(folderName== nil){
        folderName = @"业务知识";
    }
    self.navTitleLabel.text = folderName;


    if(level){
        _pageNo=1;

        self.waitView = [[UIWaitView alloc] init:self.view.frame];
        [self.waitView.aiv startAnimating];
        [self.view addSubview:self.waitView];
        [self performSelector:@selector(initData:) withObject:level afterDelay:0.5];
    }else{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(alertView.tag==2001){ //下载
        if(buttonIndex==1){
            [[NSURLCache sharedURLCache] removeAllCachedResponses];
            NSURL *url = [NSURL URLWithString:_attachUrl];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            _connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
            [_connection start];
        }
    }else if(alertView.tag==100){ //取消下载
        if(buttonIndex==1){
            _downloading = NO;
            [_connection cancel];
        }
    }

}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    if(_receiveData){
        [_receiveData setLength:0];
    }else{
        _receiveData = [[NSMutableData alloc] init];
    }

    _downloading  = YES;

    NSHTTPURLResponse *curResponse = (NSHTTPURLResponse *)response;
    NSDictionary *headers = [curResponse allHeaderFields];
    _fileLength =  [headers[@"Content-Length"] longLongValue];
    if(_fileLength==0)_fileLength=1;

    _receivedLength = 0;
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterPercentStyle;
    _downloadLabel.text = [formatter stringFromNumber:@(_receivedLength/_fileLength)];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;


}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_receiveData appendData:data];
    _receivedLength +=  [data length];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterPercentStyle;
    _downloadLabel.text = [formatter stringFromNumber:@(_receivedLength/_fileLength)];

}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    _downloadLabel.text = @"查看";

    NSDate *date = [NSDate date];
    NSTimeInterval timeInterval = [date timeIntervalSince1970];

    NSString *attachUrl = _attachUrl;

    NSString *curFileName = [_attachUrl lastPathComponent];


    NSRange range = [curFileName rangeOfString:@"?"];
    if(range.location != NSNotFound){
        curFileName = [curFileName substringToIndex:range.location];
    }


    NSString *fileName = [NSString stringWithFormat:@"%d%@", (int) timeInterval,curFileName];


    NSArray *ar = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = ar[0];
    NSString *path = [documentPath stringByAppendingString:[NSString stringWithFormat:@"/%@",fileName]];

    _downloading = NO;
    [_receiveData writeToFile:path atomically:YES];
    [self saveFileInfo:attachUrl fileName:fileName];

}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    _downloading = NO;
    _downloadLabel.text = @"下载";
}


-(void)saveFileInfo:(NSString *)url fileName:(NSString *)fileName{
    NSArray *arr  = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = arr[0];
    NSString *path = [documentPath stringByAppendingString:@"/fileInfo.plist"];
    NSMutableDictionary *fileDic = [NSMutableDictionary dictionaryWithContentsOfFile:path];

    if(!fileDic){
        fileDic = [[NSMutableDictionary alloc] init];
    }

    fileDic[url] = fileName;

    [fileDic writeToFile:path atomically:YES];
}

-(NSString *)getFileNameFromFileInfo:(NSString *)url{
    NSArray *arr  = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = arr[0];
    NSString *path = [documentPath stringByAppendingString:@"/fileInfo.plist"];
    NSDictionary *fileDic = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    if (!fileDic) {
        return nil;
    }

    if(fileDic[url] == [NSNull null]){
        return nil;
    }

    NSString *fileName = fileDic[url];

    if(fileName && [fileName length]>0){
        return fileName;
    }

    return nil;
}



@end
