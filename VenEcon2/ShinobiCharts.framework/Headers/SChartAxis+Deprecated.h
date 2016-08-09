//
//  SChartAxis+Deprecated.h
//  ShinobiCharts
//
//  Created by Andrew Polkinghorn on 28/05/2014.
//
//

#import "SChartAxis.h"

@class SChartMappedSeries;
@class SChartBarColumnSeries;

@interface SChartAxis ()


/* The current _displayed_  range of the axis.
 
 This property is the actual range currently displayed on the visible area of the chart- which may not be the range that was explicitly set. The axis may make small adjustments to the range to make sure that whole bars are displayed etc. This is a `readonly` property - explicit requests to change the axis range should be made through the method `setRangeWithMinimum:andMaximum:`
 
 @see SChartRange
 @see SChartNumberRange
 @see SChartDateRange */
@property (nonatomic, retain, readonly) SChartRange *axisRange DEPRECATED_MSG_ATTRIBUTE("use 'range' instead");

#pragma mark -
#pragma mark Internal: Gestures

- (void)cancelGestures DEPRECATED_ATTRIBUTE;

- (void)stopAnimations DEPRECATED_ATTRIBUTE;

- (void)stopMomentumZooming DEPRECATED_ATTRIBUTE;

- (void)stopMomentumPanning DEPRECATED_ATTRIBUTE;

- (NSArray *)manualGenerateTickMarks DEPRECATED_ATTRIBUTE;

#pragma mark -
#pragma mark  Drawing
/* @name Drawing */

- (void)drawTickMarksWithGLFrame:(CGRect)glFrame usingAxisDrawer:(SChartCanvasUnderlay*)drawer needToRedrawLabels:(BOOL)redrawLabels DEPRECATED_ATTRIBUTE;

// Draws the axis relative to the openGl frame
- (void)drawAxisWithGLFrame:(CGRect)frame usingAxisDrawer:(SChartCanvasUnderlay *)drawer DEPRECATED_ATTRIBUTE;

- (BOOL)valueIsVisible:(double)value onSeries:(SChartSeries *)series DEPRECATED_ATTRIBUTE;

- (BOOL)ensureValueIsVisible:(double)value andRedraw:(BOOL)redraw DEPRECATED_ATTRIBUTE;

- (BOOL)ensureValueIsVisible:(double)value DEPRECATED_ATTRIBUTE;

#pragma mark -
#pragma mark Values in Data Terms
/* @name Values in Data Terms */

- (NSString *)stringForValue:(double)value DEPRECATED_MSG_ATTRIBUTE("Use `stringForId:` instead.");

- (NSString *)appropriateFormat:(id)numberObj fallbackToLabelFormatter:(BOOL)useLabelFormatter DEPRECATED_ATTRIBUTE;

- (NSString *)appropriateFormat:(id)numberObj DEPRECATED_ATTRIBUTE;

// Returns the real data represented by a glCoord (1D)
-(NSNumber *)dataValueFromCoord:(double)coord DEPRECATED_ATTRIBUTE;

// Recalculate barcolumn spacing, min and max values
- (void)recalculateBarColumns:(NSArray *)barColumnSeries DEPRECATED_ATTRIBUTE;

-(id)offsetForDataValue:(id)data inSeries: (SChartSeries *)series DEPRECATED_MSG_ATTRIBUTE("Use `offsetForSeries:` instead.");

#pragma mark -
#pragma mark Internal: Series Linking
- (BOOL)isLinkedToSeries:(SChartSeries *)series DEPRECATED_ATTRIBUTE;

- (NSArray *)ownedSeries DEPRECATED_ATTRIBUTE;

#pragma mark -
#pragma mark Internal: Data
- (id)doubleToData:(double)fp DEPRECATED_ATTRIBUTE;

#pragma mark -
#pragma mark Internal: Tick Marks
- (NSString *)longestLabel DEPRECATED_ATTRIBUTE;

- (CGSize)sizeTickLabels DEPRECATED_ATTRIBUTE;

- (NSNumber *)firstMajorTick DEPRECATED_ATTRIBUTE;

- (NSInteger)indexOfFirstLabel:(NSInteger)ticksPerLabel DEPRECATED_ATTRIBUTE;

- (BOOL)firstTickInsideChart:(double)firstTickValue DEPRECATED_ATTRIBUTE;

- (NSNumber *)firstMinorTick DEPRECATED_ATTRIBUTE;

- (BOOL)isOverAlternate:(double)tickMarkValue DEPRECATED_ATTRIBUTE;

- (void)rotateLabel:(UILabel *)tickLabel DEPRECATED_ATTRIBUTE;

#pragma mark -
#pragma mark Internal
- (void)removeViews DEPRECATED_ATTRIBUTE;

#pragma mark -
#pragma mark Internal: Range
- (void)refreshDataRange DEPRECATED_ATTRIBUTE;

- (void)updateMaxRange DEPRECATED_ATTRIBUTE;

