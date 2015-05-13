//
// Created by hu su on 14/11/1.
// Copyright (c) 2014 parsec. All rights reserved.
//

#import "Stack.h"


@implementation Stack {

}


- (instancetype)init {
    self = [super init];
    if (self) {
       stackArray = [[NSMutableArray alloc] init];

    }
    return self;
}


- (id)pop {
    if(stackArray && [stackArray count]>0){
        id popObj;
        popObj = stackArray[[stackArray count] - 1];
        [stackArray removeLastObject];
        return popObj;
    }
    return nil;
}

- (void)push:(id)object {
    [stackArray addObject:object];
}

@end