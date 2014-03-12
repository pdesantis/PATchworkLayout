//
//  AlbumViewController.m
//  PhotoFun
//
//  Created by Patrick DeSantis on 3/12/14.
//  Copyright (c) 2014 Patrick DeSantis. All rights reserved.
//

#import "AlbumViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "PATchworkLayout.h"
#import "PhotoCell.h"

@interface AlbumViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (strong, nonatomic) ALAssetsLibrary *library;
@property (strong, nonatomic) NSArray *photoAssets;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@end

@implementation AlbumViewController

static NSString *const CellReuseIdentifier = @"PhotoCell";

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    PATchworkLayout *layout = [[PATchworkLayout alloc] init];
    layout.maxSpan = 2;
    layout.numberOfColumns = 4;
    layout.baseItemSize = CGSizeMake(75.0f, 75.0f);
    layout.horizontalSpacing = 4.0f;
    layout.verticalSpacing = 4.0f;
    self.collectionView.collectionViewLayout = layout;

    self.library = [[ALAssetsLibrary alloc] init];

    UINib *photoCell = [UINib nibWithNibName:CellReuseIdentifier bundle:nil];
    [self.collectionView registerNib:photoCell forCellWithReuseIdentifier:CellReuseIdentifier];
}

- (void)viewWillAppear:(BOOL)animated
{
    ALAssetsLibraryGroupsEnumerationResultsBlock groupBlock = ^(ALAssetsGroup *group, BOOL *stop) {
        [group setAssetsFilter:[ALAssetsFilter allPhotos]];
        if ([group numberOfAssets] > 0) {
            [self enumerateAssetsGroup:group];
            *stop = YES;
        }
    };

    [self.library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos
                                usingBlock:groupBlock
                              failureBlock:^(NSError *error) {
                                  NSLog(@"%@", error);
                              }];
}

#pragma mark - Private methods
- (void)enumerateAssetsGroup:(ALAssetsGroup *)group
{
    NSMutableArray *assets = [NSMutableArray arrayWithCapacity:[group numberOfAssets]];
    [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if (result) {
            [assets addObject:result];
        }
    }];
    self.photoAssets = [NSArray arrayWithArray:assets];
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.photoAssets count];
}

#pragma mark - UICollectionViewDelegate
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ALAsset *asset = self.photoAssets[indexPath.item];
    CGImageRef imageRef = [asset thumbnail];

    PhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellReuseIdentifier forIndexPath:indexPath];
    cell.imageView.image = [UIImage imageWithCGImage:imageRef];
    return cell;
}

@end
