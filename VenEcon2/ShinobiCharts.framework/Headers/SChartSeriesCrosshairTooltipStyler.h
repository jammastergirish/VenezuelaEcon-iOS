//
//  SChartSeriesCrosshairTooltipStyler.h
//  ShinobiCharts
//
//  Copyright 2014 Scott Logic Ltd. All rights reserved.
//
//

#import <Foundation/Foundation.h>

#import "SChartSeriesCrosshairTooltipStylerProtocol.h"

/**
 The styler is responsible for applying an `SChartCrosshairStyle` to `SChartSeriesCrosshairTooltip`.
 
 This implementation applies a crosshair style to `[SChartSeriesCrosshairTooltip shapeLayer]` as follows:
 
    - fillColor: same color as the series' (extracted from each SChartSeries using primarySeriesColorForDatapoint: instance method)
    - lineWidth: syle.defaultBorderWidth
    - strokeColor: style.defaultBorderColor
 
 These can be altered by creating a class conforming to `SChartSeriesCrosshairTooltipStylerProtocol` and setting the tooltip's `styler` property to an instance of the class.
*/

@interface SChartSeriesCrosshairTooltipStyler : NSObject <SChartSeriesCrosshairTooltipStylerProtocol>

@end
