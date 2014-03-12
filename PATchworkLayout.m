//
//  PATchworkLayout.m
//  PhotoFun
//
//  Created by Patrick DeSantis on 3/11/14.
//  Copyright (c) 2014 Patrick DeSantis. All rights reserved.
//

#import "PATchworkLayout.h"

@interface PATchworkLayout ()

// Cache of UICollectionViewLayoutAttributes objects keyed by indexPath
@property (strong, nonatomic) NSDictionary *layoutAttributes;

// Cache of the total width & height of our content
@property (assign, nonatomic) CGFloat contentWidth;
@property (assign, nonatomic) CGFloat contentHeight;
@end

@implementation PATchworkLayout

- (instancetype)init
{
    self = [super init];
    if (self) {
        _numberOfColumns = 1;
        _maxSpan = 1;
        _baseItemSize = CGSizeMake(50.0f, 50.0f);
        _horizontalSpacing = 10.0f;
        _verticalSpacing = 10.0f;
    }
    return self;
}

- (void)prepareLayout
{
    UICollectionView *collectionView = self.collectionView;

    // A dictionary keeping track of which positions are filled.
    // Key = an NSNumber for the row
    // Value = an NSMutableIndexSet containing the column #s that are filled for that row
    // e.g. if row 0, columns 0 and 2-3 are filled, the dict looks like @{ 0 : (0, 2-3) }
    NSMutableDictionary *filledPositions = [NSMutableDictionary dictionary];

    NSMutableDictionary *layoutAttributes = [NSMutableDictionary dictionary];

    NSUInteger currentRow = 0;
    NSUInteger currentColumn = 0;

    NSInteger sections = 1;
    if ([collectionView.dataSource respondsToSelector:@selector(numberOfSectionsInCollectionView:)]) {
        sections = [collectionView.dataSource numberOfSectionsInCollectionView:collectionView];
    }

    // Layout each item
    for (int section = 0; section < sections; section++) {
        NSInteger items = [collectionView.dataSource collectionView:collectionView numberOfItemsInSection:section];
        for (int item = 0; item < items; item++) {

            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];

            // Find next available starting position
            NSIndexSet *filledColumns = filledPositions[@(currentRow)];
            while ([filledColumns containsIndex:currentColumn]) {
                currentColumn++;
                if (currentColumn == self.numberOfColumns) {
                    currentColumn = 0;
                    currentRow++;
                    filledColumns = filledPositions[@(currentRow)];
                }
            }


            // Randomize size of item
            NSUInteger spanWidth = arc4random_uniform((unsigned int)self.maxSpan) + 1;
            NSUInteger spanHeight = arc4random_uniform((unsigned int)self.maxSpan) + 1;

            // Shrink item to fit if necessary
            // If we extend past our bounds on the x-axis, shrink
            if (currentColumn + spanWidth >= self.numberOfColumns) {
                spanWidth = 1;
            }

            // If we intersect any other cells, shrink
            for (NSUInteger y = currentRow; y < currentRow + spanHeight; y++) {
                NSIndexSet *columns = filledPositions[@(y)];
                if ([columns intersectsIndexesInRange:NSMakeRange(currentColumn, spanWidth)]) {
                    spanWidth = 1;
                    spanHeight = 1;
                    break;
                }
            }

            // Cache layout attributes
            UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            CGRect frame = CGRectMake(currentColumn * (self.baseItemSize.width + self.horizontalSpacing),
                                      currentRow * (self.baseItemSize.height + self.verticalSpacing),
                                      spanWidth * self.baseItemSize.width + self.horizontalSpacing * (spanWidth - 1),
                                      spanHeight * self.baseItemSize.height + self.verticalSpacing * (spanHeight - 1));
            attributes.frame = frame;
            layoutAttributes[indexPath] = attributes;

            // If this item extends past our current max content width or height, update our cache
            CGFloat maxX = CGRectGetMaxX(frame);
            CGFloat maxY = CGRectGetMaxY(frame);
            if (maxX > self.contentWidth) {
                self.contentWidth = maxX;
            }
            if (maxY > self.contentHeight) {
                self.contentHeight = maxY;
            }

            // Remember each position that this item occupies
            for (NSUInteger y = currentRow; y < currentRow + spanHeight; y++) {
                NSMutableIndexSet *newPositions = [NSMutableIndexSet indexSetWithIndexesInRange:NSMakeRange(currentColumn, spanWidth)];
                NSMutableIndexSet *oldPositions = filledPositions[@(y)];
                if (oldPositions) {
                    [oldPositions addIndexes:newPositions];
                } else {
                    filledPositions[@(y)] = newPositions;
                }
            }
        }
    }

    self.layoutAttributes = layoutAttributes;
}

- (CGSize)collectionViewContentSize
{
    return CGSizeMake(self.contentWidth, self.contentHeight);
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *items = [NSMutableArray array];
    for (UICollectionViewLayoutAttributes *attributes in [self.layoutAttributes allValues]) {
        if (CGRectIntersectsRect(rect, attributes.frame)) {
            [items addObject:attributes];
        }
    }
    return items;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.layoutAttributes[indexPath];
}

@end
