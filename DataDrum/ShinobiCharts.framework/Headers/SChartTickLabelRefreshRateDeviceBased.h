//
//  SChartTickLabelRefreshRateDeviceBased.h
//  ShinobiCharts
//
//  Copyright 2015 Scott Logic Ltd. All rights reserved.
//


#import "SChartTickLabelRefreshRate.h"

/**
 *  This class provides a simple way to adjust the rate at which tick labels are refreshed.
 *
 *  By default, slower devices (see list below) will skip every second call to refresh the tick marks, while faster devices will process every call.
 *
 *  Slow devices:
 *
 *  - iPad Mini 1
 *  - iPad 3rd Generation and below
 *  - iPhone 4S and below
 *  
 */


@interface SChartTickLabelRefreshRateDeviceBased : NSObject <SChartTickLabelRefreshRate>

/**
 *  Creates and returns an instance of SChartTickLabelRefreshRateDeviceBased with the specified slow and fast refresh rates.
 *
 *  Setting the rate as '1' will mean every call will be processed with no skipping, while setting it to '10' will result in just one call in 10 being processed.
 *
 *  @param slowRate The refresh rate for 'slow' devices
 *  @param fastRate The refresh rate for 'fast' devices
 *
 *  @return The newly allocated `SChartTickLabelRefreshRateDeviceBased` object
 */
- (instancetype)initWithSlowRefreshRate:(NSUInteger)slowRate
                     andFastRefreshRate:(NSUInteger)fastRate
NS_DESIGNATED_INITIALIZER;

@end
