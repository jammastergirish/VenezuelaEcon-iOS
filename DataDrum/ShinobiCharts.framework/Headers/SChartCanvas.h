//
//  SChartCanvas.h
//  SChart
//
//  Copyright 2011 Scott Logic Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SChartGLView;
@class SChartCanvasOverlay;
@class SChartCanvasUnderlay;
@class SChartCanvasRenderView;
@class ShinobiChart;

NS_ASSUME_NONNULL_BEGIN

/**
 For each ShinobiChart, one single SChartCanvas will exist to contain the drawing of all of the axes and series. Titles, legends and other chart level objects appear outside of this area in the ShinobiChart view. The canvas is responsible for managing the layers that make up the axis and series.
 
 The canvas itself has no objects drawn directly onto it. The canvas decides how much space it will need to draw any axis and their labels. The plot area view is then sized and laid down to draw the series. This is followed by the SChartCanvasOverlay layer that is used to draw the axes at the highest level.
 
 You should never need to modify this object directly.  We've included information on this class as we refer to the chart canvas at various points in our documentation.
 
 @available Standard
 @available Premium
 @see ChartsUserGuide
*/
@interface SChartCanvas : UIView

/** The chart which contains this canvas */
@property (nonatomic, assign) ShinobiChart *chart;

#pragma mark -
#pragma mark Initializing the canvas
/** @name Initializing the canvas */

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;

/**
 Initializes and returns a newly allocated canvas object with the specified frame rectangle.
 @param frame The frame rectangle for the canvas, measured in points.
 @param parentChart The chart which will contain the new canvas.
 @return An initialized canvas object, or `nil` if the object couldn't be created.
 */
- (id)initWithFrame:(CGRect)frame
         usingChart:(ShinobiChart *)parentChart
NS_DESIGNATED_INITIALIZER;

#pragma mark -
#pragma mark Gestures
/** @name Gestures */

#pragma mark -
#pragma mark Managing our drawing objects
/** @name Managing our drawing objects */

/** The underlay is the layer upon which we draw all of our axes. 
 
 We use pixel based coordinates on the underlay.
 */
@property (nonatomic, retain) SChartCanvasUnderlay* underlay;

/** This is the layer where we draw all of our annotation views that are visualised under our data */
@property (nonatomic, retain) UIView* underlayForAnnotations;

/** This is the layer upon which we draw all of our chart series and also any chart annotations.
 
 This layer is rendered using openGL and therefore uses GL based coordinates. */
@property (nonatomic, retain) SChartGLView *glView;

/** This is the layer where we render things like the crosshair. */
@property (nonatomic, retain) SChartCanvasOverlay* overlay;

@end

NS_ASSUME_NONNULL_END
