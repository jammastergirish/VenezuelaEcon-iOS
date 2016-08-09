//
//  SChartCrosshair+Deprecated.h
//  ShinobiCharts
//
//  Copyright Scott Logic Ltd 2015. All rights reserved.
//
//

#import "SChartCrosshair.h"

@interface SChartCrosshair ()

-(id)initWithFrame:(CGRect)frame usingChart:(ShinobiChart *)parentChart DEPRECATED_MSG_ATTRIBUTE("Use initWithChart: instead.");

/* DEPRECATED - This should be taken off the API in future releases.  It is used internally, but should not be set from outside of the class. */
@property (nonatomic) BOOL enableCrosshairLinesSet DEPRECATED_ATTRIBUTE;

/* DEPRECATED - This property will be taken off the API in future releases.
 
 By default, this property is set to `UIViewAnimationOptionCurveEaseOut`. */
@property (nonatomic) UIViewAnimationOptions animationOptions DEPRECATED_ATTRIBUTE;

/* DEPRECATED - This property will be taken off the API in future releases.
 
 By default, this property is set to `0.2`. */
@property (nonatomic) CGFloat animationDuration DEPRECATED_ATTRIBUTE;

/* DEPRECATED - This property will be taken off the API in future releases.
 
 By default, this property is set to `0.2`. */
@property (nonatomic) CGFloat animationDelay DEPRECATED_ATTRIBUTE;

/* DEPRECATED - This property will be taken off the API in future releases. */
@property (nonatomic) BOOL animationEnabled DEPRECATED_ATTRIBUTE;

/* This method informs the crosshair that there was a pinch/pan gesture on the chart.
 
 The default behavior in this case is to remove the crosshair. */
-(void)crosshairChartGotPinchAndPan DEPRECATED_ATTRIBUTE;

/* This method is informs the crosshair that there was a tap gesture on the chart at a point.
 
 The default behavior in this case is to remove the crosshair.
 
 @param tap The point on the chart which was tapped.
 */
-(void)crosshairChartGotTapAt:(CGPoint)tap DEPRECATED_ATTRIBUTE;

/* This method informs the crosshair that there was a long press gesture on the chart at a point.
 
 The default behavior of the crosshair is to do nothing.  If you wish to do something with the crosshair on receiving this event, you can subclass SChartCrosshair, and override this method.
 
 @param longpress The point on the chart where the long press occurred.
 */
-(void)crosshairChartGotLongPressAt:(CGPoint)longpress DEPRECATED_ATTRIBUTE;

/* Notifies the crosshair that its parent chart reloaded its data.
 
 The default behavior in this case is to remove the crosshair. */
-(void)chartDidReload DEPRECATED_ATTRIBUTE;

@end

