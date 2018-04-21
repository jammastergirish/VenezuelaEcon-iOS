//
//  SChartGestureManager.h
//  SChart
//
//  Copyright 2015 Scott Logic Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "SChartGesturePanType.h"
#import "ShinobiMacros.h"

/**
 The gesture manager contains all of the gestures used by a ShinobiChart, along
 with gesture-related properties which enable certain gestures.
 */
@interface SChartGestureManager : NSObject

- (instancetype)init __attribute__((unavailable));
+ (instancetype)new __attribute__((unavailable));

/** The pinch and pan gesture recognizer - by default this triggers panning and zooming on the chart.
 
    NOTE: This recognizer is only enabled if the chart is not a pie/donut chart and `panType` is set to `SChartGesturePanTypePanPinch`.
 */
@property(nonatomic, strong, readonly) UIPanGestureRecognizer *pinchAndPanGesture;

/** The box gesture recognizer - by default this triggers the 'box zoom' functionality on the chart.
 
    NOTE: This recognizer is only enabled if the chart is not a pie/donut chart and `panType` is set to `SChartGesturePanTypeBoxDraw`.
 */
@property(nonatomic, strong, readonly) UIGestureRecognizer *boxGesture;

/** The double tap gesture - by default this triggers zooming in / reset zoom functionality.
 
    NOTE: This recognizer is only enabled if the chart is not a pie/donut chart and `doubleTapEnabled` is set to true.
 */
@property(nonatomic, strong, readonly) UITapGestureRecognizer *doubleTapGesture;

/** The single tap gesture - by default this triggers selection functionality.
 
    NOTE: This recognizer is only enabled if the chart is not a pie/donut chart and any of the series are selectable or have the crosshair enabled.
 */
@property(nonatomic, strong, readonly) UITapGestureRecognizer *singleTapGesture;

/** The radial tap gesture - by default this triggers selection of pie/donut slices.
 
    NOTE: This recognizer is only enabled if the chart is a pie/donut chart and `radialRotationEnabled` is set to true.
 */
@property(nonatomic, strong, readonly) UITapGestureRecognizer *radialTapGesture;

/** The long press gesture - by default this triggers the crosshair functionality.
 
    NOTE: This recognizer is only enabled if the chart is not a pie/donut chart and at least one of the series has a crosshair enabled.
 */
@property(nonatomic, strong, readonly) UILongPressGestureRecognizer *longPressGesture;

/** The radial rotation gesture - by default this triggers rotating pies/donuts.
 
    NOTE: This recognizer is only enabled if the chart is a pie/donut chart and `radialRotationEnabled` is set to true.
 */
@property(nonatomic, strong, readonly) UIPanGestureRecognizer *radialRotationGesture;

/** A convenience method which returns all gestures on the chart */
- (NSArray SC_GENERIC(UIGestureRecognizer *) *)gestures;

/** Set the method for zooming the chart

 - SChartGesturePanTypeNone: This property disables pan gestures on the chart.
 - SChartGesturePanTypePanPinch: Configures the chart to use pinch zoom gestures.
 - SChartGesturePanTypeBoxDraw: Configures the chart to use touch gestures to generate a box on the chart. The chart will animate the zoom level to display the area marked by the box.

 Defaults to `SChartGesturePanTypePanPinch` */
@property (nonatomic) SChartGesturePanType panType;

/** When set to `YES` all of the axis will zoom the same amount

 The chart will maintain its aspect ratio regardless of the type or orientation of gesture. */
@property (nonatomic) BOOL pinchAspectLock;

/** When set to `YES` the double-tap gesture is enabled, and its behaviour obeys the `gestureDoubleTapResetsZoom` property.

 Otherwise, if set to `NO` the chart's double tap gesture recognizer will be disabled.

 By default, this property is set to `YES`. */
@property (nonatomic) BOOL doubleTapEnabled;

/** When set to `YES` the _double-tap_ gesture will reset the zoom level to _default_

 Otherwise, if set to `NO` the chart will zoom in  a set amount.

 By default, this property is set to `NO`. */
@property (nonatomic) BOOL doubleTapResetsZoom;

/** When set to `YES` the zoom resulting from a box gesture will animate to the new zoom level

 By default, this property is set to `YES`. */
@property (nonatomic) BOOL animateBoxGesture;

/** When set to `YES` the zoom resulting from a pinch gesture will animate to the new zoom level

 By default, this property is set to `YES`. */
@property (nonatomic) BOOL animateZoomGesture;

/** When set to `YES` the radial-chart single tap gesture is enabled

 Otherwise, if set to `NO` the radial chart's tap gesture recognizer will be disabled.

 By default, this property is set to `YES`. */
@property (nonatomic) BOOL radialTapEnabled;

/** When set to `YES` the radial-chart rotation gesture is enabled

 Otherwise, if set to `NO` the radial chart's rotation gesture recognizer will be disabled.

 By default, this property is set to `YES`.

 In order for radial series to respond to rotation gestures, they must also have their `gesturePanningEnabled` property set to `YES`. See `SChartDonutSeries` for documentation on this property.

 @see SChartDonutSeries
 */
@property (nonatomic) BOOL radialRotationEnabled;

@end
