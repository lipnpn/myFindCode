//
//  UICollectionView+ScreenShot.m
//  TableViewScreenshots
//
//  Created by lipnpn on 15/11/13.
//  Copyright © 2015年 David Hernandez. All rights reserved.
//

#import "UICollectionView+ScreenShot.h"
#import "UIView+DHSmartScreenshot.h"
#import "UIImage+DHImageAdditions.h"
@implementation UICollectionView(DHSmartScreenshot)

- (UIImage *)screenshot
{
    return [self screenshotExcludingHeadersAtSections:nil
                           excludingFootersAtSections:nil
                            excludingRowsAtIndexPaths:nil];
}

- (UIImage *)screenshotOfCellAtIndexPath:(NSIndexPath *)indexPath
{
    UIImage *cellScreenshot = nil;
    
    // Current tableview offset
    CGPoint currTableViewOffset = self.contentOffset;
    
    // First, scroll the tableview so the cell would be rendered on the view and able to screenshot'it

    [self scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
    // Take the screenshot
    cellScreenshot = [[self cellForItemAtIndexPath:indexPath] screenshot];
    
    // scroll back to the original offset
    [self setContentOffset:currTableViewOffset animated:NO];
    
    return cellScreenshot;
}




- (UIImage *)screenshotExcludingAllHeaders:(BOOL)withoutHeaders
                       excludingAllFooters:(BOOL)withoutFooters
                          excludingAllRows:(BOOL)withoutRows
{
    NSArray *excludedHeadersOrFootersSections = nil;
    if (withoutHeaders || withoutFooters) excludedHeadersOrFootersSections = [self allSectionsIndexes];
    
    NSArray *excludedRows = nil;
    if (withoutRows) excludedRows = [self allRowsIndexPaths];
    
    return [self screenshotExcludingHeadersAtSections:(withoutHeaders)?[NSSet setWithArray:excludedHeadersOrFootersSections]:nil
                           excludingFootersAtSections:(withoutFooters)?[NSSet setWithArray:excludedHeadersOrFootersSections]:nil
                            excludingRowsAtIndexPaths:(withoutRows)?[NSSet setWithArray:excludedRows]:nil];
}

- (UIImage *)screenshotExcludingHeadersAtSections:(NSSet *)excludedHeaderSections
                       excludingFootersAtSections:(NSSet *)excludedFooterSections
                        excludingRowsAtIndexPaths:(NSSet *)excludedIndexPaths
{
    NSMutableArray *screenshots = [NSMutableArray array];
    for (int section=0; section<self.numberOfSections; section++) {
        
        // Screenshot of every cell of this section
        for (int row=0; row<[self numberOfItemsInSection:section]; row++) {
            NSIndexPath *cellIndexPath = [NSIndexPath indexPathForRow:row inSection:section];
            UIImage *cellScreenshot = [self screenshotOfCellAtIndexPath:cellIndexPath excludedIndexPaths:excludedIndexPaths];
            if (cellScreenshot) [screenshots addObject:cellScreenshot];
        }
 
    }
    return [UIImage verticalImageFromArray:screenshots];
}

- (UIImage *)screenshotOfHeadersAtSections:(NSSet *)includedHeaderSections
                         footersAtSections:(NSSet *)includedFooterSections
                          rowsAtIndexPaths:(NSSet *)includedIndexPaths
{
    NSMutableArray *screenshots = [NSMutableArray array];
    
    for (int section=0; section<self.numberOfSections; section++) {
        // Header Screenshot
        UIImage *headerScreenshot = [self screenshotOfHeaderViewAtSection:section includedHeaderSections:includedHeaderSections];
        if (headerScreenshot) [screenshots addObject:headerScreenshot];
        
        // Screenshot of every cell of the current section
        for (int row=0; row<[self numberOfItemsInSection:section]; row++) {
            NSIndexPath *cellIndexPath = [NSIndexPath indexPathForRow:row inSection:section];
            UIImage *cellScreenshot = [self screenshotOfCellAtIndexPath:cellIndexPath includedIndexPaths:includedIndexPaths];
            if (cellScreenshot) [screenshots addObject:cellScreenshot];
        }
        
        // Footer Screenshot
        UIImage *footerScreenshot = [self screenshotOfFooterViewAtSection:section includedFooterSections:includedFooterSections];
        if (footerScreenshot) [screenshots addObject:footerScreenshot];
    }
    return [UIImage verticalImageFromArray:screenshots];
}

#pragma mark - Hard Working for Screenshots

- (UIImage *)screenshotOfCellAtIndexPath:(NSIndexPath *)indexPath excludedIndexPaths:(NSSet *)excludedIndexPaths
{
    if ([excludedIndexPaths containsObject:indexPath]) return nil;
    return [self screenshotOfCellAtIndexPath:indexPath];
}




- (UIImage *)screenshotOfCellAtIndexPath:(NSIndexPath *)indexPath includedIndexPaths:(NSSet *)includedIndexPaths
{
    if (![includedIndexPaths containsObject:indexPath]) return nil;
    return [self screenshotOfCellAtIndexPath:indexPath];
}

- (UIImage *)screenshotOfHeaderViewAtSection:(NSUInteger)section includedHeaderSections:(NSSet *)includedHeaderSections
{
    if (![includedHeaderSections containsObject:@(section)]) return nil;
    
    UIImage *sectionScreenshot = nil;
    sectionScreenshot = [self screenshotOfHeaderViewAtSection:section];
 
    return sectionScreenshot;
}

- (UIImage *)screenshotOfFooterViewAtSection:(NSUInteger)section includedFooterSections:(NSSet *)includedFooterSections
{
    if (![includedFooterSections containsObject:@(section)]) return nil;
    
    UIImage *sectionScreenshot = nil;
    sectionScreenshot = [self screenshotOfFooterViewAtSection:section];
 
    return sectionScreenshot;
}



#pragma mark - All Headers / Footers sections

- (NSArray *)allSectionsIndexes
{
    long numOfSections = [self numberOfSections];
    NSMutableArray *allSectionsIndexes = [NSMutableArray array];
    for (int section=0; section < numOfSections; section++) {
        [allSectionsIndexes addObject:@(section)];
    }
    return allSectionsIndexes;
}

#pragma mark - All Rows Index Paths

- (NSArray *)allRowsIndexPaths
{
    NSMutableArray *allRowsIndexPaths = [NSMutableArray array];
    for (NSNumber *sectionIdx in [self allSectionsIndexes]) {
        for (int rowNum=0; rowNum<[self numberOfItemsInSection:[sectionIdx unsignedIntegerValue]]; rowNum++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:rowNum inSection:[sectionIdx unsignedIntegerValue]];
            [allRowsIndexPaths addObject:indexPath];
        }
    }
    return allRowsIndexPaths;
}

@end
