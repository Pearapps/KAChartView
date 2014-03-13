//
//  KAAppDelegate.m
//  KAChartViewMac
//
//  Created by Kenneth Parker Ackerson on 1/12/14.
//  Copyright (c) 2014 Kenneth Parker Ackerson. All rights reserved.
//

#import "KAAppDelegate.h"
#import "KADataSet.h"
@implementation KAAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    KAChartView * middle = [[KAChartView alloc] initWithFrame:CGRectMake(0, 0, 700, 300) andType:KAChartViewTypeBar];

    KADataSet *line = [[KADataSet alloc] initWithValues:[self generateRandomArrayOfLength:50 withNumbersBetween:0 andTop:50] withLineColor:[KAColor redColor] andFillColor:[KAColor colorWithRed:1.0 green:0 blue:0.0 alpha:0.15]];
   // KALine *aline = [[KALine alloc] initWithValues:[self generateRandomArrayOfLength:50 withNumbersBetween:0 andTop:50] withLineColor:[KAColor greenColor] andFillColor:nil];
    
    [middle addDataSets:@[line]];
    middle.axisLabelAttributes = @{NSFontAttributeName: [KAFont systemFontOfSize:10], NSForegroundColorAttributeName: [KAColor blackColor]};
    [middle setXAxisLabels:[self createBlankStringArrayOfLength:50]];
    [middle setDoesDrawAxisLines:YES];
    
    [self.window.contentView addSubview:middle];
    [middle setFrameOrigin:NSMakePoint(self.window.frame.size.width/4, self.window.frame.size.height/4)];
    
}

- (NSArray *)createBlankStringArrayOfLength:(NSInteger)length {
    NSMutableArray * returnArray = [NSMutableArray array];
    for (NSInteger i = 0; i < length; i++){
        [returnArray addObject:@""];
    }
    return returnArray;
}

- (NSArray *)numberedMonthIDsWithMonth:(NSString *)string numberOfDays:(NSInteger)days {
    NSMutableArray * returnArray = [NSMutableArray array];
    for (NSInteger i = 0; i < days; i++){
        [returnArray addObject:[string stringByAppendingFormat:@" %ld", (long)(i+1)]];
    }
    return returnArray;
}
- (NSArray *)generateRandomArrayOfLength:(int)length withNumbersBetween:(CGFloat)bottom andTop:(CGFloat)top {
    NSMutableArray * array = @[].mutableCopy;
    for(NSInteger i = 0; i < length; i++){
        array[i] = @(bottom + (NSInteger)(arc4random_uniform((top - bottom))));
    }
    return array;
}

@end