- (BOOL)zoomWithMomentum DEPRECATED_ATTRIBUTE;

#pragma mark -
#pragma mark Internal: Panning and Zooming Internal
- (BOOL)panWithMomentumStartingAt:(double)panVelocityWrapper DEPRECATED_ATTRIBUTE;

- (BOOL)panWithMomentum DEPRECATED_ATTRIBUTE;

- (void)updateZoom DEPRECATED_ATTRIBUTE;

/* Attempts to set the current visible range `range` to a range with the given minimum and maximum values.
 
 Given any restrictions on setting the range, such as `allowPanningOutOfMaxRange` etc, this method will attempt to set the current axis range.
 
 minimum - the minimum value to be displayed, in data terms.
 maximum - the maximum value to be displayed, in data terms.
 Returns whether or not the operation was successful.
 
 The permissable types of minimum and maximum will vary depending on the type of axis in use. The range of an `SChartNumberAxis` should be set using two objects of type `NSNumber` for `minimum` and `maximum`, whilst that of an `SChartDateTimeAxis` can be configured using either `NSNumber` or `NSDate` minima and maxima. In the case of `SChartCategoryAxis`, the first value has a nominal integer value of '0' and the nth value, 'n-1'.
 
 A few examples:
 
 // Range from 20 to 140 on an SChartNumberAxis.
 [myNumberAxis setRangeWithMinimum: @20 andMaximum: @140];
 
 // Range from June 2013 to January 2014 (approx.) on an SChartDateTimeAxis.
 [myDateTimeAxis setRangeWithMinimum: [NSDate dateWithTimeIntervalSince1970: 86400.*365*43.5] andMaximum: [NSDate dateWithTimeIntervalSince1970: 86400.*365*44]];
 
 // Range between the third and fifth elements on an SChartCategoryAxis.
 [myCategoryAxis setRangeWithMinimum: @2 andMaximum: @6];
 */
- (BOOL)setRangeWithMinimum:(id)minimum andMaximum:(id)maximum DEPRECATED_MSG_ATTRIBUTE("use setRange: instead");


/* Attempts to set the current visible range `range` to a range with the given minimum and maximum values.
 
 Given any restrictions on setting the range, such as `allowPanningOutOfMaxRange` etc, this method will attempt to set the current axis range.
 This implementation allows you to explicitly set whether to animate the transition to the new range or not.
 
 animation - Whether or not to animate the range change.
 Returns whether or not the operation was successful.
 
 See `setRangeWithMinimum:andMaximum`.
 
 Changing range with animation isn't currently supported by radial charts.
 */
- (BOOL)setRangeWithMinimum:(id)minimum andMaximum:(id)maximum withAnimation:(BOOL)animation DEPRECATED_MSG_ATTRIBUTE("use setRange:withAnimation: instead");

#pragma mark -
#pragma mark Panning
/*
 Pan to a standard position.
 To set an explicit zoom use panByValue:
 
 - SChartAxisPanToStart: Pans to the start of the axis.
 - SChartAxisPanToEnd: Pans to the end of the axis.
 - SChartAxisPanToCenter: Pans to the center of the axis.
 */
- (BOOL)panTo:(SChartAxisPanTo)panLocation DEPRECATED_ATTRIBUTE;

- (BOOL)panTo:(SChartAxisPanTo)panLocation withAnimation:(BOOL)animation DEPRECATED_ATTRIBUTE;

/* Pan the axis range by an explicit amount
 
 value - the value, in data terms, by which the axis range should pan by.
 animation - whether or not the pan operation should be animated. If not animated, the pan will be instant.
 panWithBouncing - whether or not the range should 'bounce' if it strays outside of the permissable range.
 redraw - redraw the chart after the pan operation.
 
 Returns whether or not the pan operation was successful.
 
 */
- (BOOL)panByValue:(double)value withAnimation:(BOOL)animation withBounceLimits:(BOOL)panWithBouncing andRedraw:(BOOL)redraw DEPRECATED_MSG_ATTRIBUTE("Use setRange:withAnimation: instead.");

/* See `panByValue:withAnimation:andBounceLimits:andRedraw:`.
 
 */
- (BOOL)panByValue:(double)value withAnimation:(BOOL)animation withBounceLimits:(BOOL)panWithBouncing DEPRECATED_MSG_ATTRIBUTE("Use setRange:withAnimation: instead.");

/* See `panByValue:withAnimation:andBounceLimits:andRedraw:`.
 
 The range will not 'bounce' if it strays outside of the permissable range.
 */
- (BOOL)panByValue:(double)value withAnimation:(BOOL)animation DEPRECATED_MSG_ATTRIBUTE("Use setRange:withAnimation: instead.");

/* See `panByValue:withAnimation:andBounceLimits:andRedraw:`.
 
 The pan is not animated.
 The range will not 'bounce' if it strays outside of the permissable range.
 */
