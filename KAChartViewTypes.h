//
//  KAChartViewTypes.h
//  KAChartView
//
//  Created by Kenneth Parker Ackerson on 1/12/14.
//  Copyright (c) 2014 Kenneth Parker Ackerson. All rights reserved.
//

#ifndef KAChartView_KAChartViewTypes_h
#define KAChartView_KAChartViewTypes_h

#if TARGET_OS_IPHONE

#import <UIKit/UIKit.h>
#define KAColor UIColor
#define KAView UIView
#define KAFont UIFont

#else

#import <AppKit/AppKit.h>
#define KAColor NSColor
#define KAView NSView
#define KAFont NSFont

#define KAIsMac 1

#endif




#endif
