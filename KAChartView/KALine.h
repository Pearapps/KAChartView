//
//  KALine.h
//  KAChartView
//
//  Created by Kenneth Parker Ackerson on 12/13/13.
//  Copyright (c) 2013 Kenneth Parker Ackerson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KAChartViewTypes.h"
@interface KALine : NSObject

// designated initializer
- (instancetype)initWithValues:(NSArray *)values withLineColor:(KAColor *)color andFillColor:(KAColor *)fillColor andLineWidth:(CGFloat)lineWidth; // Set values, line color, fillColor and lineWidth of the line


// secondary initializers
- (instancetype)initWithValues:(NSArray *)values withLineColor:(KAColor *)color andFillColor:(KAColor *)fillColor; // Set values, line color, and fillColor of the line
- (instancetype)initWithValues:(NSArray *)values withLineColor:(KAColor *)color andLineWidth:(CGFloat)lineWidth; // Set values, line color, and lineWidth of the line
- (instancetype)initWithValues:(NSArray *)values withLineColor:(KAColor *)color; // Set values and line color of the line


@property (nonatomic, readonly) CGFloat lineWidth; // The line's width
@property (nonatomic, readonly, strong) KAColor *lineColor; // The line's color
@property (nonatomic, readonly, strong) NSArray *values;

@property (nonatomic, readonly, strong) KAColor *fillColor; // The line's fill color (Important) **This fills all the space under the line NOT the actual line**


@end
