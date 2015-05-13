//
//  InSideMsgCell.h
//  Cancer
//
//  Created by Parsec on 14-10-31.
//  Copyright (c) 2014年 parsec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InSideMsgCell : UITableViewCell

@property(nonatomic,strong)IBOutlet UIImageView *iconImageView;

@property(nonatomic,strong)IBOutlet UILabel *titleLabel;

@property(nonatomic,strong)IBOutlet UILabel *instroLabel;

@property(nonatomic,strong)IBOutlet UILabel *timeLabel;

@end