- (BOOL)panByValue:(double)value DEPRECATED_MSG_ATTRIBUTE("Use setRange:withAnimation: instead.");

#pragma mark - Zooming

/* Sets the zoom of the axis, based around a fixed point.
 
 zoom - the zoom level. 1.0 is the starting zoom level, 0.5 is 2x magnification, etc.
 position - the position on the axis around which to zoom in/out.
 animation - whether or not the zoom operation should be animated. If not animated, the zoom will be instant.
 bounceLimits - whether or not the range should 'bounce' if it strays outside of the permissable range.
 
 Returns whether or not the zoom operation was successful.
 */
- (BOOL)setZoom:(double)zoom fromPosition:(double)position withAnimation:(BOOL)animation andBounceLimits:(BOOL)bounceLimits DEPRECATED_MSG_ATTRIBUTE("Use setRange:withAnimation: instead.");

/* Sets the zoom of the axis, based around a fixed point.
 
 zoom - the zoom level. 1.0 is the starting zoom level, 0.5 is 2x magnification, etc.
 position - the position on the axis around which to zoom in/out.
 animation - whether or not the zoom operation should be animated. If not animated, the zoom will be instant.
 
 Return whether or not the zoom operation was successful.
 */
- (BOOL)setZoom:(double)zoom fromPosition:(double)position withAnimation:(BOOL)animation DEPRECATED_MSG_ATTRIBUTE("Use setRange:withAnimation: instead.");

/* Sets the zoom of the axis, based around the midpoint of the range.
 
 The range will not 'bounce' if it strays outside of the permissable range.
 
 zoom - the zoom level. 1.0 is the starting zoom level, 0.5 is 2x magnification, etc.
 animation - whether or not the zoom operation should be animated. If not animated, the zoom will be instant.
 */
- (BOOL)setZoom:(double)zoom withAnimation:(BOOL)animate DEPRECATED_MSG_ATTRIBUTE("Use setRange:withAnimation: instead.");

/* Sets the zoom of the axis, based around a fixed point.
 
 The zoom is not animated.
 The range will not 'bounce' if it strays outside of the permissable range.
 */
- (BOOL)setZoom:(double)z fromPosition:(double)position DEPRECATED_MSG_ATTRIBUTE("Use setRange:withAnimation: instead.");

/* Sets the zoom of the axis, based around the midpoint of the range.
 
 The zoom is not animated.
 The range will not 'bounce' if it strays outside of the permissable range.
 */
- (BOOL)setZoom:(double)s DEPRECATED_MSG_ATTRIBUTE("Use setRange:withAnimation: instead.");

/* Zoom to a set range, centred on a point.
 
 This method is for zooming in to a point using a range in data terms rather than a zoom level.
 
 point - the point on the axis around which to zoom in/out.
 range - the magnitude of the range to zoom in to - this will be centred around the point specified.
 animate - whether or not the zoom operation should be animated. If not animated, the zoom will be instant.
 bounce - whether or not the range should 'bounce' if it strays outside of the permissable range.
 */
- (void)zoomToPoint:(double)point withRange:(double)range withAnimation:(BOOL)animate usingBounceLimits:(BOOL)bounce DEPRECATED_MSG_ATTRIBUTE("Use setRange:withAnimation: instead.");

/* See `zoomToPoint:withRange:withAnimation:usingBounceLimits:`. */
- (void)zoomToPoint:(double)point withRange:(double)range DEPRECATED_MSG_ATTRIBUTE("Use setRange:withAnimation: instead.");

#pragma mark -
#pragma mark BarColumn Series
 /*
 During the next render process, forces the recalculation of the barcolumn series.
 During normal operation the panning and zooming will take place using transforms - with only periodic recalculations. Setting this to `YES` will force the bars and columns to recalculate all coordinates.
 */
@property (nonatomic) BOOL recalculateBarColumnsRequired DEPRECATED_ATTRIBUTE;

/*
 A boolean indicating if the bar and column series are already configured.
 If this is `YES` the chart will not traverse the data to work out spacing and ranges.
 */
@property (nonatomic) BOOL barColumnsConfigured DEPRECATED_ATTRIBUTE;

#pragma mark -
#pragma mark Tick Marks

@property (nonatomic, assign) CGPoint labelSizeScalers DEPRECATED_ATTRIBUTE;

- (BOOL)setRangeWithMinimum:(id)minimum andMaximum:(id)maximum withAnimation:(BOOL)animation usingBounceLimits:(BOOL)rangeChecks DEPRECATED_ATTRIBUTE;

- (BOOL)beyondAxisLimits DEPRECATED_ATTRIBUTE;

- (BOOL)beyondAxisLimitsOnBothSides DEPRECATED_ATTRIBUTE;

- (BOOL)beyondAxisMinLimit DEPRECATED_ATTRIBUTE;

- (BOOL)recheckAxisRange DEPRECATED_ATTRIBUTE;

@end
