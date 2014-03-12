//
//  PATchworkLayout.h
//  PhotoFun
//
//  Created by Patrick DeSantis on 3/11/14.
//  Copyright (c) 2014 Patrick DeSantis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PATchworkLayout : UICollectionViewLayout

/**
 The number of columns. Defaults to 1.
 */
@property (assign, nonatomic) NSUInteger numberOfColumns;

/**
 The maximum amount of rows or columns an item can span across. Defaults to 1.
 
 @note Must be less than or equal to numberOfColumns.
 */
@property (assign, nonatomic) NSUInteger maxSpan;

/**
 The size of a standard, "1x1 patch" item. Defaults to (50.0, 50.0).
 */
@property (assign, nonatomic) CGSize baseItemSize;

/**
 The spacing between columns. Only applied in between columns, not to the left or right. Defaults to 10.0.
 */
@property (assign, nonatomic) CGFloat horizontalSpacing;

/**
 The spacing between rows. Only applied in between rows, not above or below. Defaults to 10.0.
 */
@property (assign, nonatomic) CGFloat verticalSpacing;

@end
