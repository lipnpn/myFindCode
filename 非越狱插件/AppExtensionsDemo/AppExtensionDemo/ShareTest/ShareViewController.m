//
//  ShareViewController.m
//  ShareTest
//
//  Created by lipnpn on 15/11/12.
//  Copyright © 2015年 FOOGRY. All rights reserved.
//

#import "ShareViewController.h"
static NSInteger const maxCharactersAllowed =  140;//手动设置字符数上限

@interface ShareViewController ()

@end

@implementation ShareViewController

- (BOOL)isContentValid {
    // Do validation of contentText and/or NSExtensionContext attachments here
    NSInteger length = self.contentText.length;
    self.charactersRemaining = @(maxCharactersAllowed - length);
    if (self.charactersRemaining.intValue < 0) {
        return NO;
    }
    return YES;
}
- (void)didSelectPost {
    // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
    
    // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
    [self.extensionContext completeRequestReturningItems:@[] completionHandler:nil];
}



- (NSArray *)configurationItems {
    // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
    return @[];
}

@end
