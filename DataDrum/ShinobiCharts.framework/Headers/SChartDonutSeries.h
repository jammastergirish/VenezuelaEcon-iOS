//
//  SChartDonutSeries.h
//  SChart
//
//  Copyright 2011 Scott Logic Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SChartRadialSeries.h"
#import "SChartAnimation.h"

@protocol SChartDatasource;
@class SChartDonutSeriesStyle, SChartSpokesView, SChartSpokeStyle;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, SChartRadialSeriesDrawDirection) {
    SChartRadialSeriesDrawDirectionAntiClockwise,
    SChartRadialSeriesDrawDirectionClockwise
};

/** `SChartDonutSeries` displays magnitude data on the chart - the larger the value of the data point, the larger the slice representing that data point.
 
   <img src="../docs/markdown_files/Images/userguide_donutSeries.png" width=300/>
 
 A donut series contains an instance of `SChartDonutSeriesStyle`, which manages its appearance.
 
 You can configure the radius of the slices in the chart, and how big the hole in the middle of the donut is.  See `innerRadius` and `outerRadius` for more information.
 
 When a slice is selected in the chart, it protrudes out of the donut, and rotates to a given position.  You can set the amount of protrusion which a selected slice has by setting the `[SChartDonutSeriesStyle protrusion]` property on the series `selectedStyle`.  You can set the position it rotates to using the `selectedPosition` property.  The series contains an instance of `SChartAnimation` which describes the motion of the slice as it rotates to its selected position.  See `selectionAnimation` for more information.
 
 You can enable panning on a donut series.  If panning is enabled, performing a swipe gesture on the series will cause it to rotate.  Whether panning is enabled is controlled by the `gesturePanningEnabled` property.  By default this is set to `NO`.
 
 Legends on donut charts show an entry for each data point, or slice, of the donut series.
 
 @available Standard
 @available Premium
 @sa ChartsUserGuide
 @sample PieChart
*/
@interface SChartDonutSeries : SChartRadialSeries

#pragma mark -
#pragma mark Styling
/**@name Styling */

/** Manages the appearance of the donut series on the chart.
 
 The default settings of the style are inherited from the chart theme.  You can tweak the appearance of the series by modifying the style.
 
 @see SChartDonutSeriesStyle
 */
-(SChartDonutSeriesStyle *)style;

/** Sets the style object for the donut series.
 
 @param style The new style object to use for the donut series.
 @see style
 */
-(void)setStyle:(SChartDonutSeriesStyle *)style;

/** Manages the appearance of the donut series when it is selected.
 
 Style settings in this object will be applied when the series is marked as selected (or a slice is selected).
 
 The default settings of the style are inherited from the chart theme.  You can tweak the appearance of the series by modifying the style.
 
 @see SChartDonutSeriesStyle
 */
-(SChartDonutSeriesStyle *)selectedStyle;

/** Sets the style object for the scatter series when it is selected.
 
 @param selectedStyle The new style object to use.
 @see selectedStyle
 */
-(void)setSelectedStyle:(SChartDonutSeriesStyle *)selectedStyle;

/**
 Set a spoke's style for a specific slice.
 
 This enables spokes to be styled individually on a slice-by-slice basis.
 
 NOTE: `SChartSpokeStyle` conforms to NSCopying, therefore custom styles can use the
 series' default or selected spoke styles as a foundation for any alterations.
 
 Any changes made to the spoke's style will be overriden following the next draw cycle.
 The recommended method to set per-slice spoke styles is in SChartDelegate's
 sChart:alterLabel:forDatapoint:atSliceIndex:inRadialSeries:

 @param spokeStyle The style defining the spoke's attributes for the next draw cycle
 @param sliceIndex The slice index of the spoke the style should apply to
 */
- (void)setSpokeStyle:(SChartSpokeStyle *)spokeStyle forSpokeAtSliceIndex:(NSInteger)sliceIndex;

/** A format string to use for the labels which annotate data within a radial series.
 
 A typical example of the labels would be the labels on each slice in a pie chart.
 
 This defaults to @"%.2f"
 */
@property (nonatomic, retain) NSString *labelFormatString;

#pragma mark -
#pragma mark Information about the series
/** @name Information about the series */

/** The inner radius of the series, in points. */
@property (nonatomic) CGFloat innerRadius;

