//
//  SChartCrosshairTooltip.h
//  SChart
//
//  Copyright 2011 Scott Logic Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SChartCanvas;
@class SChartCrosshairStyle;
@protocol SChartData;
@class SChartSeries;
@class ShinobiChart;

#import "SChartPointStruct.h"

/** A simple extension of the UIView class to use as the standard cross hair tooltip.
 
 <img src="../docs/markdown_files/Images/api_crosshair.png" width=400/>
 
 To create a custom tooltip - subclass this class and override the functions below. When the standard crosshair moves position it will call the following functions in order:
 
 1. `setTooltipStyle:`
 2. `setDataPoint:fromSeries:fromChart:`
 3. `setPosition:onCanvas:`
 
 More information about using SChartCrosshairTooltip can be found in our tutorials ['Customizing that Crosshair'](http://www.shinobicontrols.com/blog/posts/2012/07/19/customizing-that-crosshair) and ['Data streaming, crosshairs and custom tooltips in ShinobiCharts'](http://www.shinobicontrols.com/blog/posts/2013/12/04/data-streaming-crosshairs-and-custom-tooltips-in-shinobicharts).
 
 */
@interface SChartCrosshairTooltip : UIView

/** The label that this tooltip uses to display the related data point info.*/
@property (nonatomic, retain) UILabel *label;

/** The crosshair style object that defines the look and feel of the tooltip */
@property (nonatomic, retain) SChartCrosshairStyle *style;

/** @name Style*/

/** A method that is called to setup default properties of the tooltip (such as `inset` and `label`.)*/
- (void) setDefaults;

/**@name Displaying Data Points */
/** Standard crosshair called-method.
 
 Passes in information about the current crosshair data point. To convert dataPoint to a useful value - use the axis, eg:
 
    [chart.xAxis stringForValue:dataPoint.x]
 */
- (void)setDataPoint:(id<SChartData>)dataPoint fromSeries:(SChartSeries *)series fromChart:(ShinobiChart *)chart;

/** Standard crosshair called-method.
 
 Passes in information about the current crosshair data point's resolved value.
 
 You can use dataPoint to obtain the interpolated value.*/
- (void) setResolvedDataPoint:(SChartPoint)dataPoint fromSeries:(SChartSeries *)series fromChart:(ShinobiChart *)chart;


/**@name Positioning*/
/** Standard crosshair called-method.
  
 Passes in the position of the crosshair target and the current canvas. This allows positioning of the tooltip, using the canvas to do border checks. */
- (void)setPosition:(struct SChartPoint)pos onCanvas:(SChartCanvas*)canvas;

/** This method is called everytime the tooltip needs to layout its contents and is called as part of `setPosition:onCanvas:`.*/
-(void)layoutContents;

/** The inset that is used in the implementation of layoutContents for all subviews.*/
@property (nonatomic, assign) CGFloat inset;

/** Standard crosshair called-method.
 
 When the crosshair is in floating mode, this is called for the current floating-position.
 This is primarily for use in a subclass, where the label text can be set to a custom string.
 By default, no useful information is shown in the label. */
- (void) floatingAt:(CGPoint)coords;

@end
