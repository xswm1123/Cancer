//
//  Cancer
//
//  Created by zpj on 14-10-28.
//  Copyright (c) 2014年 parsec. All rights reserved.
//

#import "WorkReportTableCell.h"

UIImage *unread;
UIImage *readed;
BOOL    initizal = YES;

@implementation WorkReportTableCell

@synthesize recvTime;
@synthesize title;
@synthesize content;
@synthesize readMark;
@synthesize userName;

//-(id)init
//{
//    self = [super init];
//    unread = [UIImage imageNamed:@"email_unread"];
//    readed = [UIImage imageNamed:@"email_read"];
//    return self;
//}



-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    unread = [UIImage imageNamed:@"email_unread"];
    readed = [UIImage imageNamed:@"email_read"];
    return self;
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        if (initizal) {
            initizal = NO;
        }
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)displayData:(NSDictionary *)dict
{
    recvTime.text = [dict objectForKey:@"showCreateDate"];

    title.text = [dict objectForKey:@"title"];

    content.text = [dict objectForKey:@"content"];
    
    userName.text = [dict objectForKey:@"userName"];
    
    NSNumber *isRead = [dict objectForKey:@"readMark"];
    
    if ([dict objectForKey:@"readMark"] == [NSNull null] ){
        readMark.image = unread;
    }else{
        if( isRead.intValue == 1){
            readMark.image = readed;
        }else{
            readMark.image = unread;
        }
    }
}
@end

