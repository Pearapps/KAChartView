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
- (instancetype)initWithValues:(NSArray *)values withLineColor:(KAColor *)color; // Set values and line color of the line

// secondary initializers
- (instancetype)initWithValues:(NSArray *)values withLineColor:(KAColor *)color andFillColor:(KAColor *)fillColor; // Set values, line color, and fillColor of the line
- (instancetype)initWithValues:(NSArray *)values withLineColor:(KAColor *)color andLineWidth:(CGFloat)lineWidth; // Set values, line color, and lineWidth of the line
- (instancetype)initWithValues:(NSArray *)values withLineColor:(KAColor *)color andFillColor:(KAColor *)fillColor andLineWidth:(CGFloat)lineWidth; // Set values, line color, fillColor and lineWidth of the line


/** @property color
 *   The lines color (UIColor for iOS, NSColor for Mac OS X)
 */
@property (nonatomic, readonly, strong) KAColor *color;

/** @property values
 *   The array of values represented by the line
 */
@property (nonatomic, readonly, strong) NSArray *values;

#pragma mark - KAChartViewTypeLine ONLY -

/** @property lineWidth
 *   The lines width
 */
@property (nonatomic, readonly) CGFloat lineWidth;

/** @property fillColor
 *   The fill color under the line (UIColor for iOS, NSColor for Mac OS X)
 */
@property (nonatomic, readonly, strong) KAColor *fillColor;


@end
