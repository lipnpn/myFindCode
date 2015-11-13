//
//  UICollectionView+ScreenShot.h
//  TableViewScreenshots
//
//  Created by lipnpn on 15/11/13.
//  Copyright © 2015年 David Hernandez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UICollectionView (DHSmartScreenshot)

- (UIImage *)screenshot;

- (UIImage *)screenshotOfCellAtIndexPath:(NSIndexPath *)indexPath;

- (UIImage *)screenshotOfHeaderViewAtSection:(NSUInteger)section;

- (UIImage *)screenshotOfFooterViewAtSection:(NSUInteger)section;

- (UIImage *)screenshotExcludingAllHeaders:(BOOL)withoutHeaders
                       excludingAllFooters:(BOOL)withoutFooters
                          excludingAllRows:(BOOL)withoutRows;

- (UIImage *)screenshotExcludingHeadersAtSections:(NSSet *)headerSections
                       excludingFootersAtSections:(NSSet *)footerSections
                        excludingRowsAtIndexPaths:(NSSet *)indexPaths;

- (UIImage *)screenshotOfHeadersAtSections:(NSSet *)headerSections
                         footersAtSections:(NSSet *)footerSections
                          rowsAtIndexPaths:(NSSet *)indexPaths;
@end
