//
//  SChartSeriesCrosshairTooltipStylerProtocol.h
//  ShinobiCharts
//
//  Copyright 2015 Scott Logic Ltd. All rights reserved.
//
//

#import <Foundation/Foundation.h>

#import "SChartData.h"

@class SChartSeriesCrosshairTooltip, SChartMappedSeries;

/** A class conforming to this protocol is responsible for styling the tooltip. 
 */

@protocol SChartSeriesCrosshairTooltipStylerProtocol <NSObject>

/**
 *  Style the tooltip.
 *
 *  This method could simply use properties from `[SChartSeriesCrosshairTooltip style]` or even extract attributes from the currently tracked series.
 *
 *  @param tooltip   The tooltip which will be styled
 *  @param series    The series currently being tracked by the crosshair
 *  @param datapoint The datapoint the tooltip is currently pointing to
 */
- (void)applyStyleToTooltip:(SChartSeriesCrosshairTooltip *)tooltip basedOnSeries:(SChartMappedSeries *)series forDatapoint:(id<SChartData>)datapoint;

@end
