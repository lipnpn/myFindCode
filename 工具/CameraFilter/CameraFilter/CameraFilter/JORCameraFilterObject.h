//
//  JORCameraFilterObject.h
//  CameraFilter
//
//  Created by jor on 16/4/13.
//  Copyright © 2016年 wang yong. All rights reserved.
//

#import "JORDisplayView.h"
#import <AVFoundation/AVFoundation.h>

typedef NS_ENUM(NSInteger, State)
{
    STATE_ERROR = -1,
    STATE_NORMAL = 0
};

@protocol VideoCameraFilterDelegate <NSObject>

@optional
- (void)cameraOutputBuffer:(CVPixelBufferRef)pixelBuffer;
@end


@interface JORCameraFilterObject : NSObject

@property(nonatomic, weak) id<VideoCameraFilterDelegate> delegate;

- (instancetype)initWithAVCaptureSessionPreset:(NSString *const)sessionPreset position:(AVCaptureDevicePosition)position;

- (State)setDisplayView:(JORDisplayView*)view;

- (void)setOutputBufferWidth:(NSInteger)width;
- (void)setOutputBufferHeight:(NSInteger)height;


- (void)openCaptureTorch:(BOOL)au;

- (void)swapFrontAndBackCameras;


- (void)focusInPoint:(CGPoint)devicePoint;

/** Start camera capturing
 */
- (void)startCameraCapture;

/** Stop camera capturing
 */
- (void)stopCameraCapture;

/** Pause camera capturing
 */
- (void)pauseCameraCapture;

/** Resume camera capturing
 */
- (void)resumeCameraCapture;

- (void *)getCurrentFilter;

- (void)setCurrentFilter:(void *)filter;
- (void)setFilterWithImage:(NSString *)imageName;
- (void)useBlurFilter;

- (void)capturePhotoAsImageProcessedUpToFilter:(void *)finalFilterInChain withCompletionHandler:(void (^)(UIImage *processedImage, NSError *error))block;

@end
