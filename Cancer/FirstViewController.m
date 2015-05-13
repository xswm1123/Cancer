//
//  FirstViewController.m
//  Cancer
//
//  Created by hu su on 14/10/21.
//  Copyright (c) 2014年 parsec. All rights reserved.
//

#import "FirstViewController.h"
#import "UtilTool.h"
#import "UIWaitView.h"
#import "PagePhotosView.h"
#import "SBJsonParser.h"
#import "FirstPageCellHeaderView.h"
#import "FirstPageItemCell.h"
#import "UIImageView+WebCache.h"
#import "CustomUILabel.h"
#import "BubbleView.h"
#import "InSideMsgDetailViewController.h"
#import "ReadAttachOnLineViewController.h"
#import "ViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

@synthesize myTable = _myTable;
@synthesize msgNoticeView = _msgNoticeView;
@synthesize adArray = _adArray;
@synthesize waitView = _waitView;
@synthesize advertiseView = _advertiseView;

@synthesize firstPageDataDic = _firstPageDataDic;

@synthesize msgArray = _msgArray;

@synthesize movingMsgLabel = _movingMsgLabel;

@synthesize bubbleView = _bubbleView;


- (void)viewDidLoad {
    [super viewDidLoad];


    [NSThread detachNewThreadSelector:@selector(readWorkReportRemind) toTarget:self withObject:nil];


    _downloading = NO;
    curMsgIndex=0;


//    self.navigationController.navigationBar.backgroundColor =[UtilTool colorWithHexString:@"16b7e5"];

    self.navigationController.navigationBar.barTintColor = [UtilTool colorWithHexString:@"16b7e5"];

    self.leftImage = [UIImage imageNamed:@"clientVersionBut.png"];
    self.leftImageRect = CGRectMake(0, 0, 83, 39);

   self.hideRightBut = YES;

    curWorkReportNum=0;

    self.myTable.separatorStyle = UITableViewCellSeparatorStyleNone;






    colorArry = @[@"f668b2",@"67d6da",@"fdc800",@"faadd5"];

    imageArray = @[[UIImage imageNamed:@"workReportMain.png"],[UIImage imageNamed:@"insideMsgMain.png"],[UIImage imageNamed:@"knowledge.png"],[UIImage imageNamed:@"checkwork.png"]];



    [self performSelector:@selector(saveLoginRecord) withObject:nil afterDelay:0.3];

    // Do any additional setup after loading the view.
}

-(void)saveLoginRecord{
//    loginRecord/save


    NSDictionary *userDic = [UtilTool getUserDic];
    NSInteger userId = [[[userDic objectForKey:@"user"][0] objectForKey:@"id"] integerValue];



    NSString *url = [NSString stringWithFormat:@"%@loginRecord/save",[UtilTool getHostURL]];

    NSString *para = nil;

    if(isPad){
        para= [NSString stringWithFormat:@"json={'userId':%d,'device':'iPad'}",userId];
    }else{
        para =  [NSString stringWithFormat:@"json={'userId':%d,'device':'iPhone'}",userId];
    }

    NSNumber *err;
   [UtilTool sendUrlRequestByCache:url paramValue:para method:HTTPRequestMethodPost isReload:YES status:&err];


}


