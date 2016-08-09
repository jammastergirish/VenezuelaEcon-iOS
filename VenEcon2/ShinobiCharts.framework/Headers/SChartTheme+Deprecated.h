//
//  SChartTheme+Deprecated.h
//  ShinobiCharts
//
//  Copyright Scott Logic Ltd 2015. All rights reserved.
//
//

#import "SChartTheme.h"

@interface SChartTheme ()

/* DEPRECATED - This looks like a private method.  We will take this off the public API in a future commit. */
- (void)setStyles DEPRECATED_ATTRIBUTE;

/* DEPRECATED - We will move this off the public API in a future commit. */
-(void)configureLineSeriesStyle:(SChartLineSeriesStyle *)style DEPRECATED_ATTRIBUTE;

/* DEPRECATED - We will move this off the public API in a future commit. */
-(void)configureBarSeriesStyle:(SChartBarSeriesStyle *)style DEPRECATED_ATTRIBUTE;

/* DEPRECATED - We will move this off the public API in a future commit. */
-(void)configureColumnSeriesStyle:(SChartColumnSeriesStyle *)style DEPRECATED_ATTRIBUTE;

/* DEPRECATED - We will move this off the public API in a future commit. */
-(void)configureScatterSeriesStyle:(SChartScatterSeriesStyle *)style DEPRECATED_ATTRIBUTE;

@end
