//
//  WTMGlyphTemplate.m
//  WTMGlyph
//
//  Created by Brit Gardner on 5/15/11.
//  Copyright 2011 Warrior Thief Mage Studios. All rights reserved.
//
//  A collection of points representing the unistroke of a
//  multistroke.

#import "WTMGlyphTemplate.h"
#import "WTMGlyphUtilities.h"
#import "WTMGlyphDefaults.h"

@implementation WTMGlyphTemplate

@synthesize name;
@synthesize vector;

- (void)dealloc
{
    free(vector.items);
}
- (id)initWithName:(NSString *)_name points:(NSArray *)_points {
    if ((self = [super init])) {
        self.name = _name;
        // Resample the points
        NSArray *resampled = Resample(_points, WTMGlyphResamplePointsCount);
        // Scale points to the desired resolution
        NSArray *scaled = Scale(resampled, WTMGlyphResolution, WTMGlyph1DThreshold);
        // Translate points to 0,0
        NSArray *translated = TranslateToOrigin(scaled);
        self.vector = Vectorize(translated);
        self.startUnitVector = CalcStartUnitVector(translated, WTMGlyphStartAngleIndex);
    }
    return self;
}
@end
