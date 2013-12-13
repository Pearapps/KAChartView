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
- (instancetype)initWithValues:(NSArray *)values withColor:(UIColor *)color{
    return [self initWithValues:values withColor:color andFillColor:nil];
}
- (instancetype)initWithValues:(NSArray *)values withColor:(UIColor *)color andFillColor:(UIColor *)fillColor{
    return [self initWithValues:values withColor:color andFillColor:fillColor andLineWidth:2.0];
}
- (instancetype)initWithValues:(NSArray *)values withColor:(UIColor *)color andLineWidth:(CGFloat)lineWidth{
    return [self initWithValues:values withColor:color andFillColor:nil andLineWidth:lineWidth];
}
- (instancetype)initWithValues:(NSArray *)values withColor:(UIColor *)color andFillColor:(UIColor *)fillColor andLineWidth:(CGFloat)lineWidth{
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
