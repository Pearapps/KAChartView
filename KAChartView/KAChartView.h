//
//  KAChartView.h
//  KAChartView
//
//  Created by Kenneth Parker Ackerson on 11/18/13.
//  Copyright (c) 2013 Kenneth Parker Ackerson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KALine.h"
#define kBuffer 40 // space on each side to 'buffer' it
@interface KAChartView : UIView


@property (nonatomic, assign) BOOL doesDrawGrid; // NOT FUNCTIONAL

@property (nonatomic, assign) BOOL doesDrawAxisLines; // draw the x and y axis?

@property (nonatomic, strong) UIColor * axisLineColor; // color of axis lines

@property (nonatomic, strong) NSDictionary * axisLabelAttributes; // attributes to draw x axis labels

@property (nonatomic, strong) NSArray * xAxisLabels; // you can customize the labels on the x axis

- (void)addLine:(KALine *)line; // add a line object to the graph (values, color, fill color)
- (void)removeLine:(KALine *)line;



- (void)addLineWithYValues:(NSArray *)values; // this allows you to simply add an array of NSNumbers (uses [UIColor greenColor] for line color) (I STRONGLY recomend using "- (void)addLine:(KALine *)line;")

@end
