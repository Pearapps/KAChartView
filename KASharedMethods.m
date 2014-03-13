//
//  KASharedMethods.m
//  KAChartView
//
//  Created by Kenneth Parker Ackerson on 1/12/14.
//  Copyright (c) 2014 Kenneth Parker Ackerson. All rights reserved.
//

#import "KASharedMethods.h"

@implementation KASharedMethods
+ (NSArray *)numberedMonthIDsWithMonth:(NSString *)string numberOfDays:(NSInteger)days{
    NSMutableArray * returnArray = [NSMutableArray array];
    for (NSInteger i = 0; i < days; i++){
        [returnArray addObject:[string stringByAppendingFormat:@" %ld", (long)(i+1)]];
    }
    return returnArray;
}
+ (NSArray *)generateRandomArrayOfLength:(int)length withNumbersBetween:(CGFloat)bottom andTop:(CGFloat)top{
    NSMutableArray * array = @[].mutableCopy;
    for(NSInteger i = 0; i < length; i++){
        array[i] = @(bottom + (arc4random_uniform((top - bottom))));
    }
    return array;
}
@end
