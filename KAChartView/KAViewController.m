//
//  KAViewController.m
//  KAChartView
//
//  Created by Kenneth Parker Ackerson on 11/18/13.
//  Copyright (c) 2013 Kenneth Parker Ackerson. All rights reserved.
//

#import "KAViewController.h"

@interface KAViewController ()

@end

@implementation KAViewController

- (void)viewDidLoad
{
    
    UIScrollView * scroll = [[UIScrollView alloc] initWithFrame:self.view.frame];
    NSMutableArray * charts = [[NSMutableArray alloc] init];
    [self.view addSubview:scroll];
    
    KAChartView * first = [[KAChartView alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
    [first setYValues:[self randomizedPoints:[self generateRandomArrayOfLength:7 withNumbersBetween:0 andTop:200]]];
    first.axisLabelAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:10], NSForegroundColorAttributeName: [UIColor lightGrayColor]};
    [first setLineColor:[UIColor greenColor]];
    [first setFillColor:[UIColor colorWithRed:0 green:1.0 blue:0.0 alpha:0.1]];
    [first setDoesDrawAxisLines:YES];
    
    
    KAChartView * middle = [[KAChartView alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
    [middle setYValues:[self randomizedPoints:[self generateRandomArrayOfLength:7 withNumbersBetween:0 andTop:200]]];
    middle.axisLabelAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:10], NSForegroundColorAttributeName: [UIColor yellowColor]};
    [middle setLineColor:[UIColor redColor]];
    [middle setFillColor:[UIColor colorWithRed:1.0 green:0 blue:0.0 alpha:0.15]];
    [middle setXAxisLabels:[self numberedMonthIDsWithMonth:@"Sep" numberOfDays:7]];
    [middle setDoesDrawAxisLines:YES];
    
    KAChartView * next = [[KAChartView alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
    [next setYValues:[self randomizedPoints:[self generateRandomArrayOfLength:17 withNumbersBetween:0 andTop:20000]]];
    next.axisLabelAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:10], NSForegroundColorAttributeName: [UIColor lightGrayColor]};
   
    
    KAChartView * lowest = [[KAChartView alloc] initWithFrame:CGRectMake(0, 0, 320, 400)];
    [lowest setYValues:[self randomizedPoints:[self generateRandomArrayOfLength:8 withNumbersBetween:10 andTop:10000]]];
    [lowest setDoesDrawAxisLines:YES];
    [lowest setAxisLineColor:[UIColor colorWithRed:0.2 green:0.4 blue:0.1 alpha:0.7]];
    [lowest setLineColor:[UIColor blueColor]];
    
    [charts addObject:first];
    [charts addObject:middle];
    [charts addObject:next];
    [charts addObject:lowest];

    
    
    
    __block CGFloat curY = 0;
    [charts enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        KAChartView * chart = (KAChartView *)obj;
        [scroll addSubview:chart];
        curY += chart.frame.size.height;
        [chart setCenter:CGPointMake(CGRectGetWidth([[UIScreen mainScreen] bounds])/2, curY-(CGRectGetHeight(chart.frame)+kBuffer)/2)];  // take into account the buffer
        
    }];
    
    [scroll setContentSize:CGSizeMake([[UIScreen mainScreen] bounds].size.width, curY)];

    
    
    [self.view setBackgroundColor:[UIColor blackColor]];
    
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    }
    [super viewDidLoad];
}
- (NSArray *)numberedMonthIDsWithMonth:(NSString *)string numberOfDays:(NSInteger)days{
    NSMutableArray * returnArray = [NSMutableArray array];
    for (NSInteger i = 0; i < days; i++){
        [returnArray addObject:[string stringByAppendingFormat:@" %ld", (long)(i+1)]];
    }
    return returnArray;
}


- (NSArray *)generateRandomArrayOfLength:(int)length withNumbersBetween:(CGFloat)bottom andTop:(CGFloat)top{
    NSMutableArray * array = @[].mutableCopy;
    for(NSInteger i = 0; i < length; i++){
        array[i] = @(bottom + (arc4random_uniform((NSInteger)(top - bottom))));
    }
    return array;
}
-(NSArray *)pointsForChartView{
    return @[@(11.0),@(0.0),@(0),@(20),@(0),@(0),@(0)];
}
- (NSArray *)randomizedPoints:(NSArray *)arrayToRandimize{
    NSMutableArray * newArray = @[].mutableCopy;
    NSMutableArray * oldArray = arrayToRandimize.mutableCopy;
    while (oldArray.count > 0) {
        id obj = oldArray[arc4random() % oldArray.count];
        [newArray addObject:obj];
        [oldArray removeObject:obj];
    }
    return newArray;
}
- (BOOL)prefersStatusBarHidden
{
    return YES;
}


@end
