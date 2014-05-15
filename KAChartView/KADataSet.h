//
//  KALine.h
//  KAChartView
//
//  Created by Kenneth Parker Ackerson on 12/13/13.
//  Copyright (c) 2013 Kenneth Parker Ackerson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KAChartViewTypes.h"
@interface KADataSet : NSObject

// designated initializer
- (instancetype)initWithValues:(NSArray *)values withColor:(KAColor *)color; // Set values and color in which the data will be display


/** @property color
 *   The data set's color (UIColor for iOS, NSColor for Mac OS X)
 */
@property (nonatomic, readonly, strong) KAColor *color;

/** @property values
 *   The array of values represented in the graph
 */
@property (nonatomic, readonly, strong) NSArray *values;

#pragma mark - KAChartViewTypeLine ONLY -

// KAChartViewTypeLine only

/** @property lineWidth
 *   The lines width
 */
@property (nonatomic, readonly) CGFloat lineWidth;

/** @property fillColor
 *   The fill color under the line (UIColor for iOS, NSColor for Mac OS X)
 */
@property (nonatomic, readonly, strong) KAColor *fillColor;

// Secondary initializers for KAChartViewTypeLine
- (instancetype)initWithValues:(NSArray *)values withColor:(KAColor *)color andFillColor:(KAColor *)fillColor; // Set values, line color, and fillColor of the line
- (instancetype)initWithValues:(NSArray *)values withColor:(KAColor *)color andLineWidth:(CGFloat)lineWidth; // Set values, line color, and lineWidth of the line
- (instancetype)initWithValues:(NSArray *)values withColor:(KAColor *)color andFillColor:(KAColor *)fillColor andLineWidth:(CGFloat)lineWidth; // Set values, line color, fillColor and lineWidth of the line


@end
