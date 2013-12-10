//
//  KAChartView.m
//  KAChartView
//
//  Created by Kenneth Parker Ackerson on 11/18/13.
//  Copyright (c) 2013 Kenneth Parker Ackerson. All rights reserved.
//

#import "KAChartView.h"
@interface KAChartView(){
    
}
@property (nonatomic, assign) NSRange xAxis;
@property (nonatomic, assign) CGFloat yAxis;
@end
@implementation KAChartView

- (void)dealloc{
    self.lineColor = nil;
    self.fillColor = nil;
    self.yValues = nil;
    self.axisLabelAttributes = nil;
    self.xAxisLabels = nil;
    self.axisLineColor = nil;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.doesDrawGrid = NO;
        self.doesDrawAxisLines = NO;
        [self setBackgroundColor:[UIColor clearColor]];
        self.lineColor = [UIColor greenColor];
        self.axisLabelAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:10], NSForegroundColorAttributeName: [UIColor lightGrayColor]};
        self.axisLineColor = [UIColor lightGrayColor];
    }
    return self;
}

#pragma mark - Setters

- (void)setLineColor:(UIColor *)lineColor{
    _lineColor = lineColor;
    [self setNeedsDisplay];
}
- (void)setFillColor:(UIColor *)fillColor{
    _fillColor = fillColor;
    [self setNeedsDisplay];
}

- (void)setDoesDrawAxisLines:(BOOL)doesDrawAxisLines{
    _doesDrawAxisLines = doesDrawAxisLines;
    [self setNeedsDisplay];
}
- (void)setDoesDrawGrid:(BOOL)doesDrawGrid{
    _doesDrawGrid = doesDrawGrid;
    [self setNeedsDisplay];
}

- (void)setAxisLineColor:(UIColor *)axisLineColor{
    _axisLineColor = axisLineColor;
    [self setNeedsDisplay];
}
- (void)setAxisLabelAttributes:(NSDictionary *)axisLabelAttributes{
    _axisLabelAttributes = axisLabelAttributes;
    [self setNeedsDisplay];
}

- (void)setXAxis:(NSRange)xAxis{
    _xAxis = xAxis;
}
- (void)setYAxis:(CGFloat)yAxis{
    _yAxis = yAxis;
}
- (void)setYValues:(NSArray *)points{
    _yValues = points;
    CGFloat maxY = -MAXFLOAT;
    for (NSNumber * numb in points){
        CGFloat y = [numb doubleValue];
        if (y > maxY){
            maxY = y;
        }
    }
    [self setXAxis:NSMakeRange(0, points.count)];
    [self setYAxis:(CGFloat)maxY];
    [self setNeedsDisplay];
}

#pragma mark -


