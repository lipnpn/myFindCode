//
//  ITunesImage.h
//  FlipCourse
//
//  Created by JohnLv on 14-3-5.
//  Copyright (c) 2014年 John. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
@interface ITunesImage : NSObject

@property (strong, atomic)ALAssetsLibrary *library;
-(void)addPhotoFromiTunes;

@property(strong , nonatomic) void (^iTunesCallBack) (BOOL flag);
@end
