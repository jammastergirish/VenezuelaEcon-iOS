//
//  SChartSpokeStyle.h
//  ShinobiControls_Source
//
//  Copyright (c) 2014 Scott Logic Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/** `SChartSpokeStyle` manages the appearance of spokes for `SChartDonutSeries` and `SChartPieSeries` objects.
 
 Spokes provide an alternative way to display labels on a pie or donut chart. Labels are positioned outside the series with a line drawn from them to the center of the slice.
 
 <img src="../docs/markdown_files/Images/RadialSpokesScreenshot.png"/>
 
 For spokes to be drawn, `showSpokes` must be enabled.
 
 Spokes can be enabled on a per-slice basis. Please see our [user guide](../../user_guide.html#Spokes) for a code sample.
 
 @available Standard
 @available Premium
 
 @see SChartSpokesView
 */
 
@interface SChartSpokeStyle : NSObject <NSCopying>

/** @name Spoke Properties */

/** Set the visibility of the spokes
    Default is `NO`/`false`.
 */
@property (nonatomic, assign) BOOL showSpokes;

/** Width of the spoke lines in points.
    Default is 1.
 */
@property (nonatomic, assign) CGFloat width;

/** Color of the spoke lines.
    Default is black.
 */
@property (nonatomic, retain) UIColor *color;

/** Length of the spoke, starting from the anchor point.
    Default is half the slice's radius + 40.
 */
@property (nonatomic, assign) CGFloat length;

/** Amount of space between the label and the line joins, in points.
    Default is 10.
 */
@property (nonatomic, assign) CGFloat labelPadding;

/** @name Anchor Circle Properties */

/** Starting point of the spoke relative to the midpoint of the slice, in points.
 Default is 0.
 */
@property (nonatomic, assign) CGFloat anchorOffset;

/** The radius of the circle from which the line extends out of the pie/donut, in points.
    Default is 5.
 */
@property (nonatomic, assign) CGFloat anchorRadius;

/** Color of the circle.
    Default is black.
 */
@property (nonatomic, retain) UIColor *anchorColor;

/** Updates this style object using the settings from the passed-in style.
 
 @param style The style with which to configure this style object.
 */
- (void)supplementStyleFromStyle:(SChartSpokeStyle *)style;

@end
