//
//  SChartBarColumnSeries.h
//  SChart
//
//  Copyright 2011 Scott Logic Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "SChartCartesianSeries.h"
#import "SChartBarColumnSeriesStyle.h"

NS_ASSUME_NONNULL_BEGIN

/** This is the base class for column and bar series - containing all of the common functions between the two. To display a bar or column series on the chart init and use one of the classes `SChartBarSeries` or `SChartColumnSeries` respectively. 
 
 @available Standard
 @available Premium
 @sample BarChart
 @sample ColumnChart
 @sa ChartsUserGuide
 */
@interface SChartBarColumnSeries : SChartCartesianSeries

#pragma mark -
#pragma mark Config settings

/** The orientation of the axis with which this series is associated.
 
 SChartSeriesOrientation is defined as follows:
 
 - SChartSeriesOrientationHorizontal: Configures the orientation of the axis with which this series is associated to be horizontal. Thus the controlled variable will be drawn on the x-axis, while the measured variable will be drawn on the y-axis.
 - SChartSeriesOrientationVertical: Configures the orientation of the axis with which this series is associated to be vertical. Thus the controlled variable will be drawn on the y-axis, while the measured variable will be drawn on the x-axis.
 
 The orientation for bar/column series is vertical, and the orientation for column series is horizontal.
 */
@property (nonatomic, assign) SChartSeriesOrientation orientation;
/*
 The number of edges used to create a rounded corner.
 The default value is 15.

 This value can be lowered to reduce the amount of memory used when creating bars & columns with rounded corners.
 However, this will impacts the smoothness of the rounded corners.

 This value can be raised to increase the smoothness of the rounded corners on bars & columns.
 However, this will impacts performance and increase memory usage.
 */
@property (nonatomic, assign) NSUInteger numberOfCornerEdges;

/** Whether or not hit detection can be triggered by tapping outside of the bar/column.
 
 The default value is NO.
 
 */
@property(atomic) BOOL detectTapsOutsideBar;

#pragma mark -
#pragma mark Styling
/**@name Styling */

/** Returns the style object for this series.
 
 When a series is created, its style is set from the theme.  If you wish to customize the look of the series, you can tweak the properties of the style to configure it correctly, or you can create a new style object and set it on the series.
 
 @see SChartBarColumnSeriesStyle
 */
-(SChartBarColumnSeriesStyle *)style;

/** Sets the style object for this series.
 
 You would use this method if you wished to modify the look of the series in its normal state.
 
 @see SChartBarColumnSeriesStyle
 @param style The new style to use for this series.
 */
-(void)setStyle:(SChartBarColumnSeriesStyle *)style;

/** Returns the selected style object for this series.
 
 These style settings will be applied when the series is marked as selected (or a datapoint is selected).
 
 When a series is created, its style is set from the theme.  If you wish to customize the look of the series, you can tweak the properties of the style to configure it correctly, or you can create a new style object and set it on the series.
 
 @see SChartBarColumnSeriesStyle
 */
-(SChartBarColumnSeriesStyle *)selectedStyle;

/** Sets the selected style object for this series.
 
 These style settings will be applied when the series is marked as selected (or a datapoint is selected).
 
 You would use this method if you wished to modify the look of the series when it is selected.
 
 @see SChartBarColumnSeriesStyle
 @param selectedStyle The new style to use for this series when it is marked as selected.
 */
-(void)setSelectedStyle:(SChartBarColumnSeriesStyle *)selectedStyle;

#pragma mark -
#pragma mark Subclassing
/**@name Subclassing */

/** Specifies the style to use on a per-point basis
 
 This method is called for each datapoint in this series and the standard implementation chooses to return either the style or selectedStyle object based on the `selectionMode` and
 selected state of either the point or the series. _Computationally expensive operations here will increase initial render time._
 
 Use the `sChartXValue` & `sChartYValue` properties to access each datapoint's X & Y values. Here is an example of how to use these properties to style each bar/column:
 
 - (SChartBarColumnSeriesStyle *)styleForPoint:(id<SChartData>)point {
 
 SChartBarColumnSeriesStyle *newStyle = [super styleForPoint:point];
 
 float xValue = [[point sChartXValue] floatValue];
 
 newStyle.showAreaWithGradient = NO;
 
 if (xValue > 90) {
 newStyle.areaColor = [UIColor redColor];
 } else if(xValue > 50) {
 newStyle.areaColor = [UIColor yellowColor];
 } else {
 newStyle.areaColor = [UIColor greenColor];
 }
 return newStyle;
 }
 
 
 @param point The data-point that will be styled by the returned style object.
 
 */
- (SChartBarColumnSeriesStyle *)styleForPoint:(id<SChartData>)point;

@end

NS_ASSUME_NONNULL_END
