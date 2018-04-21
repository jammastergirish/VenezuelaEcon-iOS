//
//  SChartDonutSeries+Deprecated.h
//  ShinobiCharts
//
//  Copyright Scott Logic Ltd 2015. All rights reserved.
//
//

#import "SChartDonutSeries.h"

@interface SChartDonutSeries ()

@property (nonatomic) CGFloat animationDuration DEPRECATED_MSG_ATTRIBUTE("Configure the `selectionAnimation` property instead.");

/* DEPRECATED - This should be a private method, so will be taken off the public API in a future commit.
 
 Draw a slice of the series. */
- (void)drawSlice:(NSInteger)sliceIndex ofTotal:(NSInteger)totalSlices fromAngle:(CGFloat)startAngle toAngle:(CGFloat)endAngle
       fromCentre:(CGPoint)centre withInnerRadius:(CGFloat)innerRadius andOuterRadius:(CGFloat)outerRadius asSelected:(BOOL)sel inFrame:(CGRect)frame DEPRECATED_ATTRIBUTE;

@end
