//
//  SChartTickMark+Deprecated.h
//  ShinobiCharts
//
//  Copyright Scott Logic Ltd 2015. All rights reserved.
//
//

#import "SChartTickMark.h"

@interface SChartTickMark ()

/* Create a tick mark with a particular label. */
- (id)initWithLabel:(CGRect)labelFrame
            andText:(NSString *)text
DEPRECATED_MSG_ATTRIBUTE("Use 'init'");

@property (nonatomic) BOOL overAlternateStripe DEPRECATED_ATTRIBUTE;

- (CGFloat)tickLengthModifier DEPRECATED_ATTRIBUTE;

- (void)removeTickMarkView DEPRECATED_ATTRIBUTE;

- (void)removeGridLineView DEPRECATED_ATTRIBUTE;

- (void)removeGridStripeView DEPRECATED_ATTRIBUTE;

- (void)disableTick:(SChartAxis *) axis DEPRECATED_MSG_ATTRIBUTE("Use tickEnabled instead.");

@end
