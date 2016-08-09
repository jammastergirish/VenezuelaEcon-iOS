//
//  SChartSeriesCrosshairTooltip.h
//  ShinobiCharts
//
//  Copyright 2014 Scott Logic Ltd. All rights reserved.
//
//

#import <Foundation/Foundation.h>

#import "SChartCrosshairMultiValueTooltip.h"
#import "SChartSeriesCrosshairTooltipPositionerProtocol.h"
#import "SChartSeriesCrosshairTooltipDrawerProtocol.h"
#import "SChartSeriesCrosshairTooltipStylerProtocol.h"

@class SChartMappedSeries;

/**
 An extension of `SChartCrosshairMultiValueTooltip`, this tooltip adds a caret that points in the direction of the current tracked datapoint and sets its background color to be the same as that of the current tracked series.
 
 When the series goes beyond the plot area's bounds (the view within which the series is drawn), the tooltip by default will remain positioned within the frame's bounds and point to the offscreen datapoint. This behaviour can be altered by implementing classes that conform to `SChartSeriesCrosshairTooltipPositionerProtocol` and `SChartSeriesCrosshairTooltipDrawerProtocol`.
 
 Altering how the tooltip is styled can be done by subclassing `SChartSeriesCrosshairTooltipStyler` or creating a class that conforms to `SChartSeriesCrosshairTooltipStylerProtocol`.
 
 @available Standard
 @available Premium
*/

@interface SChartSeriesCrosshairTooltip : SChartCrosshairMultiValueTooltip

/**
 Defines the width of the tooltip's caret at its base.
 
 Default is 10.
 */
@property (nonatomic, assign) CGFloat caretWidth;

/**
 Handles the positioning of the tooltip.
 
 The default is `SChartSeriesCrosshairTooltipPositioner`.
 */
@property (nonatomic, retain) id <SChartSeriesCrosshairTooltipPositionerProtocol> positioner;

/**
 Handles the drawing of the tooltip. It is expected to return a `CGPathRef` that defines the path of the tooltip.
 
 Default is `SChartSeriesCrosshairTooltipDrawer`.
 */
@property (nonatomic, retain) id <SChartSeriesCrosshairTooltipDrawerProtocol> drawer;

/**
 Responsible for styling the tooltip.
 
 Default is `SChartSeriesCrosshairTooltipStyler`.
 */
@property (nonatomic, retain) id <SChartSeriesCrosshairTooltipStylerProtocol> styler;

/**
 The layer upon which the tooltip is drawn.
 
 This property is exposed for use in classes conforming to `SChartSeriesCrosshairTooltipStylerProtocol` to apply attributes extracted from `SChartCrosshairStyle` to the shape layer.
 
 NOTE: The preferred method to supply a `CGPathRef` to the shape layer is by conforming to `SChartSeriesCrosshairTooltipDrawerProtocol` and returning a path using `newPathForTooltip:withCurrentTrackedPoint:onChart:trackingSeries:`. Any path set directly on this property will be overidden when the tooltip's position changes.
 */
@property (nonatomic, retain) CAShapeLayer *shapeLayer;

/**
 *  Called when the chart's crosshair has been moved to a new position. 
 *
 *  In this method the tooltip is positioned, drawn and styled.
 *
 *  @param position The position on the chart of the datapoint currently being tracked by the crosshair
 *  @param series   The series currently being tracked by the crosshair
 *  @param dataPoint The datapoint the crosshair is centered over
 *  @param chart   The chart on which the tooltip will be drawn
 */
- (void)setPosition:(CGPoint)position trackingSeries:(SChartMappedSeries *)series forDataPoint:(id<SChartData>)dataPoint onChart:(ShinobiChart *)chart;

@end
