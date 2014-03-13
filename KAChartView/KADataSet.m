//
//  KALine.m
//  KAChartView
//
//  Created by Kenneth Parker Ackerson on 12/13/13.
//  Copyright (c) 2013 Kenneth Parker Ackerson. All rights reserved.
//

#import "KADataSet.h"
@interface KADataSet ()
@end
@implementation KADataSet
- (instancetype)initWithValues:(NSArray *)values withLineColor:(KAColor *)color{
    return [self initWithValues:values withLineColor:color andFillColor:nil];
}
- (instancetype)initWithValues:(NSArray *)values withLineColor:(KAColor *)color andFillColor:(KAColor *)fillColor{
    return [self initWithValues:values withLineColor:color andFillColor:fillColor andLineWidth:2.0];
}
- (instancetype)initWithValues:(NSArray *)values withLineColor:(KAColor *)color andLineWidth:(CGFloat)lineWidth{
    return [self initWithValues:values withLineColor:color andFillColor:nil andLineWidth:lineWidth];
}
- (instancetype)initWithValues:(NSArray *)values withLineColor:(KAColor *)color andFillColor:(KAColor *)fillColor andLineWidth:(CGFloat)lineWidth{
    if (self = [super init]){
        _values = values;
        _color = color;
        _fillColor = fillColor;
        _lineWidth = lineWidth;
    }
    return self;
}
- (void)dealloc{
    _values = nil;
    _color = nil;
    _fillColor = nil;
}
@end
