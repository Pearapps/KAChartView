//
//  KAChartView.m
//  KAChartView
//
//  Created by Kenneth Parker Ackerson on 11/18/13.
//  Copyright (c) 2013 Kenneth Parker Ackerson. All rights reserved.
//

#import "KAChartView.h"
@interface KAChartView() {
    CGFloat maxY;
    CGFloat kBuffer;

}
@property (nonatomic, assign) NSRange xAxis;
@property (nonatomic, strong) NSMutableArray * dataSets;
@property (nonatomic, assign) KAChartViewType type;

@end
@implementation KAChartView

- (instancetype)initWithFrame:(CGRect)frame andType:(KAChartViewType)type {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.type = type;
        
        kBuffer = kBufferValue;

        self.doesDrawGrid = NO;
        self.doesDrawAxisLines = NO;
#if TARGET_OS_IPHONE
        [self setBackgroundColor:[KAColor clearColor]];
#endif
        
        self.axisLabelAttributes = @{NSFontAttributeName: [KAFont systemFontOfSize:10], NSForegroundColorAttributeName: [KAColor lightGrayColor]};
        self.axisLineColor = [KAColor lightGrayColor];
        
        self.dataSets = [[NSMutableArray alloc] init];
        
        maxY = -MAXFLOAT;
    }
    return self;
}

#pragma mark - Setters

- (void)setDoesDrawAxisLines:(BOOL)doesDrawAxisLines {
    _doesDrawAxisLines = doesDrawAxisLines;
    [self _needsDisplay];
}

- (void)setDoesDrawGrid:(BOOL)doesDrawGrid {
    _doesDrawGrid = doesDrawGrid;
    [self _needsDisplay];
}

- (void)setAxisLineColor:(KAColor *)axisLineColor {
    _axisLineColor = axisLineColor;
    [self _needsDisplay];
}

- (void)setAxisLabelAttributes:(NSDictionary *)axisLabelAttributes {
    _axisLabelAttributes = axisLabelAttributes;
    [self _needsDisplay];
}

- (void)setXAxis:(NSRange)xAxis {
    _xAxis = xAxis;
    [self _needsDisplay];
}

#pragma mark - Managing KALine(s)

- (void)removeDataSet:(KADataSet *)dataSet {
    [self.dataSets removeObject:dataSet];
    if (self.dataSets.count == 0){
        maxY = -MAXFLOAT;
        [self setXAxis:NSMakeRange(0, 0)];
    }else{
        [self recalculateMaxY];
        // no need to recalculate xaxis if there is lines in the array, they should all have the same amount of values
    }
    [self _needsDisplay];
}

- (void)addDataSet:(KADataSet *)dataSet{
    
    if (self.dataSets.count > 0){
        NSAssert((dataSet.values.count == self.xAxis.length), @"Invalid additional line - different amount of values.");
    }else{
        [self setXAxis:NSMakeRange(0, dataSet.values.count)];
    }
    [self.dataSets addObject:dataSet];
    for (NSNumber * numb in dataSet.values){
        CGFloat y = [numb doubleValue];
        if (y > maxY){
            maxY = y;
        }
    }
    [self _needsDisplay];
}

- (void)addDataSets:(NSArray *)dataSets {
    for (KADataSet *dataSet in dataSets) {
        [self addDataSet:dataSet];
    }
}

- (void)addDataSetWithYValues:(NSArray *)values{
    [self addDataSet:[[KADataSet alloc] initWithValues:values withColor:[KAColor greenColor]]];
}

#pragma mark - Private -
#pragma mark C Math Functions
static inline CGFloat rounded(CGFloat value) {
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
    return 1.0 * power;
}

