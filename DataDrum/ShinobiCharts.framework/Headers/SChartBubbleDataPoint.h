//
//  SChartBubbleDataPoint.h
//  Dev
//
//  Copyright (c) 2013 Scott Logic Ltd. All rights reserved.
//
//

#import "SChartMultiValueDataPoint.h"
#import "SChartData.h"

NS_ASSUME_NONNULL_BEGIN

@interface SChartBubbleDataPoint : SChartMultiValueDataPoint

/** The value of the bubble for the data point. 
 
 The area of the the bubble representing this point will be proportional to this value and be scaled by SChartBubbleSeries' [scale]([SChartBubbleSeries scale]) value.
 */
@property (nonatomic, assign) double area;

@end

NS_ASSUME_NONNULL_END