/**
* 从缓存中读取数据，如果是第一次访问，则直接从网络读取数据
*/
-(void)getFirstViewData{


    NSDictionary *userDic = [UtilTool getUserDic];
    NSString *curToken = [userDic objectForKey:@"token"];

    //读取首页数据

    NSMutableString *url = [NSMutableString stringWithFormat:@"%@manager/first/list?json={'token':'%@'}",[UtilTool getHostURL],curToken];




    NSNumber *status;
    NSString *jsonString = [UtilTool sendUrlRequestByCache:url paramValue:nil method:HTTPRequestMethodGet isReload:NO status:&status];





    SBJsonParser *parser = [[SBJsonParser alloc] init];


    if([status intValue]==3){
        curIndexListUrl = url;
        [NSThread detachNewThreadSelector:@selector(visitIndexUrlBackground) toTarget:self withObject:nil];
    }else{
        if(jsonString== nil){
            [self performSelector:@selector(loginTimeout) withObject:nil afterDelay:0.5];
            return;
        }
        NSDictionary *validDic = [parser objectWithString:jsonString];
        if(validDic[@"status"]!=[NSNull null] && [validDic[@"status"] isEqual:@"500"]){
            [self performSelector:@selector(loginTimeout) withObject:nil afterDelay:0.5];
            return;
        }
    }


    if(jsonString && [jsonString length]>0){
        self.firstPageDataDic = [parser objectWithString:jsonString];
    }



    //读取广告数据

    curAdUrl = [NSString stringWithFormat:@"%@advert/list?json={'funType':'index'}",[UtilTool getHostURL]];

//    NSString *paraValue= @"json={'funType':'index'}";

    NSNumber *status1;

    jsonString = [UtilTool sendUrlRequestByCache:curAdUrl paramValue:nil method:HTTPRequestMethodGet isReload:NO status:&status1];
    if(jsonString && [jsonString length]>0){
        self.adArray = [parser objectWithString:jsonString];
    }


    //如果是从缓存中读取的，则后台启动一个线程读取网络数据





    [self reloadTableView];

    [self.waitView stopAnimating];
    [self.waitView removeFromSuperview];
}

/**
* 后台从网络读取首页数据
*/


-(void)visitIndexUrlBackground{


    NSNumber *status;


    NSString *jsonString =  [UtilTool sendUrlRequestByCache:curIndexListUrl paramValue:nil method:HTTPRequestMethodGet isReload:YES status:&status];
    SBJsonParser *parser =  [[SBJsonParser alloc] init];




    NSNumber *status1;

    NSString *jsonString1 = [UtilTool sendUrlRequestByCache:curAdUrl paramValue:nil method:HTTPRequestMethodGet isReload:YES status:&status1];


    if([status intValue]==2 || [status1 intValue]==2){


        NSDictionary *returnDic = [parser objectWithString:jsonString];

        if(!jsonString){
                [self performSelectorOnMainThread:@selector(loginTimeout) withObject:nil waitUntilDone:YES];
                return;

        }


        if(returnDic[@"status"] != [NSNull null]){
            if(returnDic[@"status"]!= nil && [returnDic[@"status"] isEqual:@"500"]){
                [self performSelectorOnMainThread:@selector(loginTimeout) withObject:nil waitUntilDone:YES];
                return;
            }
        }



        if(jsonString && [jsonString length]>0){

            self.firstPageDataDic = [returnDic mutableCopy];
        }

        if(jsonString1 && [jsonString1 length]>0){
            self.adArray = [parser objectWithString:jsonString1];
        }

        [self performSelectorOnMainThread:@selector(reloadTableView) withObject:nil waitUntilDone:YES];
    }


}

-(void)loginTimeout{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"过期" message:@"登录过期，请重新登录" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    alertView.tag = 500;
    [alertView show];
}

