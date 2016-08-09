//
//  SChartDateFrequency+Deprecated.h
//  ShinobiCharts
//
//  Copyright Scott Logic Ltd 2015. All rights reserved.
//
//

#import "SChartDateFrequency.h"

@interface SChartDateFrequency ()

/* Initializes and returns a newly allocated date frequency object, with a frequency of the specified number of weeks.
 @param newWeek The frequency of the new object, in weeks.
 @return An initialized date frequency object, or `nil` if the object couldn't be created.
 */
- (id)initWithWeek:(NSInteger)newWeek
DEPRECATED_MSG_ATTRIBUTE("Use initWithWeekOfMonth or initWithWeekOfYear, depending on which you mean")
NS_DESIGNATED_INITIALIZER;

/* Returns a new date frequency object, with a frequency of the specified number of weeks.
 @param newWeek The frequency to use, in weeks. */
+ (id)dateFrequencyWithWeek:(NSInteger)newWeek DEPRECATED_MSG_ATTRIBUTE("Use dateFrequencyWithWeekOfMonth or dateFrequencyWithWeekOfYear, depending on which you mean");

/* Set the date frequency to have a value of the specified number of weeks.
 
 Before the new value is set, we clear any existing values in the object.
 @param v The new frequency to set, in weeks. */
- (void)setWeek:(NSInteger)v DEPRECATED_MSG_ATTRIBUTE("Use weekOfMonth or weekOfYear, depending on which you mean");

/* Returns the frequency of the object, measured in seconds. */
- (double)toSeconds DEPRECATED_MSG_ATTRIBUTE("This is used as a rough heuristic for sorting and not intended for use in user-code");

/* DEPRECATED - We will remove this from the public API in a future commit, as it is only intended for internal use. */
- (NSInteger)year DEPRECATED_ATTRIBUTE;

/* DEPRECATED - We will remove this from the public API in a future commit, as it is only intended for internal use. */
- (NSInteger)month DEPRECATED_ATTRIBUTE;

/* DEPRECATED - We will remove this from the public API in a future commit, as it is only intended for internal use. */
- (NSInteger)week DEPRECATED_MSG_ATTRIBUTE("Use weekOfMonth or weekOfYear, depending on which you mean");

/* DEPRECATED - We will remove this from the public API in a future commit, as it is only intended for internal use. */
- (NSInteger)day DEPRECATED_ATTRIBUTE;

/* DEPRECATED - We will remove this from the public API in a future commit, as it is only intended for internal use. */
- (NSInteger)hour DEPRECATED_ATTRIBUTE;

/* DEPRECATED - We will remove this from the public API in a future commit, as it is only intended for internal use. */
- (NSInteger)minute DEPRECATED_ATTRIBUTE;

/* DEPRECATED - We will remove this from the public API in a future commit, as it is only intended for internal use. */
- (NSInteger)second DEPRECATED_ATTRIBUTE;

@end
