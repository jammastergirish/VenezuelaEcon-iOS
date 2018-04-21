//
//  SChartCrosshairTooltip+Deprecated.h
//  ShinobiCharts
//
//  Copyright Scott Logic Ltd 2015. All rights reserved.
//
//

#import "SChartCrosshairTooltip.h"

@interface SChartCrosshairTooltip ()

/* A method called by the default crosshair
 
 Passes in the crosshair style object to update the look and feel of the tooltip
 
 @warning DEPRECATED - use `style` property instead*/
- (void)setTooltipStyle:(SChartCrosshairStyle*)style DEPRECATED_MSG_ATTRIBUTE("Use `style` property instead");

@end

