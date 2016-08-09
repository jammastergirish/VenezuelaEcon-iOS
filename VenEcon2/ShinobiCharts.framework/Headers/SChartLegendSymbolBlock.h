//
//  SChartLegendSymbolBlock.h
//  ShinobiControls_Source
//
//

#import "SChartLegendSymbol.h"

@interface SChartLegendSymbolBlock : SChartLegendSymbol

@property (nonatomic, retain)   UIColor *areaColor;
@property (nonatomic, retain)   UIColor *outlineColor;

- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;

-(id)initWithAreaColor:(UIColor *)aColor
       andOutlineColor:(UIColor *)oColor
    NS_DESIGNATED_INITIALIZER;

@end
