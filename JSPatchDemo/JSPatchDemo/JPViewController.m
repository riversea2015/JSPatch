//
//  JPViewController.m
//  JSPatch
//
//  Created by bang on 15/5/2.
//  Copyright (c) 2015年 bang. All rights reserved.
//

#import "JPViewController.h"
#import <objc/runtime.h>
#import "MultithreadTestObject.h"
#import "JPEngine.h"

void thread(void* context)
{
    /*[JPEngine startEngine];
    NSString *sourcePath = [[NSBundle mainBundle] pathForResource:@"demo" ofType:@"js"];
    NSString *script = [NSString stringWithContentsOfFile:sourcePath encoding:NSUTF8StringEncoding error:nil];
    [JPEngine evaluateScript:script];
    */
    MultithreadTestObject *obj = (__bridge MultithreadTestObject*)context;
    for (int i = 0; i < 1000; i++) {
        [obj addValue:[NSNumber numberWithInt:obj.objectId]];
    }
    
    if (![obj checkAllValues]) {
        NSLog(@"found wrong data in object %d", obj.objectId);
    }
    else
    {
        NSLog(@"obj %d ok", obj.objectId);
    }
}

@implementation JPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 50)];
    [btn setTitle:@"Push JPTableViewController" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(handleBtn:) forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundColor:[UIColor grayColor]];
    [self.view addSubview:btn];
    
    btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 200, [UIScreen mainScreen].bounds.size.width, 50)];
    [btn setTitle:@"Multi thread test" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(testMultiThread:) forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundColor:[UIColor grayColor]];
    [self.view addSubview:btn];
}

- (void)handleBtn:(id)sender
{
}

- (void)testMultiThread:(id)sender
{
    objs = [[NSMutableArray alloc] init];
    for (int i = 0; i < 1000; i++) {
        MultithreadTestObject *obj = [[MultithreadTestObject alloc] init];
        obj.objectId = i;
        [objs addObject:obj];
    }
    
    //dispatch_queue_t q = dispatch_get_main_queue();
    //dispatch_queue_t q = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,0);
    dispatch_queue_t q = dispatch_queue_create("my queue", DISPATCH_QUEUE_SERIAL);
    //dispatch_queue_t q = dispatch_queue_create("my queue", DISPATCH_QUEUE_CONCURRENT);
    for (int i = 0; i < 1000; i++) {
        dispatch_async_f(q, (__bridge void*)[objs objectAtIndex:i], thread);
    }
}

@end


