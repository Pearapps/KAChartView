//
//  KALine.h
//  KAChartView
//
//  Created by Kenneth Parker Ackerson on 12/13/13.
//  Copyright (c) 2013 Kenneth Parker Ackerson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KALine : NSObject

- (instancetype)initWithValues:(NSArray *)values withColor:(UIColor *)color andFillColor:(UIColor *)fillColor andLineWidth:(CGFloat)lineWidth;


- (instancetype)initWithValues:(NSArray *)values withColor:(UIColor *)color andFillColor:(UIColor *)fillColor;
- (instancetype)initWithValues:(NSArray *)values withColor:(UIColor *)color andLineWidth:(CGFloat)lineWidth;


- (instancetype)initWithValues:(NSArray *)values withColor:(UIColor *)color;


@property (nonatomic, readonly) CGFloat lineWidth;
@property (nonatomic, readonly) UIColor *color;
@property (nonatomic, readonly) UIColor *fillColor;
@property (nonatomic, readonly) NSArray *values;


@end
