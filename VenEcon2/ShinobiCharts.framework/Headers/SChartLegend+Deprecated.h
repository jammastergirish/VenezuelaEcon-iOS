//
//  SChartLegend+Deprecated.h
//  ShinobiCharts
//
//  Copyright Scott Logic Ltd 2015. All rights reserved.
//
//

#import "SChartLegend.h"

@interface SChartLegend ()

@property (nonatomic, assign) BOOL showSymbols  DEPRECATED_MSG_ATTRIBUTE("Use `[SChartLegendStyle showSymbols]` instead.");

/* Determines the radius of the legend corners.
 
 By default, this property is set to `0`. Setting this to `nil` also equates to a radius of 0 - which results in square corners.
 */
@property (nonatomic, retain) NSNumber *cornerRadius DEPRECATED_MSG_ATTRIBUTE("Use the `cornerRadius` property on the `SChartLegendStyle` class.");

@end
