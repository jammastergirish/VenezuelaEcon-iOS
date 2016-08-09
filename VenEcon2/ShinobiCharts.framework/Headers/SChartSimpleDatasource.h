//
//  SChartSimpleDatasource.h
//  ShinobiControls
//
//  Copyright (c) 2014 Scott Logic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SChartDatasource.h"

@protocol SChartDatasource;
@class SChartSeries;

NS_ASSUME_NONNULL_BEGIN

/** This class can be used to easily setup your chart with series and simple data.
 
 The `SChartSimpleDatasource` implements the `SChartDatasource` protocol and must be assigned to a chart's datasource to take effect.
 
 The series & data you have added to this `SChartSimpleDatasource` will be passed to and displayed by the chart it's been assigned to.
 */
@interface SChartSimpleDatasource : NSObject <SChartDatasource>

/** @name Providing data to a ShinobiChart */

/** Add a series and its corresponding array of `data` to be displayed on the chart which this `SChartSimpleDatasource` has been added to.
 
 The `data` array can either be an array of `SChartDataPoint`s or NSNumber objects. If it is an array of NSNumber objects they will be automatically translated into an array of `SChartDataPoint` objects. The array index will be used as the X value, with the NSNumber used as the Y value. Note: the assignment to X and Y values will be reversed if the series orientation is set to vertical.
 
 The `series` and `data` parameters will be validated before being added. If either of the parameters are nil the chart will log a warning and not add the series.
 
 @param series A series object that must be a subclass of SChartSeries. e.g. `SChartLineSeries`.
 @param data An array of `SChartDataPoint`s or NSNumber objects.
 */
- (void)addSeries:(SChartSeries *)series dataArray:(NSArray *)data;

@end

NS_ASSUME_NONNULL_END
