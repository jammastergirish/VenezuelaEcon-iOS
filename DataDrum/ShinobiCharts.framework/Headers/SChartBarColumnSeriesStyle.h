//
//  SChartBarColumnSeriesStyle.h
//  SChart
//
//  Copyright 2011 Scott Logic Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "SChartSeriesStyle.h"

/** SChartBarColumnSeriesStyle manages the look of bar and column series on a chart.  It contains any properties which are common to both bar and column series.
 
 For properties which are specific to bar series, you should use the `SChartBarSeriesStyle`.  For properties which are specific to column series, you should use the `SChartColumnSeriesStyle`.
 
 @available Standard
 @available Premium
 @sample BarChart
 @sample ColumnChart
 */
@interface SChartBarColumnSeriesStyle : SChartSeriesStyle 

/** @name Styling Properties */

/** Set this property to `YES` to fill the area inside the bar/column.
 
 By default, this property is set to `YES`. */
@property (nonatomic)             BOOL showArea;

/** Set this property to `YES` to add a gradient to the fill inside the bar/column.  If the area is not filled, this property won't have any effect. 
 
 When a gradient is applied to the fill, the color starts at `areaColor`, and finishes at `areaColorGradient`.
 
 The gradient isn't configurable.  It runs from left to right on column series, and from top to bottom on bar series.
 
 By default, this property is set to `YES`. */
@property (nonatomic)             BOOL showAreaWithGradient;

/** The fill color of the area inside the bar/column if `showArea` is `YES`. */
@property (nonatomic, retain)     UIColor *areaColor;

/** The second fill color of the area inside the bar/column if `showAreaWithGradient` is `YES`. */
@property (nonatomic, retain)     UIColor *areaColorGradient;

/** The fill color of the area inside the bar/column if `showArea` is `YES` when the data point is below the baseline of the series. 
 
 The baseline of the series is set by [SChartCartesianSeries baseline].
 */
@property (nonatomic, retain)     UIColor *areaColorBelowBaseline;

/** The second fill color of the area inside the bar/column if `showAreaWithGradient` is `YES` when the data point is below the baseline. 
 
 The baseline of the series is set by [SChartCartesianSeries baseline].
 */
@property (nonatomic, retain)     UIColor *areaColorGradientBelowBaseline;

/** The color of the outline of the bar/column. */
@property (nonatomic, retain)     UIColor *lineColor;

/** The color of the outline of the bar/column when the data point is below the baseline.
 
 The baseline of the series is set by [SChartCartesianSeries baseline].
 */
@property (nonatomic, retain)     UIColor *lineColorBelowBaseline;

/** The width of the outline of the bar/column, in points. */
@property (nonatomic, retain)     NSNumber *lineWidth;

/** The ratio used to calculate a corner radius which is applied to the corners on the tip of each bar or column.
 The corner radius is calculated by multiplying this corner ratio value against half the bar or column width.
 
 When set to 1 the tip of each bar or column is fully rounded, when set to 0 there isn't a corner radius applied.
 
 By default, this property is set to `0`. */
@property (nonatomic, assign)     CGFloat cornerRatio;

/** Updates this style object using the settings from the passed-in style. 
 
 @param style The style with which to configure this style object.
 */
- (void)supplementStyleFromStyle:(SChartBarColumnSeriesStyle *)style;

@end
