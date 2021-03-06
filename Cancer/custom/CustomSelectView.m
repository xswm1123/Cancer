//
// Created by hu su on 14-6-18.
// Copyright (c) 2014 parsec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomSelectView.h"
#import "UtilTool.h"
#import "CustomSelectViewDelegate.h"


@implementation CustomSelectView {

}
@synthesize contentView = _contentView;
@synthesize customDelegate = _customDelegate;
@synthesize lineView = _lineView;
const CGFloat fontSize = 14.0f;
const CGFloat fontSizeiPad = 18.0f;
BOOL firstLoad1  = YES;
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initContentView];

    }

    return self;
}

-(id)init {
    firstLoad1 = YES;
    [self initContentView];
    return [super init];
}

-(void)drawRect:(CGRect)rect {
    if(firstLoad1){
        firstLoad1 = NO;
        
    }

[self initContentView];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];

    if(self){
//        [self initContentView];
    }
    return self;
}

-(void)initContentView{

    self.contentView = [[UIView alloc] init];



    float totalLabelWidth=0.0;


    int labelCount = (int)[self.customDelegate getLabelCount:self];

    if(labelCount<1){
        return;
    }




    /**
      * 将标签们加入到滚动视图当中去
      */

    CGFloat curX = 10.0;






    CGFloat defaultLineWidth=55;

    for(int i=0;i<labelCount;i++){

        NSString *string = [self.customDelegate getLabelName:i SelectView:self];

        CGFloat curWidth = [self getTextWidth:string];

        if(i==0){
            defaultLineWidth = curWidth;
        }


        totalLabelWidth += curWidth + 20;

        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(curX, 0, curWidth , 30.0)];




        label.text = string;
        label.userInteractionEnabled = YES;
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor grayColor];


        if(i==0){
            label.textColor =  [UtilTool colorWithHexString:@"#16b7e5"];
        }
        
        CGFloat txtFontSize = (CGFloat)round(fontSize * (self.frame.size.width/320.0));

      
        label.font =[UIFont systemFontOfSize:txtFontSize];

        
        label.tag = i ;
        label.hidden = NO;
        curX += curWidth +10;


        UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapItem:)];
        gestureRecognizer.numberOfTapsRequired = 1;

        [label addGestureRecognizer:gestureRecognizer];
        [self.contentView addSubview:label];



    }

    self.lineView = [[UIView alloc] initWithFrame:CGRectMake(10, 28, defaultLineWidth, 2)];
    self.lineView.backgroundColor =[UtilTool colorWithHexString:@"#f668b2"];


    self.contentView.frame = CGRectMake(0.0, 0.0, totalLabelWidth,self.frame.size.height);
       self.contentView.tag = 1001;
       self.contentSize = CGSizeMake(totalLabelWidth, self.frame.size.height);
       self.contentView.backgroundColor = [UIColor clearColor];
       self.contentInset = UIEdgeInsetsZero;

     [self.contentView addSubview:self.lineView];

       [self addSubview:self.contentView];

}


-(CGFloat)getTextWidth:(NSString *)text{
    CGSize maxSize = CGSizeMake(320, 0);

    CGFloat curSize = (CGFloat)round(fontSize * (self.frame.size.width/320.0));
    
    
//    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:curSize] constrainedToSize:maxSize lineBreakMode:NSLineBreakByCharWrapping];

    
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:curSize]};
    CGSize sizeRect = [text boundingRectWithSize:maxSize options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;

    return sizeRect.width;
}

-(void)tapItem:(UITapGestureRecognizer *)gestureRecognizers {
    NSInteger index = gestureRecognizers.view.tag;

    for(UIView *view in self.contentView.subviews){
        if([view isKindOfClass:[UILabel class]]){
           UILabel *label = (UILabel *)view;
            label.textColor = [UIColor grayColor];
        }

    }

    [self.customDelegate selectTab:index selectView:self];

    UILabel *curLabel = (UILabel *)gestureRecognizers.view;
    curLabel.textColor = [UtilTool colorWithHexString:@"#16b7e5"];

    CGFloat  curLineWidth =[self getTextWidth:curLabel.text];


    [UIView beginAnimations:nil context:nil];

    self.lineView.frame = CGRectMake(curLabel.frame.origin.x, 28, curLineWidth, 2);


    [UIView setAnimationDuration:0.2];
    [UIView commitAnimations];
}


- (void)reload {


    [self initContentView];
    [self selectIndex:0];
}

- (void)selectIndex:(NSInteger)index1 {


    UILabel *curLabel;

    for(UIView *view in self.contentView.subviews){
        if([view isKindOfClass:[UILabel class]]){
            UILabel *label = (UILabel *)view;
            label.textColor = [UIColor grayColor];
            if(label.tag == index1){
                curLabel = label;
            }
        }

    }



    curLabel.textColor = [UtilTool colorWithHexString:@"#16b7e5"];

    [self.customDelegate selectTab:index1 selectView:self];
}

@end