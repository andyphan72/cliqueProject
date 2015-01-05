//
//  DataClass.m
//  testSingleton
//
//  Created by Meng Cheong on 6/17/13.
//  Copyright (c) 2013 Meng Cheong. All rights reserved.
//


#import "DataClass.h"
#import "FMDatabase.h"

@implementation DataClass

@synthesize str, status;
@synthesize companyData;

static DataClass *instance =nil;
static dispatch_once_t oncePredicate;


+(DataClass *)getInstance
{
    /*//old method start
    @synchronized(self)
    {
        if(instance==nil)
        {
            
            instance= [DataClass new];
        }
    return instance;
    }
    *///old method end
    
    
    dispatch_once(&oncePredicate, ^{
        instance= [DataClass new];
    });
    return instance;
    
}

-(void) logger{
    NSLog(@"This is a logger function");
}
@end
