//
//  AttenceViewController.h
//  Cancer
//
//  Created by Parsec on 14-10-28.
//  Copyright (c) 2014年 parsec. All rights reserved.
//

#import "CommonViewController.h"
#import <CoreLocation/CoreLocation.h>

#import "UIWaitView.h"

@class CLLocationManager;

@interface AttenceViewController : CommonViewController<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate,CLLocationManagerDelegate>{
    CLLocationManager *locationManager;
}

@property(nonatomic,strong)IBOutlet UITextView *markTextView;

@property(nonatomic,strong)IBOutlet UILabel *addressLabel;

@property(nonatomic,strong)IBOutlet UIImageView *picImageView;

@property(nonatomic,strong)IBOutlet UIScrollView *scrollView;

@property(nonatomic,strong)UIWaitView *waitView;

-(IBAction)reLocation:(id)sender;

-(IBAction)saveAttendance :(id)sender;

@end
