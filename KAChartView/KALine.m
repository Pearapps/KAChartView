//
//  KALine.m
//  KAChartView
//
//  Created by Kenneth Parker Ackerson on 12/13/13.
//  Copyright (c) 2013 Kenneth Parker Ackerson. All rights reserved.
//

#import "KALine.h"
@interface KALine ()
@end
@implementation KALine
- (instancetype)initWithValues:(NSArray *)values withLineColor:(UIColor *)color{
    return [self initWithValues:values withLineColor:color andFillColor:nil];
}
- (instancetype)initWithValues:(NSArray *)values withLineColor:(UIColor *)color andFillColor:(UIColor *)fillColor{
    return [self initWithValues:values withLineColor:color andFillColor:fillColor andLineWidth:2.0];
}
- (instancetype)initWithValues:(NSArray *)values withLineColor:(UIColor *)color andLineWidth:(CGFloat)lineWidth{
    return [self initWithValues:values withLineColor:color andFillColor:nil andLineWidth:lineWidth];
}
- (instancetype)initWithValues:(NSArray *)values withLineColor:(UIColor *)color andFillColor:(UIColor *)fillColor andLineWidth:(CGFloat)lineWidth{
    if (self = [super init]){
        _values = values;
        _lineColor = color;
        _fillColor = fillColor;
        _lineWidth = lineWidth;
    }
    return self;
}
- (void)dealloc{
    _values = nil;
    _lineColor = nil;
    _fillColor = nil;
}
@end
