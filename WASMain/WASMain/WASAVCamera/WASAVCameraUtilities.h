//
//  WASAVCameraUtilities.h
//  WASMain
//
//  Created by allen.wang on 8/8/12.
//  Copyright (c) 2012 b5m. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AVCaptureConnection;

@interface WASAVCameraUtilities : NSObject {
    
}

+ (AVCaptureConnection *)connectionWithMediaType:(NSString *)mediaType fromConnections:(NSArray *)connections;

@end
