//
//  SChartSeriesCrosshair.h
//  ShinobiCharts
//
//  Copyright 2014 Scott Logic Ltd. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "SChartCrosshairProtocol.h"
#import "SChartSeriesCrosshairTooltip.h"

@class SChartSeriesCrosshairTooltip, ShinobiChart;

/**
 SChartSeriesCrosshair draws a small circle around the current point being tracked, accompanied by a tooltip of type `SChartSeriesCrosshairTooltip`. This tooltip has a caret that points in the direction of the circled datapoint and is capable of displaying both single and multi-value datapoints.
 
 <img src="../docs/markdown_files/Images/crosshair_series.png" width=400/>
 
 To use this crosshair, simply assign an instance of SChartSeriesCrosshair to the chart's `crosshair` property: `chart.crosshair = [[SChartSeriesCrosshair alloc] init];`
 
 The crosshair is enabled with a _tap-and-hold gesture_ and will lock to the nearest series to pan through the values.
 
 In order for a crosshair to be displayed on a chart series, the series must have its `crosshairEnabled` property set to `YES`.  This defaults to `NO`, so you will need to set this property on the series in your chart.
 
 More details about this crosshair can be found in our [user guide](../../user_guide.html#Series-Crosshair).
 
 @available Standard
 @available Premium
*/

@interface SChartSeriesCrosshair : UIView <SChartCrosshair>


/**
 *  The series the crosshair is currently tracking
 */
@property (nonatomic, weak) SChartMappedSeries *trackingSeries;

/**
 *  The tooltip that will be used to display data for the series the crosshair is tracking.
 */
@property (nonatomic, retain) SChartSeriesCrosshairTooltip *tooltip;

/**
 *  The style defining the look of the Series Crosshair's tooltip
 */
@property (nonatomic, retain) SChartCrosshairStyle *style;

@end
