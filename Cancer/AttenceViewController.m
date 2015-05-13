//
//  AttenceViewController.m
//  Cancer
//
//  Created by Parsec on 14-10-28.
//  Copyright (c) 2014年 parsec. All rights reserved.
//

#import "AttenceViewController.h"

#import <CoreLocation/CoreLocation.h>

#import "QRadioButton.h"

#import "UtilTool.h"
#import "SBJsonParser.h"
#import "UIWaitView.h"
#import "Constants.h"

@interface AttenceViewController (){
    //签到/签退类型
    int signType;
    //经纬度
    float longitude;
    float latitude;
    //签到、签退数组
    NSArray *signStr;
    //是否选择图片
    int isPic;
    
    NSString *markMsg;
}
@end

@implementation AttenceViewController

@synthesize markTextView;

@synthesize waitView;

@synthesize addressLabel;

@synthesize picImageView;

@synthesize scrollView;

- (void)viewDidLoad {
    self.navTitle=ATTENDANCE_VC_TITLE;
    self.hideRightBut=YES;
    
    signStr=@[@"签到",@"签退"];
    markMsg=@"备注";
    //图片添加手势
    UITapGestureRecognizer *gs=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(choicePic)];
    [picImageView addGestureRecognizer:gs];
    picImageView.userInteractionEnabled=YES;
    //签到单选按钮
    QRadioButton *signInButton = [[QRadioButton alloc] initWithDelegate:self groupId:@"groupId"];
    signInButton.frame = CGRectMake(30, 35, 80, 30);
    [signInButton setTitle:[signStr objectAtIndex:0] forState:UIControlStateNormal];
    [signInButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [signInButton.titleLabel setFont:[UIFont boldSystemFontOfSize:15.0f]];
    [self.scrollView addSubview:signInButton];
    [signInButton setChecked:YES];
    //签退单选按钮
    QRadioButton *signOutButton = [[QRadioButton alloc] initWithDelegate:self groupId:@"groupId"];
    signOutButton.frame = CGRectMake(120, 35, 80, 30);
    [signOutButton setTitle:[signStr objectAtIndex:1] forState:UIControlStateNormal];
    [signOutButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [signOutButton.titleLabel setFont:[UIFont boldSystemFontOfSize:15.0f]];
    [self.scrollView addSubview:signOutButton];
    
    //对scrollView添加事件：关闭键盘
    UITapGestureRecognizer *keyDown=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(choiseKey)];
    [self.scrollView addGestureRecognizer:keyDown];
    self.scrollView.userInteractionEnabled=YES;
    //更新当前地址
    [self reLocation:nil];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

//关闭键盘
-(void)choiseKey{
    [markTextView resignFirstResponder];
}

//左上角返回事件
-(void)clickBack:(UITapGestureRecognizer *)gesture{
    [self.navigationController popViewControllerAnimated:YES];
}
//选择图片来源事件
-(void)choicePic{
    UIActionSheet *sheet=[[UIActionSheet alloc]initWithTitle:SHEET_PIC_SOURCE_TITLE delegate:self cancelButtonTitle:SHEET_PIC_SOURCE_CACEL destructiveButtonTitle:nil otherButtonTitles:SHEET_PIC_SOURCE_CAMERA,SHEET_PIC_SOURCE_PHOTO, nil];
    [sheet showInView:self.view];
}
//保存签到/签退
-(void)saveAttendance:(id)sender{
    NSString *description=markTextView.text;
    NSString *location=addressLabel.text;
    
    NSDictionary *userDic = [UtilTool getUserDic];
    NSDictionary *user = [[userDic objectForKey:@"user"] objectAtIndex:0];
    NSString *phone= [user objectForKey:@"id"];
    
    NSMutableString *json=[NSMutableString stringWithFormat:@"{'signType':%d,'userId':%@,'location':%@,'longitude':%lf,'latitude':%lf,'token':'%@'",signType,phone,location,longitude,latitude,[UtilTool getToken]];
    if([@"备注" isEqualToString:description]||[description stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length==0){
        [json appendFormat:@"%@",@"}"];
    }
    else
        [json appendFormat:@",'description':'%@'}",description];
    waitView =[[UIWaitView alloc]init:scrollView.frame];
    [scrollView addSubview:waitView];
    [waitView.aiv startAnimating];
    [self performSelector:@selector(saveAttence:) withObject:json afterDelay:0.5];
}

-(void)saveAttence:(NSString *)json{
    NSMutableString *url=[NSMutableString stringWithFormat:@"%@%@",[UtilTool getHostURL],@"manager/attendance/save?"];
    [url appendFormat:@"json=%@",json];
    NSNumber *state;
    json=[UtilTool sendUrlRequestByCache:url paramValue:nil method:HTTPRequestMethodPost isReload:YES status:&state];
    
    SBJsonParser *parser=[[SBJsonParser alloc]init];
    NSDictionary *dic =[parser objectWithString:json];
    
    if([[dic objectForKey:@"status"]intValue]==500){
        [UtilTool ShowAlertView:ALERT_WARN_TITLE setMsg:[dic objectForKey:@"msg"]];
    }else{
        [UtilTool ShowAlertView:ALERT_WARN_TITLE setMsg:ALERT_SAVE_SUCCESSMSG];
        if(isPic==1){
            [self sendImg:[[dic objectForKey:@"msg"]intValue] img:picImageView.image];
        }
        [self clickBack:nil];
    }
    [waitView.aiv stopAnimating];
    [waitView removeFromSuperview];
}
//获取当前地址
-(void)reLocation:(id)sender{
    NSString *location=nil;
    if([CLLocationManager locationServicesEnabled]){
        locationManager=[[CLLocationManager alloc]init];
        locationManager.desiredAccuracy=kCLLocationAccuracyBest;
        locationManager.distanceFilter=100.0f;
        locationManager.delegate = self;
        
        [locationManager startUpdatingLocation];
        CLLocationDegrees curLat=locationManager.location.coordinate.latitude;
        CLLocationDegrees curLng=locationManager.location.coordinate.longitude;
        
        longitude=106.7;
        latitude=29.6;
        if(curLat>0 && curLat >0){
            longitude=curLng;
            latitude=curLat;
        }
        location= [NSString stringWithFormat:@"{'longitude':%lf,'latitude':%lf,'token':'%@'}",longitude,latitude,[UtilTool getToken]];
    }
    waitView =[[UIWaitView alloc]initWithFrame:CGRectMake(100, 200, 200, 300)];
    [scrollView addSubview:waitView];
    [waitView.aiv startAnimating];
    [self performSelector:@selector(getAddress:) withObject:location afterDelay:0.5];
}
//得到地址数据
-(void)getAddress:(NSString *)location{
    NSMutableString *url=[NSMutableString stringWithFormat:@"%@%@",[UtilTool getHostURL],@"manager/attendance/location?"];
    [url appendFormat:@"json=%@",location];
    NSNumber *state;
    NSString *json=[UtilTool sendUrlRequestByCache:url paramValue:nil method:HTTPRequestMethodGet isReload:YES status:&state];
    
    SBJsonParser *parser=[[SBJsonParser alloc]init];
    NSDictionary *dic =[parser objectWithString:json];
    
    if([[dic objectForKey:@"status"]intValue]==500){
        [UtilTool ShowAlertView:ALERT_WARN_TITLE setMsg:[dic objectForKey:@"msg"]];
        addressLabel.text=LOCATION_ERRORMSG;
    }else{
        addressLabel.text=[dic objectForKey:@"msg"];
    }
    
    [waitView.aiv stopAnimating];
    [waitView removeFromSuperview];
}

//保存图片请求
-(void)sendImg:(int)attendanceId img:(UIImage *)image{
    NSMutableString *url = [[NSMutableString alloc] init];
    [url appendString:[UtilTool getHostURL]];
    [url appendString:@"manager/attendance/savePic"];
    
    NSString *TWITTERFON_FORM_BOUNDARY = @"AaB03x";
    //分界线 --AaB03x
    NSString *MPboundary=[[NSString alloc]initWithFormat:@"--%@",TWITTERFON_FORM_BOUNDARY];
    //结束符 AaB03x--
    NSString *endMPboundary=[[NSString alloc]initWithFormat:@"%@--",MPboundary];
    
    NSMutableString *body = [[NSMutableString alloc] init];
    
    [body appendFormat:@"%@\r\n",MPboundary];
    [body appendFormat:@"Content-Disposition: form-data;name=\"%@\"\r\n\r\n",@"attendanceId"];
    [body appendFormat:@"%d\r\n", attendanceId];
    
    [body appendFormat:@"%@\r\n",MPboundary];
    [body appendFormat:@"Content-Disposition: form-data;name=\"%@\"\r\n\r\n",@"json"];
    [body appendFormat:@"{'token':'%@'}\r\n", [UtilTool getToken]];
    
    NSData *imageData = UIImagePNGRepresentation([UtilTool changeImg:image max:1136]);
    
    //声明myRequestData，用来放入http body
    NSMutableData *myRequestData;
    //将body字符串转化为UTF8格式的二进制
    myRequestData=[NSMutableData data];
    
    [body appendFormat:@"%@\r\n",MPboundary];
    [body appendFormat:@"Content-Disposition: form-data; name=\"uploadFile\"; filename=\"%@\"\r\n",@"temp.png"];
    [body appendFormat:@"Content-Type: image/png\r\n\r\n"];
    [myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
    
    [myRequestData appendData:imageData];
    
    //声明结束符：--AaB03x--
    NSString *end=[[NSString alloc]initWithFormat:@"\r\n%@",endMPboundary];
    //加入结束符--AaB03x--
    [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: [NSURL URLWithString:url]];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    //    [request setTimeoutInterval:[DataStore getHttpTimeout]];
    [request setHTTPMethod:@"POST"];
    //设置HTTPHeader中Content-Type的值
    NSString *cttype=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY];
    //设置HTTPHeader
    [request setValue:cttype forHTTPHeaderField:@"Content-Type"];
    //设置Content-Length
    [request setValue:[NSString stringWithFormat:@"%ld", (unsigned long)[myRequestData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:myRequestData];
    NSError *error;
    NSURLResponse *response;
    NSData *data =  [NSURLConnection sendSynchronousRequest:request returningResponse:&response error: &error];


//    if(error){
//        NSLog(@"=====%@",error.description);
//    }
//
//    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//
//

}

//选择图片---------------代理开始-------------------
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate=self;
    if(buttonIndex==0){
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
             picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        }else{
            [UtilTool ShowAlertView:ALERT_WARN_TITLE setMsg:OPEN_CAMERA_ERRORMSG];
        }
        [self presentViewController:picker animated:YES completion:nil];
    }else if (buttonIndex==1){
        picker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:nil];
    }else{
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [UIApplication sharedApplication].statusBarHidden=NO;
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    NSString *mediaType=[info objectForKey:UIImagePickerControllerMediaType];
    if([mediaType isEqualToString:@"public.image"]){
        UIImage *image=[info objectForKey:UIImagePickerControllerOriginalImage];
        
        picImageView.image=[UtilTool changeImg:image max:1136];
        
        isPic=1;
        
        if(picker.sourceType == UIImagePickerControllerSourceTypeCamera)
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    }
}
//选择图片---------------代理结束-------------------
//文本框-----------------代理开始-------------------
-(void)textViewDidBeginEditing:(UITextView *)textView{
    [textView becomeFirstResponder];
    if([markMsg isEqualToString:textView.text])
        textView.text=@"";
}
-(void)textViewDidEndEditing:(UITextView *)textView{
    [textView resignFirstResponder];
    if(textView.text.length==0){
        textView.text=markMsg;
    }
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if([text isEqualToString:@"\n"]){
        [textView resignFirstResponder];
    }
    return YES;
}
//文本框-----------------代理结束-------------------

//单选按钮---------------代理开始-------------------
- (void)didSelectedRadioButton:(QRadioButton *)radio groupId:(NSString *)groupId {
    if([radio.titleLabel.text isEqualToString:[signStr objectAtIndex:0]])
        signType=0;
    else
        signType=1;
}
//单选按钮---------------代理结束-------------------
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    CLLocation *currentLocation = [locations lastObject];
    CLLocationCoordinate2D coor = currentLocation.coordinate;
//    NSLog(@"%f===%f",coor.latitude,coor.longitude);
}
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    if (error.code == kCLErrorDenied) {
//        NSLog(@"%@",error.description);
    }
}
@end
