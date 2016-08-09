//
//  SChartAxisTitleStyle.h
//  SChart
//
//  Copyright 2011 Scott Logic Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SChartTitleStyle.h"

typedef NS_ENUM(NSInteger, SChartAxisTitleOrientation) {
    SChartAxisTitleOrientationHorizontal,
    SChartAxisTitleOrientationVertical
};

/** The axis title style object controls the look and feel for the axis title.
 
 @available Standard
 @available Premium
 
 @warning Axis titles are not currently supported by radial charts.
 */
@interface SChartAxisTitleStyle : SChartTitleStyle <NSCopying>

/** One of the preset orientations for the title
 
 - SChartAxisTitleOrientationHorizontal: Configures axis title orientation to be horizontal.
 - SChartAxisTitleOrientationVertical: Configures axis title orientation to be vertical.
*/
@property (nonatomic) SChartAxisTitleOrientation titleOrientation;

/** Supplements this style object by taking styles this object doesn't have, from the argument, `style` */
-(void)supplementStyleFromStyle:(SChartAxisTitleStyle *)style;

@end
