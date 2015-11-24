//
//  ITunesImage.m
//  FlipCourse
//
//  Created by JohnLv on 14-3-5.
//  Copyright (c) 2014年 John. All rights reserved.
//

#import "ITunesImage.h"
#import "ALAssetsLibrary+CustomPhotoAlbum.h"
@implementation ITunesImage
{
    NSMutableArray *listOfImages;
    NSMutableArray *listOfPath;
}

-(void)initObj
{
    if (!listOfImages) {
        listOfImages = [NSMutableArray new];
    }
    if (!listOfPath) {
        listOfPath = [NSMutableArray new];
    }
    if (!self.library) {
        self.library = [ALAssetsLibrary new];
    }
}

-(void)addPhotoFromiTunes
{
    [self initObj];
    NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
//    NSDirectoryEnumerator *dirEnum = [fileManager enumeratorAtPath:filePath];
    NSArray *dirContents = [fileManager contentsOfDirectoryAtPath:filePath error:nil];
    
    
    NSString *fileName;
//    while (fileName = [dirEnum nextObject])
    for (int i=0; i<[dirContents count]; i++)
    {
        fileName = dirContents[i];
        NSString *ext = [[fileName pathExtension] lowercaseString];
        if ([ext isEqualToString: @"png"] || [ext isEqualToString: @"jpg"] || [ext isEqualToString:@"bmp"] || [ext isEqualToString:@"jepg"])
        {
            NSString *fullName = [NSString stringWithFormat:@"%@/%@",filePath,fileName];
            UIImage *image = [UIImage imageWithContentsOfFile:fullName];
            if (image) {
                [listOfPath addObject:fullName];
                [listOfImages addObject:image];
            }
            
            continue;
        }
    }
    [self saveNext];
}

-(void) saveNext{
	if (listOfImages.count > 0) {
		UIImage *image = [listOfImages objectAtIndex:0];
		[self.library saveImage:image toAlbum:@"File Share" withCompletionBlock:^(NSError *error) {
            if (error!=nil) {
                NSLog(@"Big error: %@", [error description]);
            }
            [listOfImages removeObjectAtIndex:0];
            [self saveNext];
        }];
	}
	else {
		[self allDone];
	}
}


-(void)allDone
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *err;
    while ([listOfPath count]>0) {
        [fileManager removeItemAtPath:listOfPath[0] error:&err];
        [listOfPath removeObjectAtIndex:0];
    }
    
    if (_iTunesCallBack) {
        _iTunesCallBack(YES);
    }
}

@end
