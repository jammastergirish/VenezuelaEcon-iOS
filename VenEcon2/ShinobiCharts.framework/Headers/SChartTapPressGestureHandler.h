//
//  SChartTapPressGestureHandler.h
//  ShinobiControls
//
//  Copyright 2015 Scott Logic Ltd. All rights reserved.
//
//

#import <Foundation/Foundation.h>

#import "SChartGestureHandler.h"

@class ShinobiChart, SChartGestureManager;

@interface SChartTapPressGestureHandler : SChartGestureHandler

- (instancetype)initWithChart:(ShinobiChart *)chart NS_UNAVAILABLE;

- (instancetype)initWithGestureManager:(SChartGestureManager *)gestureManager
                                 chart:(ShinobiChart *)chart
NS_DESIGNATED_INITIALIZER;

@end
