//
//  SChartCartesianSeries+Deprecated.h
//  ShinobiCharts
//
//  Copyright Scott Logic Ltd 2015. All rights reserved.
//
//

#import "SChartCartesianSeries.h"

@interface SChartCartesianSeries ()

@property (nonatomic) BOOL animated DEPRECATED_MSG_ATTRIBUTE("Use `[SChartSeries animationEnabled]` instead.");

@property (nonatomic) CGFloat animationDuration DEPRECATED_MSG_ATTRIBUTE("Configure either the `[SChartSeries entryAnimation]` or `[SChartSeries exitAnimation]` instead.");

@end
