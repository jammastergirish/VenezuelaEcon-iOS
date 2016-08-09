//
//  SChartCanvas+Deprecated.h
//  ShinobiCharts
//
//  Copyright Scott Logic Ltd 2015. All rights reserved.
//
//

#import "SChartCanvas.h"

@interface SChartCanvas ()

/*
 Sets whether panning is enabled on the chart canvas.
 @param enable If set to `YES`, panning will be enabled on the canvas.
 */
-(void) enablePanning:(BOOL)enable DEPRECATED_ATTRIBUTE;

/*
 If this property is set to `YES`, we will refresh the canvas in the next draw cycle.
 
 We set this property to `YES` when we call [ShinobiChart redrawChartIncludePlotArea:] and pass `YES` in as the argument.
 */
@property (nonatomic) BOOL redrawGL DEPRECATED_ATTRIBUTE;

/*
 We set this property to `YES` when we reload data in the chart. */
@property (nonatomic, assign) BOOL reloadedData DEPRECATED_ATTRIBUTE;

/* 
 We set this property to `YES` if the chart responds to device rotations, and we rotate the device. */
@property (nonatomic, assign) BOOL orientationChanged DEPRECATED_ATTRIBUTE;

@end
