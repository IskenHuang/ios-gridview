//
//  AlbumTableViewViewController.m
//  album
//
//  Created by Isken Huang on 12/6/12.
//  Copyright (c) 2012 Isken Huang. All rights reserved.
//

#import "AlbumTableViewViewController.h"

@interface AlbumTableViewViewController ()

@property (nonatomic, strong) ALAssetsLibrary *library;
@property (nonatomic, strong) NSMutableArray *assetGroups;

@end

@implementation AlbumTableViewViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.assetGroups = [[NSMutableArray alloc] init];
    
    self.library = [[ALAssetsLibrary alloc] init];
    [self drawAlbum];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark data
-(void) drawAlbum {
    // Load Albums into assetGroups
    [self.assetGroups removeAllObjects];
    dispatch_async(dispatch_get_main_queue(), ^ {
        @autoreleasepool {
            // Group enumerator Block
            void (^assetGroupEnumerator)(ALAssetsGroup *, BOOL *) = ^(ALAssetsGroup *group, BOOL *stop){
                if (group == nil){
                    return;
                }
                //[self.assetGroups removeAllObjects];
                [self.assetGroups addObject:group];
                
                // Reload albums
                [self performSelectorOnMainThread:@selector(reloadTableViewData) withObject:nil waitUntilDone:YES];
            };
            
            // Group Enumerator Failure Block
            void (^assetGroupEnumberatorFailure)(NSError *) = ^(NSError *error) {
                
                /*
                 UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"Album Error: %@ - %@", [error localizedDescription], [error localizedRecoverySuggestion]] delegate:nil cancelButtonTitle:NSLocalizedString(@"ALERT_BUTTON_OK",nil) otherButtonTitles:nil];
                 */
                
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"ALERT_LOCATION_SERVICE_DISABLE_TITLE",nil) message:NSLocalizedString(@"ALERT_LOCATION_SERVICE_DISABLE_MSG",nil)  delegate:nil cancelButtonTitle:NSLocalizedString(@"ALERT_BUTTON_OK",nil) otherButtonTitles:nil];
                
                
                [alert show];
                //                [alert release];
                
                NSLog(@"A problem occured %@", [error description]);
            };
            
            // Enumerate Albums
            [self.library enumerateGroupsWithTypes:ALAssetsGroupAll
                                   usingBlock:assetGroupEnumerator
                                 failureBlock:assetGroupEnumberatorFailure];
        }
    });
}

-(void) reloadTableViewData {
	[self.tableView reloadData];
    [self.navigationItem setTitle:NSLocalizedString(@"PHOTOS_NAVIGATIONBAR_TITLE",nil)];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.assetGroups count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Get count
    ALAssetsGroup *g = (ALAssetsGroup*)[self.assetGroups objectAtIndex:indexPath.row];
    [g setAssetsFilter:[ALAssetsFilter allPhotos]];
    NSInteger gCount = [g numberOfAssets];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ (%d)",[g valueForProperty:ALAssetsGroupPropertyName], gCount];
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    [cell.imageView setImage:[UIImage imageWithCGImage:[(ALAssetsGroup*)[self.assetGroups objectAtIndex:indexPath.row] posterImage]]];
	[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
        NSString *const ALAssetsGroupPropertyName;
        NSString *const ALAssetsGroupPropertyType;
        NSString *const ALAssetsGroupPropertyPersistentID;
        NSString *const ALAssetsGroupPropertyURL;
     */
    
    ALAssetsGroup *group = [self.assetGroups objectAtIndex:indexPath.row];
    DLogv([group valueForProperty:ALAssetsGroupPropertyURL]);
}

@end
