//
//  LineSeriesDrawer.h
//  SChart
//
//  Copyright 2011 Scott Logic Ltd. All rights reserved.
//

#import "SChartGLCommon.h"

@class SChartInternalDataPoint;
@class SChartLineSeries;

@interface SChartGLView (LineSeriesDrawer)

- (void)drawLineSeries:(NSArray<SChartInternalDataPoint *> *)dataPoints
         lowDataPoints:(NSArray<SChartInternalDataPoint *> *)lowDPs
                series:(SChartLineSeries *)series
                 style:(SChartLineSeriesStyle *)style
              baseline:(float)baseline
           translation:(const SChartGLTranslation *)translation
currentRenderIndexDict:(NSMutableDictionary *)currentRenderIndexDict;

-(void)drawLineStrip:(float *)points
              series:(SChartSeries *)series
          linesIndex:(int *)linesIndex
indexedOffsetTrianglesIndex:(int *)indexedOffsetTrianglesIndex
        pointsOffset:(int *)pointsIndex
                size:(size_t)size
               color:(UIColor *)lineColour
  colorBelowBaseline:(UIColor *)lineColourBelowBaseline
               width:(float)width
            baseline:(float)baseline
         translation:(const SChartGLTranslation *)translation;

@end
