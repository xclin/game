//
//  NSLayoutConstraint+MASDebugAdditions.m
//  Masonry
//
//  Created by Jonas Budelmann on 3/08/13.
//  Copyright (c) 2013 Jonas Budelmann. All rights reserved.
//

#import "NSLayoutConstraint+MASDebugAdditions.h"
#import "MASConstraint.h"
#import "MASLayoutConstraint.h"

@implementation NSLayoutConstraint (MASDebugAdditions)

#pragma mark - description maps

+ (NSDictionary *)layoutRelationDescriptionsByValue {
    static dispatch_once_t once;
    static NSDictionary *descriptionMap;
    dispatch_once(&once, ^{
        descriptionMap = @{
            @(NSLayoutRelationEqual)                : @"==",
            @(NSLayoutRelationGreaterThanOrEqual)   : @">=",
            @(NSLayoutRelationLessThanOrEqual)      : @"<=",
        };
    });
    return descriptionMap;
}

+ (NSDictionary *)layoutAttributeDescriptionsByValue {
    static dispatch_once_t once;
    static NSDictionary *descriptionMap;
    dispatch_once(&once, ^{
        descriptionMap = @{
            @(NSLayoutAttributeTop)      : @"top",
            @(NSLayoutAttributeLeft)     : @"left",
            @(NSLayoutAttributeBottom)   : @"bottom",
            @(NSLayoutAttributeRight)    : @"right",
            @(NSLayoutAttributeLeading)  : @"leading",
            @(NSLayoutAttributeTrailing) : @"trailing",
            @(NSLayoutAttributeWidth)    : @"width",
            @(NSLayoutAttributeHeight)   : @"height",
            @(NSLayoutAttributeCenterX)  : @"centerX",
            @(NSLayoutAttributeCenterY)  : @"centerY",
            @(NSLayoutAttributeBaseline) : @"baseline",
            
#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000) || (__MAC_OS_X_VERSION_MIN_REQUIRED >= 101100)
            @(NSLayoutAttributeFirstBaseline) : @"firstBaseline",
            @(NSLayoutAttributeLastBaseline) : @"lastBaseline",
#endif
            
#if TARGET_OS_IPHONE || TARGET_OS_TV
            @(NSLayoutAttributeLeftMargin)           : @"leftMargin",
            @(NSLayoutAttributeRightMargin)          : @"rightMargin",
            @(NSLayoutAttributeTopMargin)            : @"topMargin",
            @(NSLayoutAttributeBottomMargin)         : @"bottomMargin",
            @(NSLayoutAttributeLeadingMargin)        : @"leadingMargin",
            @(NSLayoutAttributeTrailingMargin)       : @"trailingMargin",
            @(NSLayoutAttributeCenterXWithinMargins) : @"centerXWithinMargins",
            @(NSLayoutAttributeCenterYWithinMargins) : @"centerYWithinMargins",
#endif
            
        };
    
    });
    return descriptionMap;
}


+ (NSDictionary *)layoutPriorityDescriptionsByValue {
    static dispatch_once_t once;
    static NSDictionary *descriptionMap;
    dispatch_once(&once, ^{
#if TARGET_OS_IPHONE || TARGET_OS_TV
        descriptionMap = @{
            @(MASLayoutPriorityDefaultHigh)      : @"high",
            @(MASLayoutPriorityDefaultLow)       : @"low",
            @(MASLayoutPriorityDefaultMedium)    : @"medium",
            @(MASLayoutPriorityRequired)         : @"required",
            @(MASLayoutPriorityFittingSizeLevel) : @"fitting size",
        };
#elif TARGET_OS_MAC
        descriptionMap = @{
            @(MASLayoutPriorityDefaultHigh)                 : @"high",
            @(MASLayoutPriorityDragThatCanResizeWindow)     : @"drag can resize window",
            @(MASLayoutPriorityDefaultMedium)               : @"medium",
            @(MASLayoutPriorityWindowSizeStayPut)           : @"window size stay put",
            @(MASLayoutPriorityDragThatCannotResizeWindow)  : @"drag cannot resize window",
            @(MASLayoutPriorityDefaultLow)                  : @"low",
            @(MASLayoutPriorityFittingSizeCompression)      : @"fitting size",
            @(MASLayoutPriorityRequired)                    : @"required",
        };
#endif
    });
    return descriptionMap;
}

@end
