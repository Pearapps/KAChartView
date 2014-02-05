//
//  KAChartView.h
//  KAChartView
//
//  Created by Kenneth Parker Ackerson on 11/18/13.
//  Copyright (c) 2013 Kenneth Parker Ackerson. All rights reserved.
//



#import "KALine.h"
#import "KAChartViewTypes.h"

#define kBuffer 40 // space on each side to 'buffer' it
@interface KAChartView : KAView

/** @property doesDrawGrid
 *   Does draw grid?
*/
@property (nonatomic, assign) BOOL doesDrawGrid;

/** @property doesDrawAxisLines
 *   Does draw Axis lines?
 */
@property (nonatomic, assign) BOOL doesDrawAxisLines;

/** @property axisLineColor
 *   Color of axis lines
 */
@property (nonatomic, strong) KAColor * axisLineColor; // Color of axis lines

/** @property axisLabelAttributes
 *   Text attributes of axis labels
 */
@property (nonatomic, strong) NSDictionary * axisLabelAttributes; // Attributes to draw x axis labels

/** @property xAxisLabels
 *   X Axis labels (NSArray of strings)
 */
@property (nonatomic, strong) NSArray * xAxisLabels; // You can customize the labels on the x axis

/**
 * Add a line
 *
 * @param line Line object to add
 */
- (void)addLine:(KALine *)line;

/**
 * Remove a line
 *
 * @param line Line object to remove
 */
- (void)removeLine:(KALine *)line;

/**
 * Add Lines
 *
 *@param lines Array of KALines
 */

- (void)addLines:(NSArray *)lines;

/**
 * This allows you to simply add an array of NSNumbers (uses [UIColor greenColor] for line color) (I STRONGLY recomend using "- (void)addLine:(KALine *)line;")
 *
 * @param values Array of values
*/
- (void)addLineWithYValues:(NSArray *)values;


/**
 * Gets the image Representation
 *
 * @return The image (UIImage for iOS, NSImage for Mac OS X)
 */
- (KAImage *)imageRepresentation;

@end
