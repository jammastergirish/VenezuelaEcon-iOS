//
//  SChartSeriesCrosshairPositionerProtocol.h
//  ShinobiCharts
//
//  Copyright 2014 Scott Logic Ltd. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@class SChartSeriesCrosshairTooltip, ShinobiChart, SChartMappedSeries;

/**
 Classes implementing this protocol are responsible for positioning the tooltip on the canvas.
*/

@protocol SChartSeriesCrosshairTooltipPositionerProtocol <NSObject>

/**
 *  Calculates an appropriate center position for the tooltip.
 *
 *  @param tooltip The tooltip being repositioned
 *  @param chart  The chart instance for which the tooltip is displaying data - can be used to retrieve information about plot area's frame for bounds checking
 *  @param series The series the crosshair is currently tracking
 *
 *  @return The new center position for the tooltip
 */
- (CGPoint)centerOfTooltip:(SChartSeriesCrosshairTooltip *)tooltip onChart:(ShinobiChart *)chart trackingSeries:(SChartMappedSeries *)series;

@end
