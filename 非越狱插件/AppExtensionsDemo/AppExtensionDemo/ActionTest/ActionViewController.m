//
//  ActionViewController.m
//  ActionTest
//
//  Created by lipnpn on 15/11/12.
//  Copyright © 2015年 FOOGRY. All rights reserved.
//

#import "ActionViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface ActionViewController ()

@property(strong,nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ActionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    


   
    for (NSExtensionItem *item in self.extensionContext.inputItems) {
        for (NSItemProvider *itemProvider in item.attachments) {
            NSString *identifier = (NSString *)kUTTypeURL;
            BOOL status = [itemProvider hasItemConformingToTypeIdentifier:identifier];
            if(status){
                [itemProvider loadItemForTypeIdentifier:identifier options:nil completionHandler:^(NSURL *item, NSError *error) {
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//                        abel.text = item.absoluteString;
                        UIWebView *webview = [[UIWebView alloc] init];
                        webview.frame = self.view.frame;
                        //                        [webview loadRequest:[NSURLRequest requestWithURL:item]];
                        [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.360.com"]]];
                        
                        [self.view addSubview:webview];
                    
                    }];
                }];
                break;
            }
        }
    }
    // Get the item[s] we're handling from the extension context.
    
    // For example, look for an image and place it into an image view.
    // Replace this with something appropriate for the type[s] your extension supports.
    BOOL imageFound = NO;
    for (NSExtensionItem *item in self.extensionContext.inputItems) {
        for (NSItemProvider *itemProvider in item.attachments) {
            if ([itemProvider hasItemConformingToTypeIdentifier:(NSString *)kUTTypeImage]) {
                // This is an image. We'll load it, then place it in our image view.
                __weak UIImageView *imageView = self.imageView;
                [itemProvider loadItemForTypeIdentifier:(NSString *)kUTTypeImage options:nil completionHandler:^(UIImage *image, NSError *error) {
                    if(image) {
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            [imageView setImage:image];
                        }];
                    }
                }];
                
                imageFound = YES;
                break;
            }
        }
        
        if (imageFound) {
            // We only handle one image, so stop looking for more.
            break;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)done {
    // Return any edited content to the host app.
    // This template doesn't do anything, so we just echo the passed in items.
    [self.extensionContext completeRequestReturningItems:self.extensionContext.inputItems completionHandler:nil];
}

@end
