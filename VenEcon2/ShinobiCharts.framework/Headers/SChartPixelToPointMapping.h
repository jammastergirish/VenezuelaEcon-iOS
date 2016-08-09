//
//  SChartPixelToPointMapping.h
//  ShinobiCharts
//
//  Copyright 2014 Scott Logic Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class SChartMappedSeries;
@protocol SChartData;

/**
 * A tuple of pixel-point, series and datapoint, used for passing information
 * about a closest-point and series back from a SChartPixelToPointMapper
 */
@interface SChartPixelToPointMapping : NSObject

/**
 * The pixel point, in chart coordinates.
 *
 * This is the "suggested point".
 *
 * For example, on line series this point will be the interpolated position
 * where a trigger point intersects the line.
 *
 * On a multi-series column or bar this will be offset so the point is
 * positioned above the correct column / to the side of the correct bar.
 */
@property(nonatomic, assign) CGPoint pixelPoint;

/**
 * The series that `dataPoint` belongs to.
 */
@property(nonatomic, strong) SChartMappedSeries *series;

/**
 * The datapoint belonging to `series`.
 */
@property(nonatomic, strong) id<SChartData> dataPoint;

@end
