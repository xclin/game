//
//  WTMGlyphDetector.h
//  WTMGlyph
//
//  Created by Brit Gardner on 5/1/11.
//  Copyright 2011 Warrior Thief Mage Studios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WTMGlyph.h"
#import "WTMDetectionResult.h"
#import "LQConstants.h"
@interface WTMGlyphDetector : NSObject {
    NSMutableArray *points;
    NSMutableArray *glyphs;
    NSInteger timeoutSeconds;
    NSTimeInterval lastPointTime;
}
@property (nonatomic, strong) NSMutableArray *glyphNamesArray;
@property (nonatomic, strong) NSMutableArray *points;
@property (nonatomic, strong) NSMutableArray *glyphs;
@property (nonatomic, assign) NSInteger timeoutSeconds;
LQSingletonInstanceHMethod
- (void)addGlyph:(WTMGlyph *)glyph;
- (void)addGlyphFromJSONObject:(NSArray *)jsonObject name:(NSString *)name;
- (void)removeGlyphByName:(NSString *)name;

- (void)addPoint:(CGPoint)point;
- (void)removeAllPoints;
- (void)removeAllGlyphs;

- (WTMDetectionResult*)detectGlyph;

- (void)detectIfTimedOut;
- (void)resetIfTimedOut;
- (void)reset;
- (BOOL)hasTimedOut;
- (BOOL)hasEnoughPoints;

@end