static inline CGFloat rounded(CGFloat value){
    static const CGFloat preferred[10] = {1.25,  1.6,  2.0,  2.5,  3.15,  4.0,  5.0,  6.3,  8.0, 10.0};
    CGFloat mag = log10(value);
    CGFloat  power = pow(10,floor(mag));
    CGFloat msd = value/power;
    
    for (int i = 0; i < 10; i++){
        CGFloat h = preferred[i];
        if (h >= msd){
            return h * power;
        }
    }
    return 1 * power;
}
static inline CGFloat calculateAmountOfTicks(CGFloat heightOfView){ // 5 y labels per 200 points
    heightOfView -= 200;
    if (heightOfView <200){
        return 5;
    }else{
        NSInteger ticks = 5;
        while (heightOfView >= 200) {
            heightOfView -= 200;
            ticks+=5;
        }
        return ticks;
    }
}
- (void)drawRect:(CGRect)rect
{
    
    CGFloat numberOfXAxisTicks = (self.xAxis.length);
    
    
    
    CGFloat numberOfYAxisTicks = calculateAmountOfTicks(CGRectGetHeight(self.frame));
    
    CGFloat maxYValue = rounded(self.yAxis);
    
    CGFloat representativeValueOfYAxisPerTick = maxYValue/numberOfYAxisTicks;
    
    
    
    CGFloat distanceBetweenYAxisTicks = (self.frame.size.height - kBuffer*2)/(numberOfYAxisTicks);
    //NSLog(@"%f %f %f", maxYValue, representativeValueOfYAxisPerTick, distanceBetweenYAxisTicks);

    BOOL showsDecimals = NO;
    if (maxYValue <=numberOfXAxisTicks){
        showsDecimals = YES;
    }
    
    for (int i = 0; i < numberOfXAxisTicks; i++) {
        NSString *xValueAtIndex = nil;
        if (self.xAxisLabels){
            xValueAtIndex = self.xAxisLabels[i];
        }else{
            xValueAtIndex = [NSString stringWithFormat:@"%d", i];
        }
        CGPoint point = CGPointMake([self xFory:i], self.frame.size.height - kBuffer+8);
        
        [xValueAtIndex drawAtPoint:CGPointMake(point.x - [xValueAtIndex sizeWithAttributes:self.axisLabelAttributes].width/2, point.y) withAttributes:self.axisLabelAttributes];
    }
    
    for (int i = 0; i <= numberOfYAxisTicks; i++) {
        CGPoint point = CGPointMake(kBuffer , (self.frame.size.height - kBuffer) - (distanceBetweenYAxisTicks*i));
        CGFloat value = i*(CGFloat)representativeValueOfYAxisPerTick;
        NSString *intString = [NSString stringWithFormat:@"%0.0f", (CGFloat)value];
        if (showsDecimals){
            intString = [NSString stringWithFormat:@"%0.2f", i*(CGFloat)(representativeValueOfYAxisPerTick)];
        }
        
        CGSize sizeOfString = [intString sizeWithAttributes:self.axisLabelAttributes];
        [intString drawAtPoint:CGPointMake(point.x - sizeOfString.width - 8, point.y- [intString sizeWithAttributes:self.axisLabelAttributes].height/2) withAttributes:self.axisLabelAttributes];
        
    }
    
    
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    
    
    
    if (self.doesDrawAxisLines){
        CGContextMoveToPoint(context, kBuffer, kBuffer);
        CGContextSetStrokeColorWithColor(context, [self.axisLineColor CGColor]);
        CGContextSetLineWidth(context, 1.0);
        CGContextAddLineToPoint(context, kBuffer, self.frame.size.height - kBuffer);
        CGContextAddLineToPoint(context, self.frame.size.width - kBuffer, self.frame.size.height - kBuffer);
        CGContextDrawPath(context, kCGPathStroke);
    }
    
    CGContextSetStrokeColorWithColor(context, [self.lineColor CGColor]);
    CGContextSetLineWidth(context, 2.0);
    if (self.doesDrawGrid){
        
    }
    
    for (int i = 0; i < self.yValues.count; i++){
        CGPoint point = [self pointWithIndex:i andMaxValue:maxYValue];
        if (i == 0){
            CGContextMoveToPoint(context, point.x, point.y);
        }
        CGContextAddLineToPoint(context,point.x,point.y);
        
    }
    CGContextSetLineJoin(context, kCGLineJoinBevel);
    CGContextDrawPath(context, kCGPathStroke);
    
    if (self.fillColor){
        CGContextMoveToPoint(context, kBuffer, CGRectGetHeight(self.frame) - kBuffer);
        
        for (int i = 0; i < self.yValues.count; i++){
            CGPoint point = [self pointWithIndex:i andMaxValue:maxYValue];
            
            CGContextAddLineToPoint(context,point.x,point.y);
            
        }
        
        CGContextAddLineToPoint(context, [self xFory:self.yValues.count-1], CGRectGetHeight(self.frame)-kBuffer);
        
        CGContextSetFillColorWithColor(context, [[self fillColor] CGColor]);
        CGContextDrawPath(context, kCGPathFill);
    }
    
}
- (CGPoint)pointWithIndex:(NSInteger)i andMaxValue:(CGFloat)maxYValue{
    CGFloat yval = [(NSNumber *)self.yValues[i] doubleValue]/maxYValue;
    CGPoint point = [self pointForY:yval withI:i];
    return point;
}
- (CGPoint)pointForY:(CGFloat)y withI:(NSInteger)i{
    return CGPointMake(
                       [self xFory:i],
                       
                       (self.frame.size.height - kBuffer) - (y*(self.frame.size.height-kBuffer*2))
                       
                       );
}
- (CGFloat)xFory:(CGFloat)y{
    CGFloat widthAdjusted = CGRectGetWidth(self.frame) -( kBuffer*2);
    CGFloat perTick = (widthAdjusted/(CGFloat)(self.yValues.count-1));
    
    CGFloat amountOver = y*perTick;
    return kBuffer + amountOver;
    
}








@end
