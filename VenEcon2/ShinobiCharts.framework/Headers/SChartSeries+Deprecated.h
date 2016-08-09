//
//  SChartSeries+Deprecated.h
//  ShinobiCharts
//
//  Copyright Scott Logic Ltd 2015. All rights reserved.
//
//

#import "SChartSeries.h"

@interface SChartSeries ()

/* DEPRECATED - Use the `hidden` property instead.
 
 Whether or not the series should be drawn on the chart.*/
- (BOOL)shouldBeDrawn DEPRECATED_MSG_ATTRIBUTE("Use the `hidden` property instead");

@end
