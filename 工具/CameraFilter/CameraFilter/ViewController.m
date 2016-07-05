//
//  ViewController.m
//  CameraFilter
//
//  Created by wangyong on 16/4/16.
//  Copyright (c) 2016年 tony. All rights reserved.
//

#import "ViewController.h"
#import "JORCameraFilterObject.h"
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "JORDisplayView.h"


#define ScreenWidth [[UIScreen mainScreen] bounds].size.width
#define ScreenHeight [[UIScreen mainScreen] bounds].size.height

@interface ViewController ()
@property (nonatomic, strong) JORCameraFilterObject *cameraFilterObject;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //效果非常赞的美颜滤镜 有想买的请 QQ50787460
    JORDisplayView *displayView = [[JORDisplayView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:displayView];
    
    //高性能美颜
    self.cameraFilterObject = [[JORCameraFilterObject alloc] initWithAVCaptureSessionPreset:AVCaptureSessionPreset640x480 position:AVCaptureDevicePositionFront];
    [_cameraFilterObject setDisplayView:displayView];
    [_cameraFilterObject startCameraCapture];
    
    
//    [_cameraFilterObject setFilterWithImage:@"filter_light.jpg"];
//    [_cameraFilterObject setFilterWithImage:@"filter_1987.jpg"];
//    [_cameraFilterObject setFilterWithImage:@"filter_black.jpg"];
//    [_cameraFilterObject setFilterWithImage:@"filter_young.jpg"];
//    [_cameraFilterObject useBlurFilter];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