static inline CGFloat calculateAmountOfTicks(CGFloat heightOfView) { // 5 y labels per 200 points
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

- (void)recalculateMaxY {
    maxY = -MAXFLOAT;
    for (KADataSet *line in self.dataSets){
        for (NSNumber * numb in line.values){
            CGFloat y = [numb doubleValue];
            if (y > maxY){
                maxY = y;
            }
        }
    }
}

- (void)drawRect:(CGRect)rect {
    if (self.dataSets.count == 0) {
        return;
    }

    kBuffer = kBufferValue;
    CGFloat widthOffset = 0;
    if (self.type == KAChartViewTypeBar) {
        widthOffset += [self barWidthForDataSet:[self.dataSets firstObject]]/2.f; // This is to adjust for having to move each bar over by widthOfTheBar/2
    }
    
    CGFloat numberOfXAxisTicks = (self.xAxis.length);
    
    CGFloat numberOfYAxisTicks = calculateAmountOfTicks(CGRectGetHeight(self.frame));
    
    CGFloat maxYValue = rounded(maxY);
    
    if (maxYValue <= 0) {
        // nope. dont draw anything.
        return;
    }
    
    CGFloat representativeValueOfYAxisPerTick = maxYValue/numberOfYAxisTicks;
    
    
    CGFloat distanceBetweenYAxisTicks = (self.frame.size.height - kBuffer*2)/(numberOfYAxisTicks);

    BOOL showsDecimals = NO;
    if (maxYValue <= numberOfXAxisTicks){
        showsDecimals = YES;
    }
    
    for (NSInteger i = 0; i < numberOfXAxisTicks; i++) {
        NSString *xValueAtIndex = nil;
        if (self.xAxisLabels){
            xValueAtIndex = self.xAxisLabels[i];
        }else{
            xValueAtIndex = [NSString stringWithFormat:@"%ld", (long)i];
        }
        CGPoint point = CGPointMake([self xFory:i withLine:[(KADataSet*)[self.dataSets firstObject] values]] + widthOffset, CGRectGetHeight(self.frame) - kBuffer+8);
        
#if KAIsMac
        point.y = 0 + kBuffer - 16;
#endif
        
        [xValueAtIndex drawAtPoint:CGPointMake(point.x - [xValueAtIndex sizeWithAttributes:self.axisLabelAttributes].width/2, point.y) withAttributes:self.axisLabelAttributes];
    }
    
    for (int i = 0; i <= numberOfYAxisTicks; i++) {
        CGPoint point = CGPointMake(kBuffer , (self.frame.size.height - kBuffer) - (distanceBetweenYAxisTicks*i));
#if KAIsMac
        point.y = 0 + kBuffer + (distanceBetweenYAxisTicks *i);
#endif
        CGFloat value = i*(CGFloat)representativeValueOfYAxisPerTick;
        NSString *intString = [NSString stringWithFormat:@"%0.0f", (CGFloat)value];
        if (showsDecimals){
            intString = [NSString stringWithFormat:@"%0.2f", i*(CGFloat)(representativeValueOfYAxisPerTick)];
        }
        
        CGSize sizeOfString = [intString sizeWithAttributes:self.axisLabelAttributes];
        [intString drawAtPoint:CGPointMake(point.x - sizeOfString.width - 8, point.y- [intString sizeWithAttributes:self.axisLabelAttributes].height/2) withAttributes:self.axisLabelAttributes];
        
    }
    

    CGContextRef context = [self _graphicsContext];
    if (self.doesDrawAxisLines){
#if TARGET_OS_IPHONE
        CGContextMoveToPoint(context, kBuffer, kBuffer);
#else
        CGContextMoveToPoint(context, kBuffer,  CGRectGetHeight(self.frame) - kBuffer);

#endif
        CGContextSetStrokeColorWithColor(context, [self.axisLineColor CGColor]);
        CGContextSetLineWidth(context, 1.0);
        
#if TARGET_OS_IPHONE
        CGFloat y = CGRectGetHeight(self.frame) -  kBuffer;
#else
        CGFloat y = kBuffer;
#endif
        CGContextAddLineToPoint(context, kBuffer, y);
        CGContextAddLineToPoint(context, self.frame.size.width - kBuffer, y);
        
        CGContextDrawPath(context, kCGPathStroke);
    }
    
    if (self.type == KAChartViewTypeLine) {
        for (KADataSet *dataSet in self.dataSets){
            [self drawLineForYValues:dataSet andMaxYValue:maxYValue onContext:context];
        }
    } else {
        for (KADataSet *dataSet in self.dataSets){
            [self drawBarForDataSet:dataSet andMaxYValue:maxYValue onContext:context];
        }
    }
}

- (void)_needsDisplay{
#if TARGET_OS_IPHONE
    [self setNeedsDisplay];
#else
    [self setNeedsDisplay:YES];
#endif
    
}
#if KAIsMac

- (KAImage *)imageRepresentation {
    NSSize mySize = self.bounds.size;
    NSSize imgSize = NSMakeSize( mySize.width, mySize.height );
    
    NSBitmapImageRep *bir = [self bitmapImageRepForCachingDisplayInRect:[self bounds]];
    [bir setSize:imgSize];
    [self cacheDisplayInRect:[self bounds] toBitmapImageRep:bir];
    KAImage* image = [[NSImage alloc]initWithSize:imgSize];
    [image addRepresentation:bir];
    return image;
}

#else
- (KAImage *)imageRepresentation {
    UIGraphicsBeginImageContext(self.frame.size);
    [[self layer] renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#endif


- (CGContextRef)_graphicsContext {
#if TARGET_OS_IPHONE
    return UIGraphicsGetCurrentContext();
#else
    return [[NSGraphicsContext currentContext] graphicsPort];
#endif
}

- (CGFloat)barWidthForDataSet:(KADataSet *)dataSet {
    CGFloat width = CGRectGetWidth(self.frame) - kBuffer*2 - (5 * dataSet.values.count);
    CGFloat widthOfBar = width/dataSet.values.count;
    return widthOfBar;
}

- (void)drawBarForDataSet:(KADataSet *)dataSet andMaxYValue:(CGFloat)maxYValue onContext:(CGContextRef)context {
    CGContextSetStrokeColorWithColor(context, [dataSet.color CGColor]);
    
    CGContextSetLineWidth(context, [self barWidthForDataSet:dataSet]);
    
    for (NSInteger i = 0; i < dataSet.values.count; i++){
        CGPoint point = [self pointWithIndex:i andMaxValue:maxYValue withValues:dataSet.values];
        
#if TARGET_OS_IPHONE
        CGFloat bottom = CGRectGetHeight(self.frame) - kBuffer;
#else
        CGFloat bottom = 0+kBuffer;
#endif
        
        CGContextMoveToPoint(context, point.x + (YES ? [self barWidthForDataSet:dataSet]/2 : 0), bottom);
        CGContextAddLineToPoint(context,point.x+ (YES ? [self barWidthForDataSet:dataSet]/2 : 0),point.y);
        CGContextDrawPath(context, kCGPathStroke);
    }
}

- (void)drawLineForYValues:(KADataSet *)dataSet andMaxYValue:(CGFloat)maxYValue onContext:(CGContextRef)context {
    CGContextSetStrokeColorWithColor(context, [dataSet.color CGColor]);
    CGContextSetLineWidth(context, dataSet.lineWidth);
    for (NSInteger i = 0; i < dataSet.values.count; i++){
        CGPoint point = [self pointWithIndex:i andMaxValue:maxYValue withValues:dataSet.values];
        if (i == 0){
            CGContextMoveToPoint(context, point.x, point.y);
        }
        CGContextAddLineToPoint(context,point.x,point.y);
        
    }
    CGContextSetLineJoin(context, kCGLineJoinBevel);
    CGContextDrawPath(context, kCGPathStroke);
    
    if (dataSet.fillColor){
        CGFloat y = CGRectGetHeight(self.frame) - kBuffer;
        
#if KAIsMac
        y = kBuffer;
#endif
        
        CGContextMoveToPoint(context, kBuffer, y);
        
        for (int i = 0; i < dataSet.values.count; i++) {
            CGPoint point = [self pointWithIndex:i andMaxValue:maxYValue withValues:dataSet.values];
            
            CGContextAddLineToPoint(context,point.x,point.y);
        }
        
        CGContextAddLineToPoint(context, [self xFory:dataSet.values.count-1 withLine:dataSet.values], y);
        
        CGContextSetFillColorWithColor(context, [[dataSet fillColor] CGColor]);
        CGContextDrawPath(context, kCGPathFill);
    }
}

- (void)dealloc {
    self.axisLabelAttributes = nil;
    self.xAxisLabels = nil;
    self.axisLineColor = nil;
    self.dataSets = nil;
}


- (CGPoint)pointWithIndex:(NSInteger)i andMaxValue:(CGFloat)maxYValue withValues:(NSArray *)values {
    CGFloat yval = [(NSNumber *)values[i] doubleValue]/maxYValue;
    CGPoint point = [self pointForY:yval withI:i withLine:values];
    return point;
}
- (CGPoint)pointForY:(CGFloat)y withI:(NSInteger)i withLine:(NSArray *)lineValues {
    CGPoint point = CGPointMake(
                       [self xFory:i withLine:lineValues],
#if TARGET_OS_IPHONE
                                (self.frame.size.height - kBuffer) - (y*(CGRectGetHeight(self.frame)-kBuffer*2)
#else
                                (0 + kBuffer) + (y*(CGRectGetHeight(self.frame)-kBuffer*2)
#endif
                       ));

    return point;

}

- (CGFloat)xFory:(CGFloat)y withLine:(NSArray *)lineValues{
    CGFloat widthAdjusted = CGRectGetWidth(self.frame) -( kBuffer*2);
    CGFloat perTick = (widthAdjusted/(CGFloat)(lineValues.count-1));
    CGFloat amountOver = y*perTick;
    return kBuffer + amountOver;
    
}

@end