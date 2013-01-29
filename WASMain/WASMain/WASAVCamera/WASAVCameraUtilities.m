//
//  WASAVCameraUtilities.m
//  WASMain
//
//  Created by allen.wang on 8/8/12.
//  Copyright (c) 2012 b5m. All rights reserved.
//

#import "WASAVCameraUtilities.h"
#import <AVFoundation/AVFoundation.h>


@implementation WASAVCameraUtilities

+ (AVCaptureConnection *)connectionWithMediaType:(NSString *)mediaType fromConnections:(NSArray *)connections
{
	for ( AVCaptureConnection *connection in connections ) {
		for ( AVCaptureInputPort *port in [connection inputPorts] ) {
			if ( [[port mediaType] isEqual:mediaType] ) {
				return connection;
			}
		}
	}
	return nil;
}
@end
