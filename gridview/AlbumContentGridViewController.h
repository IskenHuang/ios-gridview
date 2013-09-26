//
//  AlbumContentGridViewController.h
//  album
//
//  Created by Isken Huang on 12/6/12.
//  Copyright (c) 2012 Isken Huang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlbumContentGridViewController : UIViewController

//
- (void)AlbumContentGridViewController:(AlbumContentGridViewController *)AlbumContentGridViewController willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;

@end