//后台读取最新消息
-(void)readMsg{


    NSDictionary *userDic = [UtilTool getUserDic];


    NSDictionary *user = [[userDic objectForKey:@"user"] objectAtIndex:0];

    NSString *token = [userDic objectForKey:@"token"];

    NSNumber *status;
    NSString *url = [NSString stringWithFormat:@"%@/manager/message/top?json={token:'%@'}",[UtilTool getHostURL],token];

    NSString *jsonString =  [UtilTool sendUrlRequestByCache:url paramValue:nil method:HTTPRequestMethodGet isReload:YES status:&status];
    SBJsonParser *parser =  [[SBJsonParser alloc] init];

    if(jsonString && [jsonString length]>0){
        NSDictionary *msgDic = [parser objectWithString:jsonString];


        NSDictionary *allMsgArray = [msgDic objectForKey:@"messages"] ;

        self.msgArray = [[NSMutableArray alloc] init];

        NSDictionary *userMsgReadStatusDic = [UtilTool getMsgReadStatus];
        NSDictionary *curUserStatusDic = nil;
        if(userMsgReadStatusDic!= nil){
            NSString *key = [NSString stringWithFormat:@"k%ld",(long)[user[@"id"] integerValue]];
            if(userMsgReadStatusDic[key] != [NSNull null]){
                curUserStatusDic = userMsgReadStatusDic[key];
            }
        }

        if(curUserStatusDic== nil){
            curUserStatusDic = [[NSDictionary alloc] init];
        }

        NSString *statusKey= nil;
            for (NSDictionary *msgDic in allMsgArray) {
                statusKey = [NSString stringWithFormat:@"k%ld",(long)[[msgDic objectForKey:@"id"] integerValue]];
                if(curUserStatusDic[statusKey]== [NSNull null] || curUserStatusDic[statusKey]==nil){
                    [_msgArray addObject:msgDic];
                }
            }


    }




    if([status intValue]==2){
       [self performSelectorOnMainThread:@selector(initMsg) withObject:nil waitUntilDone:YES];
    }

}

-(void)initMsg{
    if(self.msgArray && [self.msgArray count]>0){
        [self msgViewToggle:NO];

        NSDictionary *dic = (self.msgArray)[0];
        if( dic[@"summary"] != [NSNull null]) {
            self.movingMsgLabel.text = dic[@"summary"];
        }
        self.movingMsgLabel.tag = 0;
        self.movingMsgLabel.userInteractionEnabled = YES;

        UITapGestureRecognizer *tapMsg = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMsg:)];
        [self.movingMsgLabel addGestureRecognizer:tapMsg];

        if(!(curTimer && [curTimer isValid])) {
            curTimer = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(msgScroll) userInfo:nil repeats:YES];
        }

    }else{

        if(curTimer && [curTimer isValid]){
            [curTimer invalidate];
        }

        [self msgViewToggle:YES];
    }
}

-(void)tapMsg:(UITapGestureRecognizer *)tapGestureRecognizer{
    UILabel *curLabel = (UILabel *)tapGestureRecognizer.view;
    NSInteger index = curLabel.tag;
    NSDictionary *msgDic = self.msgArray[index];
    [self performSegueWithIdentifier:@"first2MsgDetail" sender:msgDic];
}


-(void) msgScroll{
    if(self.msgArray && [self.msgArray count]>0){
        curMsgIndex++;
        if(curMsgIndex> [self.msgArray count]-1){
            curMsgIndex=0;
        }



        CATransition *animation = [CATransition animation];

        animation.duration = 0.5f;
        animation.fillMode = kCAFillModeForwards;
        animation.type = kCATransitionPush;
        animation.subtype = kCATransitionFromTop;

        [self.movingMsgLabel.layer addAnimation:animation forKey:@"animation"];

        if([[self.msgArray objectAtIndex:curMsgIndex] objectForKey:@"summary"] != [NSNull null]) {
            self.movingMsgLabel.text = [[self.msgArray objectAtIndex:curMsgIndex] objectForKey:@"summary"];
        }
        self.movingMsgLabel.tag = curMsgIndex;



    }
}
/**
* 重新刷新表格
*/
-(void) reloadTableView{

    [self.myTable reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//跳转到客户版
- (void)clickBack:(UITapGestureRecognizer *)gesture {
    BOOL appExisted=[[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"salesHelper://"]];
    if(appExisted){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"salesHelper://"]];
    }else{
        //需要修改为客户版下载地址
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/zhong-guo-yi-dong-shou-ji/id583700738?mt=8"]];
    }
}

- (void)viewWillAppear:(BOOL)animated {



    self.waitView = [[UIWaitView alloc] init:self.view.frame];
    [self.view addSubview:self.waitView];
    [self.waitView startAnimating];


    [self performSelector:@selector(getFirstViewData) withObject:nil afterDelay:0.2];



    [super viewWillAppear:animated];
    [self msgViewToggle:YES];

}

