//
//  AlignmentConstants.h
//  WASUtility
//
//  Created by allen.wang on 9/17/12.
//  Copyright (c) 2012 b5m. All rights reserved.
//

#import "BaseMarcos.h"


/**
 * 水平对齐常量.
 */
typedef enum {
	H_ALIGN_LEFT = 0,
	H_ALIGN_CENTER = 1,
	H_ALIGN_RIGHT = 2,
} HAlign;

/**
 * 垂直对齐常量.
 */
typedef enum {
	V_ALIGN_TOP = 0,
	V_ALIGN_CENTER = 1,
	V_ALIGN_BOTTOM = 2,
} VAlign;

CG_INLINE NSString*
FormatHAlign(HAlign value) {
    switch (value) {
        case H_ALIGN_LEFT:
            return @"Left";
        case H_ALIGN_CENTER:
            return @"Center";
        case H_ALIGN_RIGHT:
            return @"Right";
        default:
            __FAIL(@"Unknown hAlign: %d", value);
    }
}

CG_INLINE NSString*
FormatVAlign(VAlign value) {
    switch (value) {
        case V_ALIGN_TOP:
            return @"Top";
        case H_ALIGN_CENTER:
            return @"Center";
        case V_ALIGN_BOTTOM:
            return @"Bottom";
        default:
            __FAIL(@"Unknown VAlign: %d", value);
    }
}

CG_INLINE CGRect
alignSizeWithinRect(CGSize size, CGRect rect, HAlign hAlign, VAlign vAlign) {
    CGRect result;
    result.size = size;
    
    switch (hAlign) {
        case H_ALIGN_LEFT:
            result.origin.x = 0;
            break;
        case H_ALIGN_CENTER:
            result.origin.x = (rect.size.width - size.width) / 2;
            break;
        case H_ALIGN_RIGHT:
            result.origin.x = rect.size.width - size.width;
            break;
        default:
            __FAIL(@"Unknown hAlign: %d", hAlign);
            break;
    }
    switch (vAlign) {
        case V_ALIGN_TOP:
            result.origin.y = 0;
            break;
        case V_ALIGN_CENTER:
            result.origin.y = (rect.size.height - size.height) / 2;
            break;
        case V_ALIGN_BOTTOM:
            result.origin.y = rect.size.height - size.height;
            break;
        default:
            __FAIL(@"Unknown vAlign: %d", vAlign);
            break;
    }
    result.origin = CGPointRound(CGPointAdd(result.origin, rect.origin));
    return result;
}

