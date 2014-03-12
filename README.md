PATchworkLayout
===============

A patchwork style grid layout for UICollectionView. It lays out cells in patch sizes that are random multiples of the base patch size.

![Screenshot](https://raw.github.com/pdesantis/PATchworkLayout/master/screenshot.jpg)

Usage
-----
To use PATchworkLayout, first add AssetsLibrary to your Build Phases. Then simply set the collectionViewLayout property of your collection view to an instance of PATchworkLayout.

```objectivec
PATchworkLayout *layout = [PATchworkLayout alloc] init];
layout.maxSpan = 2;
layout.numberOfColumns = 4;
layout.baseItemSize = CGSizeMake(75.0f, 75.0f);
layout.horizontalSpacing = 4.0f;
layout.verticalSpacing = 4.0f;
collectionView.collectionViewLayout = layout;
```

Run the PhotoFun project in the examples folder to see a demo of PATchworkLayout.

Installation
-----
Manually add PATchworkLayout.m and .h files to your XCode project.

License
-----
PATchworkLayout is MIT Licensed.