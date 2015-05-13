//
//  FirstPageCellHeaderView.h
//  Cancer
//
//  Created by hu su on 14/10/24.
//  Copyright (c) 2014年 parsec. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FirstPageCellHeaderView : UIView

@property(nonatomic,strong) IBOutlet UIImageView *leftImageView;
@property(nonatomic,strong) IBOutlet UIImageView *rightImageView;
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;


@property (nonatomic, strong) IBOutlet NSLayoutConstraint *leftMarginConstraint;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *lineleftMarginConstraint;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *rightMarginConstraint;



@end