- (void)viewDidAppear:(BOOL)animated {
    [NSThread detachNewThreadSelector:@selector(readMsg) toTarget:self withObject:nil];

    [super viewDidAppear:animated];

}

-readWorkReportRemind{


    NSDictionary *userDic = [UtilTool getUserDic];
    NSString *token = [userDic objectForKey:@"token"];

    NSDictionary *user = [[userDic objectForKey:@"user"] objectAtIndex:0];



    NSInteger userId = [user[@"id"] integerValue];

    NSString *url = [NSString stringWithFormat:@"%@manager/jobReport/workReportToRemind",[UtilTool getHostURL]];

    NSString *para = [NSString stringWithFormat:@"json={'token':'%@','userId':%li}",token,(long)userId];

    while(YES){

        NSNumber *status;
        NSString *jsonString = [UtilTool sendUrlRequestByCache:url paramValue:para method:HTTPRequestMethodPost isReload:YES status:&status] ;

        if([status integerValue]==2){
            if(jsonString && [jsonString length]>0){
                SBJsonParser *parser = [[SBJsonParser alloc] init];
                NSDictionary *dic = [parser objectWithString:jsonString];
               curWorkReportNum = [[dic objectForKey:@"totalMsgNum"] integerValue];


            }
        }


        [self performSelectorOnMainThread:@selector(addBubble) withObject:nil waitUntilDone:YES];

        [NSThread sleepForTimeInterval:5.0f];
    }


}

-(void)addBubble{
    if(curWorkReportNum>0){
        if(workReportView){
//            if(!self.bubbleView){
                self.bubbleView = [[[NSBundle mainBundle] loadNibNamed:@"bubbleView" owner:self options:nil] firstObject];

                self.bubbleView.frame = CGRectMake(workReportImageView.frame.size.width + workReportImageView.frame.origin.x -15, workReportImageView.frame.origin.y -5, 20, 20);

                [workReportView addSubview:self.bubbleView];
//            }

            self.bubbleView.numberLabel.text = [NSString stringWithFormat:@"%li",(long)curWorkReportNum];
        }
    }else{
        if(self.bubbleView){
            [self.bubbleView removeFromSuperview];
            self.bubbleView = nil;
        }
    }



}

