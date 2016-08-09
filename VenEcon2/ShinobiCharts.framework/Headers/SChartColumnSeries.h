//
//  SChartColumnSeries.h
//  SChart
//
//  Copyright 2011 Scott Logic Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "SChartBarColumnSeries.h"

NS_ASSUME_NONNULL_BEGIN

/** Displays a column series on the chart.  A column series is visualized as a vertical rectangle on the chart, where the height of the rectange equates to the y value of the data point.
 
 
  <img src="../docs/markdown_files/Images/userguide_columnSeries.png" width=400/>
 
 
  The area of the column can be filled, depending on the style of the series.
 
 @available Standard
 @available Premium
 @sa ChartsUserGuide
 @sample ColumnChart
 */
@interface SChartColumnSeries : SChartBarColumnSeries

@end

NS_ASSUME_NONNULL_END
