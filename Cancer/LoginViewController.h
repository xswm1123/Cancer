//
//  LoginViewController.h
//  Cancer
//
//  Created by hu su on 14-10-15.
//  Copyright (c) 2014年 parsec. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UIWaitView;

@interface LoginViewController : UIViewController<UITextFieldDelegate>

//@property(nonatomic,strong)IBOutlet UIView *tabView;
//@property(nonatomic,strong)IBOutlet UIView *tab1;
//@property(nonatomic,strong)IBOutlet UIView *tab2;
@property (nonatomic, strong)NSArray *colorArray;

@property (nonatomic, strong) IBOutlet UITextField *txtMobile;
@property (nonatomic, strong) IBOutlet UITextField *txtPwd;
@property (nonatomic, strong) IBOutlet UIView *loginBut;
@property (nonatomic, strong) IBOutlet UIView *remenberView;
@property (nonatomic, strong) IBOutlet UIImageView *checkBoxImageView;
@property BOOL remenbered;
@property BOOL rememberPwd;
@property NSInteger curSelectedTabIndex;
@property(nonatomic, strong) UIWaitView *waitView ;
@property (nonatomic, strong) NSString *pwd;
@property (nonatomic, strong) IBOutlet UIView *remenberPwdView;
@property (nonatomic, strong) IBOutlet UIImageView *checkBoxRemember;
@property (nonatomic, strong) NSDictionary *userPwdDic;
@end
