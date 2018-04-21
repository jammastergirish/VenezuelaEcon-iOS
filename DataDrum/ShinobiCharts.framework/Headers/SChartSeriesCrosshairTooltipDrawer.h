//
//  SChartSeriesCrosshairTooltipDrawer.h
//  ShinobiCharts
//
//  Copyright 2014 Scott Logic Ltd. All rights reserved.
//
//

#import <Foundation/Foundation.h>

#import "SChartSeriesCrosshairTooltipDrawerProtocol.h"

/**
 This implementation of `SChartSeriesCrosshairTooltipDrawer` draws a caret pointing in the direction of the currently tracked datapoint.
 
 In the case where the tooltip would extend beyond the plot area, the caret is "smoothly" offset to continue pointing to the
 currently tracked datapoint.
 */

@interface SChartSeriesCrosshairTooltipDrawer : NSObject <SChartSeriesCrosshairTooltipDrawerProtocol>

@end
