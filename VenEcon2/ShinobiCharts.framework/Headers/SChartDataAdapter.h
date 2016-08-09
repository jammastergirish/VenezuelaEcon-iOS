//
//  SChartDataAdapter.h
//  ShinobiCharts
//
//  Created by Ryan Grey on 17/04/2015.
//
//

#import <Foundation/Foundation.h>
#import "ShinobiMacros.h"

@protocol SChartData;

NS_ASSUME_NONNULL_BEGIN

/**
 *  Provides an interface for any object wishing to adapt a series' data points.
 */

@protocol SChartDataAdapter <NSObject>

/**
 *  Derives and returns an array of adapted data points from the given dataPoints.
 *
 *  Note that the SChartData objects in dataPoints will have values of the same type as the data originally provided by the chart's data source. For example if you supply data points that have x values that are `NSDate` objects, then the SChartData objects contained in dataPoints will have `NSDate`s for their x values.
 *  
 *  @param dataPoints An array of SChartData objects to be adapted.
 *  @return An array of SChartData objects representing an adapted version of dataPoints.
 */
- (NSArray SC_GENERIC(id<SChartData>) *)adaptedDataPointsFromDataPoints:(NSArray SC_GENERIC(id<SChartData>) *)dataPoints;

@end

NS_ASSUME_NONNULL_END
