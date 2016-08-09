//
//  SChartSeriesCrosshairTooltipPositioner
//  ShinobiCharts
//
//  Copyright 2015 Scott Logic Ltd. All rights reserved.
//
//

#import <Foundation/Foundation.h>

#import "SChartSeriesCrosshairTooltipPositionerProtocol.h"

/**
 Calculates an appropriate position for the tooltip.
 
 The calculated center position is series dependent. By default, all series with an orientation of `SChartSeriesOrientationHorizontal`
 will have their tooltips positioned above or below the datapoint, with those `SChartSeriesOrientationVertical` positioning the tooltip
 to the left or the right.
 
 This positioner constrains the tooltip within the chart's plot area.
 
 Also offsets the tooltip by a default of 20 points from the currently tracked datapoint.
 */
@interface SChartSeriesCrosshairTooltipPositioner : NSObject <SChartSeriesCrosshairTooltipPositionerProtocol>

@end
