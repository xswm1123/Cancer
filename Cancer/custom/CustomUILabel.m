//
//  CustomUILabel.m
//  cplus
//
//  Created by hsyouyou on 13-5-7.
//  Copyright (c) 2013年 parsec. All rights reserved.
//

#import "CustomUILabel.h"
#import "UtilTool.h"

@implementation CustomUILabel{

}


@synthesize heightLayout = _heightLayout;
@synthesize widthLayout = _widthLayout;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


-(void)setLabelText:(NSString *)text fontSize:(CGFloat)fontSize{
    CGRect old = self.frame;
    CGSize maxSize = CGSizeMake(self.frame.size.width, 800);
    

    NSDictionary *attribute = @{NSFontAttributeName: [UtilTool currentSystemFont:fontSize]};

    CGSize size = [text boundingRectWithSize:maxSize options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;

    
    self.frame = CGRectMake(old.origin.x,old.origin.y, old.size.width, size.height);
    self.text = text;
    self.font = [UIFont fontWithName:AppFontName size:fontSize];
    self.lineBreakMode = NSLineBreakByCharWrapping;
    self.numberOfLines= 0;

    self.heightLayout.constant = size.height;
    self.widthLayout.constant = size.width;


}

- (void)setLabelText:(NSString *)text maxHeight:(CGFloat)height fontSize:(CGFloat)fontSize {
    CGRect old = self.frame;
    CGSize maxSize = CGSizeMake(self.frame.size.width, 200);

//    CGSize size = [text sizeWithFont:[UIFont fontWithName:AppFontName size:fontSize] constrainedToSize:maxSize lineBreakMode:NSLineBreakByCharWrapping];

    NSDictionary *attribute = @{NSFontAttributeName: [UtilTool currentSystemFont:fontSize]};

    CGSize size = [text boundingRectWithSize:maxSize options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;


CGFloat curHeight = size.height;
    if(curHeight>height){
        curHeight = height;
    }


    self.frame = CGRectMake(old.origin.x,old.origin.y, old.size.width,curHeight);
    self.text = text;
    self.font = [UIFont fontWithName:AppFontName size:fontSize];
    self.lineBreakMode = NSLineBreakByCharWrapping;
    self.numberOfLines= 0;

    self.heightLayout.constant = curHeight;
    self.widthLayout.constant = size.width;
}


@end