-(void)msgViewToggle:(BOOL)close{
    NSLayoutConstraint *msgViewConstraint = nil;

    for(NSLayoutConstraint *c in self.view.constraints){
        if([c.firstItem isEqual:self.msgNoticeView]){
            if(c.firstAttribute == NSLayoutAttributeTop){
                msgViewConstraint=c;
                break;
            }
        }
    }


    if(close){
            msgViewConstraint.constant = -34.0f;

    }else{
        msgViewConstraint.constant = 0.0f;

    }

    self.msgNoticeView.hidden = close;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    if(!self.firstPageDataDic){
        return 0;
    }


    NSInteger  secionNum =  3;
    if(self.adArray && [self.adArray count]>0){
        secionNum ++;
    }
    return secionNum;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    NSInteger  curSectionIndex = section;
    if(!(self.adArray && [self.adArray count]>0)){
        curSectionIndex++;
    }

    if(curSectionIndex<2){
        return 1;
    }else if(curSectionIndex==2){ //内部消息
        NSArray *activityArray =  [self.firstPageDataDic objectForKey:@"ims"];
        if(activityArray){
            return [activityArray count];
        }
    }else if(curSectionIndex==3){ //业务只是
        NSArray *terminalArray = [self.firstPageDataDic objectForKey:@"pks"];
        if(terminalArray){


            return [terminalArray count];
        }
    }

    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *cellName = @"FirstViewCell";

    UITableViewCell *cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];;

    cell.selectionStyle = UITableViewCellSelectionStyleNone;


    NSInteger curSection =[indexPath section];

    if(!(self.adArray != nil && [self.adArray count]>0)){
        curSection++;
    }


    if(curSection==0){ //广告

        CGFloat x = (self.myTable.frame.size.width-310 * (self.myTable.frame.size.width/320))/2.0f;

        self.advertiseView = [[PagePhotosView alloc] initWithFrame:CGRectMake(x,5, 310 * (self.myTable.frame.size.width/320), 150 * (self.myTable.frame.size.width/320)) withDataSource:self];



        [self.advertiseView autoTurnPage:YES];

        [cell addSubview:self.advertiseView];
    }else if(curSection==1){ //功能按钮



        CGFloat height =  (320-10-6)/4 * self.myTable.frame.size.width/320 ;

        for(int i=0;i<4;i++){

            CGFloat leftMargin = (self.myTable.frame.size.width - (height+2)*4)/2;

            UIView *functionView = [[UIView alloc] initWithFrame:CGRectMake(leftMargin+i*height+i*2, 0, height, height)];
            functionView.backgroundColor = [UtilTool colorWithHexString:[colorArry objectAtIndex:i]];

            CGFloat imageWidth = (127/2) * ((self.myTable.frame.size.width/320.0)>1.0?(self.myTable.frame.size.width/320)*0.8:1.0f);
            CGFloat imageHeight = (110/2) * ((self.myTable.frame.size.width/320)>1.0?(self.myTable.frame.size.width/320)*0.8:1.0f);



            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((height-imageWidth)/2 , (height-imageHeight)/2, imageWidth, imageHeight)];
            imageView.image = [imageArray objectAtIndex:i];
            [functionView addSubview:imageView];



            functionView.tag = i;

            UITapGestureRecognizer *functionTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickFunctionBut:)];
            [functionView addGestureRecognizer:functionTapGesture];


            if(i==0){
                workReportView = functionView;
                workReportImageView = imageView;
            }


            [cell addSubview:functionView];
        }



    }else if(curSection==2){ //内部消息

        if(!self.firstPageDataDic || ![self.firstPageDataDic objectForKey:@"ims"]){
            return nil;
        }

        CGFloat weight = self.myTable.frame.size.width/320;

        if(weight*0.8>1){
            weight = (CGFloat) (weight *0.8);
        }

        NSDictionary *msgDic = [[self.firstPageDataDic objectForKey:@"ims"] objectAtIndex:[indexPath row]];

        FirstPageItemCell *itemCell =  [[[NSBundle mainBundle] loadNibNamed:@"FirstPageItemCell" owner:self options:nil] firstObject];
        [itemCell.iconImageView setImageWithURL:[NSURL URLWithString:[msgDic objectForKey:@"showImageUrl"]] placeholderImage:[UIImage imageNamed:@"noPicIcon.png"]];

        itemCell.titleLabel.text = [msgDic objectForKey:@"title"];
        itemCell.titleLabel.font = [UtilTool currentSystemFont:14.0f];
        if(isPad){
            itemCell.titleLabel.font = [UtilTool currentSystemFont:18.0f];
        }



        [itemCell.contentLabel setLabelText:[msgDic objectForKey:@"summary"] maxHeight:35.0f fontSize:12.0f];
        if(isPad){
            [itemCell.contentLabel setLabelText:[msgDic objectForKey:@"summary"] maxHeight:50.0f fontSize:16.0f];

        }
        itemCell.timeLabel.text = [msgDic objectForKey:@"showCreateDate"];
        if(isPad){
            itemCell.timeLabel.font = [UtilTool currentSystemFont:16];
        }




       for(UIView *view in itemCell.subviews){
           for(NSLayoutConstraint *con  in view.constraints){
               con.constant = con.constant * weight;
           }
       }


       itemCell.leftMargin.constant = itemCell.leftMargin.constant * weight;
       itemCell.rightMargin.constant = itemCell.rightMargin.constant *weight;





       itemCell.percentLabel.hidden = YES;

        cell = itemCell;

    } else if(curSection ==3){ //业务知识
        if(!self.firstPageDataDic || ![self.firstPageDataDic objectForKey:@"pks"]){
            return nil;
        }


        NSDictionary *msgDic = [[self.firstPageDataDic objectForKey:@"pks"] objectAtIndex:[indexPath row]];

        CGFloat weight = self.myTable.frame.size.width/320;

        if(weight*0.8>1){
            weight = weight *0.8;
        }

        FirstPageItemCell *itemCell =  [[[NSBundle mainBundle] loadNibNamed:@"FirstPageItemCell" owner:self options:nil] firstObject];
//        [itemCell.iconImageView setImageWithURL:[NSURL URLWithString:[msgDic objectForKey:@"showImageUrl"]] placeholderImage:[UIImage imageNamed:@"noPicIcon.png"]];


        NSString *imageName =  msgDic[@"showImageUrl"];
        UIImage *iconImage = nil;

        NSArray *imageTypes = @[@"word",@"ppt",@"excel",@"pdf",@"text",@"otherFile",@"pic"];

        for(NSString *curImageType in imageTypes){
            if([[NSString stringWithFormat:@"%@.png",curImageType] isEqualToString:imageName] || [[NSString stringWithFormat:@"%@.jpg",curImageType] isEqualToString:imageName]){
                iconImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",curImageType]];
                break;
            }
        }

        if(!iconImage){
            iconImage = [UIImage imageNamed:@"otherFile.png"];
        }

        itemCell.iconImageView.image=iconImage;




        itemCell.titleLabel.text = msgDic[@"title"];
        itemCell.titleLabel.font = [UtilTool currentSystemFont:14.0f];
        if(isPad){
            itemCell.titleLabel.font = [UtilTool currentSystemFont:18.0f];
        }


        if(msgDic[@"summary"] !=[NSNull null]){
            [itemCell.contentLabel setLabelText:msgDic[@"summary"] fontSize:12.0f];
            if(isPad){
                [itemCell.contentLabel setLabelText:msgDic[@"summary"] fontSize:16.0f];

            }
        }



        itemCell.timeLabel.text = msgDic[@"showCreateDate"];
        if(isPad){
            itemCell.timeLabel.font = [UtilTool currentSystemFont:16];
        }




        for(UIView *view in itemCell.subviews){
            for(NSLayoutConstraint *con  in view.constraints){
                con.constant = con.constant * weight;
            }
        }


        itemCell.leftMargin.constant = itemCell.leftMargin.constant * weight;
        itemCell.rightMargin.constant = itemCell.rightMargin.constant *weight;




        itemCell.percentLabel.hidden = NO;

        if(msgDic[@"showContentUrl"] != [NSNull null]) {

            NSString *path = [self getFileNameFromFileInfo:[msgDic[@"showContentUrl"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            if (path && [path length] > 0) {
                itemCell.percentLabel.text = @"点击查看";
            } else {
                itemCell.percentLabel.text = @"点击下载";
            }
        }

        if(isPad){
            itemCell.percentLabel.font =  [UtilTool currentSystemFont:16];
        }


        cell = itemCell;



    }




    return cell;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {


    if(section<2){
        return nil;
    }


    FirstPageCellHeaderView *headerView =[[[NSBundle mainBundle] loadNibNamed:@"FirstPageCellHeader" owner:self options:nil] firstObject];

    headerView.frame = CGRectMake(0, 0, 320 * self.myTable.frame.size.width/320, 22*  self.myTable.frame.size.width/320 );
    headerView.rightImageView.userInteractionEnabled = YES;




    CGFloat weight= 1.0f;
    if((self.myTable.frame.size.width/320)*0.7>1){
        weight = (self.myTable.frame.size.width/320.0f)*0.7f;
    }

    for(UIView *subView in headerView.subviews){
        for(NSLayoutConstraint *constraint in subView.constraints){

           constraint.constant = constraint.constant * weight;
        }
    }

    headerView.titleLabel.font = [UtilTool currentSystemFont:12 * weight] ;
    headerView.leftMarginConstraint.constant = headerView.leftMarginConstraint.constant * weight;
    headerView.rightMarginConstraint.constant = headerView.rightMarginConstraint.constant *weight;
    headerView.lineleftMarginConstraint.constant = headerView.lineleftMarginConstraint.constant * weight;


    if(section==2){
        headerView.titleLabel.text = @"内部消息";
        headerView.rightImageView.tag=0;
        UITapGestureRecognizer *tap  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(moreTap:)];
        [headerView.rightImageView addGestureRecognizer:tap];

    }else if(section==3){
        headerView.titleLabel.text = @"业务知识";
        headerView.leftImageView.image = [UIImage imageNamed:@"knowledgeIcon.png"];
        headerView.rightImageView.tag=1;
        UITapGestureRecognizer *tap  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(moreTap:)];
        [headerView.rightImageView addGestureRecognizer:tap];
    }
    return headerView;

}

//点击更多
-(void)moreTap:(UITapGestureRecognizer *)gestureRecognizer{

    if(gestureRecognizer.view.tag==0){
        [self performSegueWithIdentifier:@"first2insideMsg" sender:nil];
    }else if(gestureRecognizer.view.tag==1){
        [self performSegueWithIdentifier:@"first2konwledge" sender:nil];

    }

}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    if(section<=1){
        return 0;
    }

    CGFloat defaultHeiht = 22.0 * self.myTable.frame.size.width/320;
    return defaultHeiht;
}


