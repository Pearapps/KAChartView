//
//  KAChartView.m
//  KAChartView
//
//  Created by Kenneth Parker Ackerson on 11/18/13.
//  Copyright (c) 2013 Kenneth Parker Ackerson. All rights reserved.
//

#import "KAChartView.h"
@interface KAChartView(){
    CGFloat maxY;

}
@property (nonatomic, assign) NSRange xAxis;
@property (nonatomic, strong) NSMutableArray * lines; // 2d array of y values [ [firstlinevalues], [secondlinevalues] ]

@end
@implementation KAChartView

- (void)dealloc{
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
        self.axisLabelAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:10], NSForegroundColorAttributeName: [UIColor lightGrayColor]};
        self.axisLineColor = [UIColor lightGrayColor];
        
        self.lines = [[NSMutableArray alloc] init];
        
        maxY = -MAXFLOAT;
    }
    return self;
}

#pragma mark - Setters

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
    [self setNeedsDisplay];
}
#pragma mark -
#pragma mark - Managing KALine(s)

- (void)recalculateMaxY{
    maxY = -MAXFLOAT;
    for (KALine *line in self.lines){
        for (NSNumber * numb in line.values){
            CGFloat y = [numb doubleValue];
            if (y > maxY){
                maxY = y;
            }
        }
    }
}

- (void)removeLine:(KALine *)line{
    [self.lines removeObject:line];
    if (self.lines.count == 0){
        maxY = -MAXFLOAT;
        [self setXAxis:NSMakeRange(0, 0)];
    }else{
        [self recalculateMaxY];
        // no need to recalculate xaxis if there is lines in the array, they should all have the same amount of values
    }
}
- (void)addLine:(KALine *)line{
    
    if (self.lines.count > 0){
        NSAssert((line.values.count == self.xAxis.length), @"Invalid additional line - different amount of values.");
    }else{
        [self setXAxis:NSMakeRange(0, line.values.count)];
    }
    [self.lines addObject:line];
    for (NSNumber * numb in line.values){
        CGFloat y = [numb doubleValue];
        if (y > maxY){
            maxY = y;
        }
    }
    [self setNeedsDisplay];
}
- (void)addLineWithYValues:(NSArray *)values{
    [self addLine:[[KALine alloc] initWithValues:values withColor:[UIColor greenColor] andFillColor:nil]];
}


#pragma mark -
#pragma mark - Math C Functions


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
    if (heightOfView < 200){
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
#pragma mark -

- (void)drawRect:(CGRect)rect
{
    
    if (self.lines.count == 0){
        return;
    }
    
    CGFloat numberOfXAxisTicks = (self.xAxis.length);
    
    CGFloat numberOfYAxisTicks = calculateAmountOfTicks(CGRectGetHeight(self.frame));
    
    CGFloat maxYValue = rounded(maxY);
    
    CGFloat representativeValueOfYAxisPerTick = maxYValue/numberOfYAxisTicks;
    
    
    CGFloat distanceBetweenYAxisTicks = (self.frame.size.height - kBuffer*2)/(numberOfYAxisTicks);

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
        CGPoint point = CGPointMake([self xFory:i withLine:[(KALine*)[self.lines firstObject] values]], self.frame.size.height - kBuffer+8);
        
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
    
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    
    if (self.doesDrawAxisLines){
        CGContextMoveToPoint(context, kBuffer, kBuffer);
        CGContextSetStrokeColorWithColor(context, [self.axisLineColor CGColor]);
        CGContextSetLineWidth(context, 1.0);
        CGContextAddLineToPoint(context, kBuffer, self.frame.size.height - kBuffer);
        CGContextAddLineToPoint(context, self.frame.size.width - kBuffer, self.frame.size.height - kBuffer);
        CGContextDrawPath(context, kCGPathStroke);
    }
    
    
    
    for (KALine *line in self.lines){
        [self drawLineForYValues:line andMaxYValue:maxYValue onContext:context];
    }
    
}


- (void)drawLineForYValues:(KALine *)line andMaxYValue:(CGFloat)maxYValue onContext:(CGContextRef)context{
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    CGContextSetStrokeColorWithColor(context, [line.color CGColor]);
    CGContextSetLineWidth(context, line.lineWidth);
    for (int i = 0; i < line.values.count; i++){
        CGPoint point = [self pointWithIndex:i andMaxValue:maxYValue withLine:line.values];
        if (i == 0){
            CGContextMoveToPoint(context, point.x, point.y);
        }
        CGContextAddLineToPoint(context,point.x,point.y);
        
    }
    CGContextSetLineJoin(context, kCGLineJoinBevel);
    CGContextDrawPath(context, kCGPathStroke);
    
    if (line.fillColor){
        CGContextMoveToPoint(context, kBuffer, CGRectGetHeight(self.frame) - kBuffer);
        
        for (int i = 0; i < line.values.count; i++){
            CGPoint point = [self pointWithIndex:i andMaxValue:maxYValue withLine:line.values];
            
            CGContextAddLineToPoint(context,point.x,point.y);
            
        }
        
        CGContextAddLineToPoint(context, [self xFory:line.values.count-1 withLine:line.values], CGRectGetHeight(self.frame)-kBuffer);
        
        CGContextSetFillColorWithColor(context, [[line fillColor] CGColor]);
        CGContextDrawPath(context, kCGPathFill);
    }
    NSLog(@"time - %f", [[NSDate date] timeIntervalSince1970]-time);

}


- (CGPoint)pointWithIndex:(NSInteger)i andMaxValue:(CGFloat)maxYValue withLine:(NSArray *)lineValues{
    CGFloat yval = [(NSNumber *)lineValues[i] doubleValue]/maxYValue;
    CGPoint point = [self pointForY:yval withI:i withLine:lineValues];
    return point;
}
- (CGPoint)pointForY:(CGFloat)y withI:(NSInteger)i withLine:(NSArray *)lineValues{
    return CGPointMake(
                       [self xFory:i withLine:lineValues],
                       
                       (self.frame.size.height - kBuffer) - (y*(self.frame.size.height-kBuffer*2))
                       
                       );
}

- (CGFloat)xFory:(CGFloat)y withLine:(NSArray *)lineValues{
    CGFloat widthAdjusted = CGRectGetWidth(self.frame) -( kBuffer*2);
    CGFloat perTick = (widthAdjusted/(CGFloat)(lineValues.count-1));
    CGFloat amountOver = y*perTick;
    return kBuffer + amountOver;
    
}








@end
