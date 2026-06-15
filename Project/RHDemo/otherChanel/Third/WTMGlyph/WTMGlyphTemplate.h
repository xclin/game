//
//  WTMGlyphTemplate.h
//  WTMGlyph
//
//  Created by Brit Gardner on 5/15/11.
//  Copyright 2011 Warrior Thief Mage Studios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WTMGlyphUtilities.h"

@interface WTMGlyphTemplate : NSObject
@property (nonatomic, retain) NSString *name;
@property (nonatomic, assign) FloatArrayContainer vector;
@property (nonatomic, assign) CGPoint startUnitVector;
- (id)initWithName:(NSString *)_name points:(NSArray *)_points;
@end