/** The outer radius of the series, in points. */
@property (nonatomic) CGFloat outerRadius;

/** The current rotation of the series, in radians. */
@property (nonatomic) CGFloat rotation;

/** Returns the center of the donut, within the chart frame. */
-(CGPoint)getDonutCenter;

/** Returns the center of the slice at a given index, within the chart frame.
 @param sliceIndex The index of the slice in which we are interested.
 */
- (CGPoint)getSliceCenter:(NSInteger)sliceIndex;

/** Returns the index of the slice in the donut series which is at the given angle in radians.
 @param rads The angle in radians at which we wish to find the donut slice.
 */
-(NSInteger)indexOfSliceAtAngle:(double)rads;

#pragma mark -
#pragma mark Selection
/** @name Selection */

/** The angle to which the slice will rotate once selected, in radians. */
@property (nonatomic, retain) NSNumber *selectedPosition;


/** An animation object describing the motion of the donut series when a slice is selected.
 
 The `angleCurve` of the animation describes any rotation of the series from its current position to its selected position.
 The `radiusCurve` describes the animation of any increase or decrease in the protrusion of the slice as a result of being selected or deselected.
 @see SChartAnimation
 */
@property (nonatomic, retain) SChartAnimation *selectionAnimation;

/** Select or deselect a slice within the series. 
 @param sliceIndex The index of the slice in the series to select or deselect.
 @param sel `YES` if we are selecting the slice.  `NO` otherwise.
 */
-(void)setSlice:(NSInteger)sliceIndex asSelected:(BOOL)sel;

#pragma mark -
#pragma mark Panning
/** @name Panning */

/** Defines whether or not panning is enabled on this series.
 
 If panning is enabled, performing a swipe gesture on the series will cause it to rotate.
 The series will stay under your finger whilst your finger remains on the series.  Once you lift your finger, the series will begin to decelerate.  The `rotationFriction` property controls the rate at which the series will decelerate.
 
 The default value for this property is `NO`.
 */
@property (nonatomic) BOOL gesturePanningEnabled;

/** By default, tapping on a radial series during panning will just stop the pan.  If this property is enabled, tapping on a slice in the series will select that slice.  This property defaults to `NO`.
 
 If this property is enabled, and `selectedPosition` is not set to a value, the donut series will keep spinning whilst a slice moves out.  The same is true for the case where a slice moves in once it is deselected.
 */
@property (nonatomic, assign) BOOL selectionEnabledDuringPanning;

/** The amount of friction applied to this pie series after a rotation (pan) gesture finishes, and the series begins to decelerate.
 
 The friction is defined as the percentage of decay of velocity per frame. The default value is 0.02, or 2%.
 */
@property (nonatomic) CGFloat rotationFriction;

#pragma mark -
#pragma mark Drawing the series
/** @name Drawing the series */

/** The direction in which data is drawn around the centre of the plot.
 
 - SChartRadialSeriesDrawDirectionClockwise: Configures the direction in which the data is drawn around the center of the plot to be clockwise.
 - SChartRadialSeriesDrawDirectionAntiClockwise: Configures the direction in which the data is drawn around the center of the plot to be anticlockwise.
 
 This defaults to `SChartRadialSeriesDrawDirectionAntiClockwise`.
 */
@property (nonatomic) SChartRadialSeriesDrawDirection drawDirection;

/** Creates the labels for the slices in the donut series, and displays them on the chart. 
 
 The labels are displayed on each slice in the series.
 
 @param datasource The datasource for the chart. The series gets the labels from the datasource, then displays them in the correct position on the chart.
 @param chart The chart containing the donut series.
 */
-(void)createLabels:(id <SChartDatasource>)datasource onChart:(ShinobiChart *)chart;

#pragma mark -
#pragma mark Rotate a slice
/** @name Rotate a slice */

/** Rotates the specified slice to the specified angle in radians, with the provided animation.
 
 @param index The index of the slice in the series to rotate.
 @param rads The angle to which to rotate the specified slice, in radians.
 @param animation The animation to use during the rotation.
 */
-(void)rotateSliceAtIndex:(NSInteger)index toAngle:(double)rads withAnimation:(SChartAnimation *)animation;

@end

NS_ASSUME_NONNULL_END