-(void)clickFunctionBut:(UITapGestureRecognizer *)tapGestureRecognizer{
    tapGestureRecognizer.view.alpha = 0.5;

    [self performSelector:@selector(doFunction:) withObject:tapGestureRecognizer.view afterDelay:0.5];
}

-(void)doFunction:(UIView *)buttonView{

    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    buttonView.alpha = 1.0f;
    [UIView commitAnimations];

    if(buttonView.tag==0){
        [self performSegueWithIdentifier:@"first2workReport" sender:self];
    }else if(buttonView.tag==1){
        [self performSegueWithIdentifier:@"first2insideMsg" sender:self];
    }else if(buttonView.tag==2){
        [self performSegueWithIdentifier:@"first2konwledge" sender:self];


    }else if(buttonView.tag==3){
        [self performSegueWithIdentifier:@"first2Check" sender:self];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSInteger curSection =[indexPath section];

    if(!(self.adArray != nil && [self.adArray count]>0)){
        curSection++;
    }



    if(!self.firstPageDataDic){
        return 0;
    }

    CGFloat height=0.0;

    CGSize myTableSize = self.myTable.frame.size;


    switch(curSection){
        case 0:

            height =  150  * (myTableSize.width/320) + 10.0f;


            break;
        case 1: //功能按钮

            return (320-10-6)/4 * myTableSize.width/320 +5;


            break;

        default: //常用应用
            height = 68 * myTableSize.width/320 ;
            break;
    }

    return height;

}





- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger curSection =[indexPath section];

    [tableView deselectRowAtIndexPath:indexPath animated:YES];


    if(!(self.adArray != nil && [self.adArray count]>0)){
        curSection++;
    }

    if(curSection==2){ //内部消息

        NSDictionary *msgDic = [[self.firstPageDataDic objectForKey:@"ims"] objectAtIndex:[indexPath row]];
        if(msgDic){
            [self performSegueWithIdentifier:@"first2MsgDetail" sender:msgDic];
        }
    }else if(curSection==3){//业务知识
        NSDictionary *kDic = self.firstPageDataDic[@"pks"][indexPath.row];
        NSString *attachUrl = nil;



        if(kDic[@"showContentUrl"]!=[NSNull null]){
            attachUrl=kDic[@"showContentUrl"];
        }else{
            return;
        }



        FirstPageItemCell *itemCell =  (FirstPageItemCell *)[tableView cellForRowAtIndexPath:indexPath];

        NSString *labelString = itemCell.percentLabel.text;


        if(_downloading && [@"点击下载" isEqualToString:labelString]){ //在下载的时候点击别的单元格，如果此单元格文件还未下载，则不处理
            return;
        }else if(_downloading && ![@"点击查看" isEqualToString:labelString]){//在下载时点击下载单元格
            UIAlertView *alertView= [[UIAlertView alloc] initWithTitle:@"提醒" message:@"是否取消下载？" delegate:self cancelButtonTitle:@"继续" otherButtonTitles:@"取消下载", nil];
            alertView.tag = 100;
            [alertView show];
            return;
        }



//        attachUrl =  @"http://www.parsec.com.cn/pc-Europa-2.doc";

        attachUrl=[attachUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *path = [self getFileNameFromFileInfo:attachUrl];
        if(path && [path length]>0){
            [self performSegueWithIdentifier:@"first2AttachRead" sender:path];
        }else{


            _downloadUrl = attachUrl;


            _downloadLabel = itemCell.percentLabel;

            UIAlertView *alertView= [[UIAlertView alloc] initWithTitle:@"提醒" message:@"是否下载？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"下载", nil];
            alertView.tag = 200;
            [alertView show];
        }


    }


}

//保存下载文件后的信息
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
//获得已经下载的文件的存放路径,如果没有则返回nil
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


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([@"first2MsgDetail" isEqualToString:segue.identifier]){
        NSDictionary *msgDic = (NSDictionary *)sender;
        InSideMsgDetailViewController *inSideMsgDetailViewController = (InSideMsgDetailViewController *) segue.destinationViewController;
        inSideMsgDetailViewController.messageId = [msgDic[@"id"] longValue];
    }else if([@"first2AttachRead" isEqualToString:segue.identifier]){
        NSString *path = sender;
        ReadAttachOnLineViewController *readAttachOnLineViewController = (ReadAttachOnLineViewController *)segue.destinationViewController;
        readAttachOnLineViewController.fileName = path;
        readAttachOnLineViewController.attachUrl = nil;

    }

}





- (int)numberOfPages:(PagePhotosView *)photosView {
    return (int)[self.adArray count];
}

- (NSString *)imageAtIndex:(int)index1 PagePhotosView:(PagePhotosView *)photosView {
    NSDictionary *adDic = self.adArray[index1];
    NSString *picName = adDic[@"showUrl"];
    return picName;
}

- (void)selectImageView:(NSInteger)page pagePhotosView:(PagePhotosView *)photosView {
    NSDictionary *adDic = (self.adArray)[page];

    if(adDic) {
        NSString *skipType =  [adDic objectForKey:@"skipType"];

        if ([@"out" isEqualToString:skipType]) { //外部链接
            NSString *outUrl = [adDic objectForKey:@"outUrl"];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:outUrl]];

        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(alertView.tag==200){
        if(buttonIndex==1){
            [[NSURLCache sharedURLCache] removeAllCachedResponses];
            NSURL *url = [NSURL URLWithString:_downloadUrl];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            _connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
            [_connection start];
        }
    }else if(alertView.tag==100){
         if(buttonIndex==1){
             [_connection cancel];
         }
    }else if(alertView.tag==500){
       [self performSelector:@selector(loginOut) withObject:nil afterDelay:0.7];
    }
}

-(void)loginOut{
    NSMutableDictionary *userDic = [[UtilTool getUserDic] mutableCopy];
    if(userDic){
        userDic[@"notAuto"] = @(YES);
    }

    [UtilTool saveUserDic:userDic];

    ViewController *viewController = (ViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"loginViewController"];

    [[[UIApplication sharedApplication] keyWindow] setRootViewController:viewController];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    if(_receiveData){
        [_receiveData setLength:0];
    }else{
        _receiveData = [[NSMutableData alloc] init];
    }

    _downloading  = YES;

    _downloadLabel.hidden = NO;

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
    _downloadLabel.text = @"点击查看";

    NSDate *date = [NSDate date];
    NSTimeInterval timeInterval = [date timeIntervalSince1970];

    NSString *attachUrl = _downloadUrl;

    NSString *curFileName = [_downloadUrl lastPathComponent];


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

    _downloadLabel.hidden = YES;
}


@end
