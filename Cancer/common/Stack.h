//
// Created by hu su on 14/11/1.
// Copyright (c) 2014 parsec. All rights reserved.
//

#import <Foundation/Foundation.h>

//实现栈的基本功能

@interface Stack : NSObject{
    NSMutableArray *stackArray;
}

//将一个对象弹出栈顶，如果栈已到底，则弹出nil
-(id)pop;

-(void)push:(id)object;


@end