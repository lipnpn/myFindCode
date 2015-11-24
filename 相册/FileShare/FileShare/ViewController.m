//
//  ViewController.m
//  FileShare
//
//  Created by JohnLv on 14-3-5.
//  Copyright (c) 2014年 John. All rights reserved.
//
#import "ALAssetsLibrary+CustomPhotoAlbum.h"

#import "ViewController.h"
#import "ITunesImage.h"
@interface ViewController ()
- (IBAction)btnShowPhoto:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    ALAssetsLibrary *al = [[ALAssetsLibrary alloc ] init];
    [al saveImage:[UIImage imageNamed:@"12.png"] toAlbum:@"songwent" withCompletionBlock:^(NSError *error) {
        
    }];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)getImagePicker:(NSUInteger)sourceType {
    // 跳转到相机或相册页面
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    
    imagePickerController.delegate = self;
    
    imagePickerController.allowsEditing = YES;
    
    imagePickerController.sourceType = sourceType;
    
    [self presentViewController:imagePickerController animated:YES completion:^{}];
}

#pragma mark - image picker delegte
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	[picker dismissViewControllerAnimated:YES completion:^{}];
    
    NSLog(@"did");
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
	[self dismissViewControllerAnimated:YES completion:^{}];
    NSLog(@"didn't");
}


- (IBAction)btnShowPhoto:(id)sender {
    ITunesImage *iImage = [ITunesImage new];
    [iImage setITunesCallBack:^(BOOL flag){
        if (flag == YES) {
            //导入成功
        }
        [self getImagePicker:UIImagePickerControllerSourceTypePhotoLibrary];
    }];
    [iImage addPhotoFromiTunes];
}

@end
