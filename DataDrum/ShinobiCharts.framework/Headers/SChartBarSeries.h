//
//  SChartBarSeries.h
//  SChart
//
//  Copyright 2011 Scott Logic Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "SChartBarColumnSeries.h"

NS_ASSUME_NONNULL_BEGIN

/** Displays a bar series on the chart.  A bar series is visualized as a horizontal rectangle on the chart, where the width of the rectange equates to the x value of the data point.  The area of the bar can be filled, depending on the style of the series.
 
  <img src="../docs/markdown_files/Images/userguide_barSeries.png" width=400/>
 
 @available Standard
 @available Premium
 @sa ChartsUserGuide
 @sample BarChart
 */
@interface SChartBarSeries : SChartBarColumnSeries

@end

NS_ASSUME_NONNULL_END

