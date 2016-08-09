//
//  SChartSeriesCrosshairTooltipDrawerProtocol.h
//  ShinobiCharts
//
//  Copyright 2014 Scott Logic Ltd. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@class SChartSeriesCrosshairTooltip, ShinobiChart, SChartMappedSeries;

/**
 Classes implementing this protocol are responsible for drawing a path representing the tooltip's shape.
 */

@protocol SChartSeriesCrosshairTooltipDrawerProtocol <NSObject>

/**
 *  Provides a path representing the outline of the tooltip.
 *
 *  This method is called every time `SChartSeriesCrosshair`'s position is updated.
 *
 *  @param tooltip The tooltip the path is being drawn for
 *  @param point The center point of the datapoint on the canvas that the tooltip is currently tracking
 *  @param chart The chart instance for which the tooltip is displaying data
 *  @param series The series the crosshair is currently tracking
 *
 *  @return The tooltip's path
 */
- (CGPathRef)newPathForTooltip:(SChartSeriesCrosshairTooltip *)tooltip withCurrentTrackedPoint:(CGPoint)point onChart:(ShinobiChart *)chart trackingSeries:(SChartMappedSeries *)series;

@end
