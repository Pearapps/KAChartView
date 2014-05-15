//
//  KAChartView.h
//  KAChartView
//
//  Created by Kenneth Parker Ackerson on 11/18/13.
//  Copyright (c) 2013 Kenneth Parker Ackerson. All rights reserved.
//

typedef NS_ENUM(NSUInteger, KAChartViewType) {
    KAChartViewTypeLine,
    KAChartViewTypeBar
};

#import "KADataSet.h"
#import "KAChartViewTypes.h"

#define kBufferValue 40 // space on each side to 'buffer' it
@interface KAChartView : KAView

- (instancetype)initWithFrame:(CGRect)frame andType:(KAChartViewType)type;

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

@property (nonatomic, readonly) KAChartViewType type;

/**
 * Add a KADataSet
 *
 * @param dataSet KADataSet object to add
 */
- (void)addDataSet:(KADataSet *)dataSet;

/**
 * Remove a KADataSet
 *
 * @param dataSet KADataSet object to remove
 */
- (void)removeDataSet:(KADataSet *)dataSet;

/**
 * Add KADataSet's
 *
 *@param dataSets Array of KADataSets
 */

- (void)addDataSets:(NSArray *)dataSets;

/**
 * This allows you to simply add an array of NSNumbers (uses [UIColor greenColor] for line color) (I STRONGLY recomend using "- (void)addLine:(KADataSet * *)line;")
 *
 * @param values Array of values
*/
- (void)addDataSetWithYValues:(NSArray *)values;


/**
 * Gets the image Representation
 *
 * @return The image (UIImage for iOS, NSImage for Mac OS X)
 */
- (KAImage *)imageRepresentation;

@end
