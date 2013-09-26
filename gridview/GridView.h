//
//  GridView.h
//  album
//
//  Created by Isken Huang on 12/6/12.
//  Copyright (c) 2012 Isken Huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GridViewCell.h"

typedef enum{
    GridViewScrollPositionBottom,
    GridViewScrollPositionMeddle,
    GridViewScrollPositionTop
} GridViewScrollPosition;


@protocol GridViewDelegate;
@protocol GridViewDataSource;

@interface GridView : UIScrollView<UIScrollViewDelegate, UIGestureRecognizerDelegate>

@property (strong, nonatomic) NSMutableArray *dataArray;
@property (assign) id<GridViewDelegate> delegate;
@property (assign) id<GridViewDataSource> dataSource;

// Data

- (void)reloadData;                 // reloads everything from scratch. redisplays visible rows. because we only keep info about visible rows, this is cheap. will adjust offset if table shrinks

// Info
- (GridViewCell *)cellForRowAtIndex:(NSUInteger *)index;            // returns nil if cell is not visible or index path is out of range

- (void)scrollToRowAtIndex:(NSUInteger *)index atScrollPosition:(GridViewScrollPosition)scrollPosition animated:(BOOL)animated;
- (void)insertRowsAtIndexs:(NSArray *)indexs;
- (void)deleteRowsAtIndexs:(NSArray *)indexs;
- (void)reloadRowsAtIndexs:(NSArray *)indexs;
- (void)moveRowAtIndex:(NSUInteger *)index toIndex:(NSUInteger *)newIndex;

@end

//_______________________________________________________________________________________________________________
// this represents the display and behaviour of the cells.
@protocol GridViewDelegate<NSObject, UIScrollViewDelegate>

@optional

// Display customization
- (void)gridView:(GridView *)gridView willDisplayCell:(GridViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;

// Variable height support
- (CGFloat)gridView:(GridView *)gridView heightForRowAtIndexPath:(NSUInteger *)index;
- (CGFloat)gridView:(GridView *)gridView heightForHeaderInSection:(NSInteger)section;
- (CGFloat)gridView:(GridView *)gridView heightForFooterInSection:(NSInteger)section;

// Section header & footer information. Views are preferred over title should you decide to provide both
- (UIView *)gridView:(GridView *)gridView viewForHeaderInSection:(NSUInteger)section;   // custom view for header. will be adjusted to default or specified header height
- (UIView *)gridView:(GridView *)gridView viewForFooterInSection:(NSUInteger)section;   // custom view for footer. will be adjusted to default or specified footer height

// Accessories (disclosures).
- (void)gridView:(GridView *)gridView accessoryButtonTappedForRowWithIndex:(NSUInteger *)index;

// Selection

// Called before the user changes the selection. Return a new indexPath, or nil, to change the proposed selection.
- (NSUInteger *)gridView:(GridView *)gridView willSelectRowAtIndex:(NSUInteger *)index;
// Called after the user changes the selection.
- (void)gridView:(GridView *)gridView didSelectRowAtIndex:(NSUInteger *)index;
- (void)gridView:(GridView *)gridView didDeselectRowAtIndex:(NSUInteger *)index;

// Editing

// Controls whether the background is indented while editing.  If not implemented, the default is YES.  This is unrelated to the indentation level below.  This method only applies to grouped style table views.
- (BOOL)gridView:(GridView *)gridView shouldIndentWhileEditingRowAtIndex:(NSUInteger *)index;

// The willBegin/didEnd methods are called whenever the 'editing' property is automatically changed by the table (allowing insert/delete/move). This is done by a swipe activating a single row
- (void)gridView:(GridView*)gridView willBeginEditingRowAtIndex:(NSUInteger *)index;
- (void)gridView:(GridView*)gridView didEndEditingRowAtIndex:(NSUInteger *)index;

// Moving/reordering

// Allows customization of the target row for a particular row as it is being moved/reordered
- (NSUInteger *)gridView:(GridView *)gridView targetIndexForMoveFromRowAtIndex:(NSUInteger *)sourceIndex toProposedIndex:(NSUInteger *)proposedDestinationIndex;

//_______________________________________________________________________________________________________________
// this protocol represents the data model object. as such, it supplies no information about appearance (including the cells)

@end



@protocol GridViewDataSource<NSObject>

@required

//- (NSUInteger)gridView:(GridView *)gridView numberOfRowsInSection:(NSInteger)section;

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (GridViewCell *)gridView:(GridView *)gridView cellForRowAtIndex:(NSUInteger *)index;

@optional

- (NSInteger)numberOfSectionsInTableView:(GridView *)tableView;              // Default is 1 if not implemented

- (NSString *)gridView:(GridView *)gridView titleForHeaderInSection:(NSUInteger)section;    // fixed font style. use custom view (UILabel) if you want something different
- (NSString *)gridView:(GridView *)gridView titleForFooterInSection:(NSUInteger)section;

// Editing

// Individual rows can opt out of having the -editing property set for them. If not implemented, all rows are assumed to be editable.
- (BOOL)gridView:(GridView *)gridView canEditRowAtIndex:(NSUInteger *)index;

// Moving/reordering

// Allows the reorder accessory view to optionally be shown for a particular row. By default, the reorder control will be shown only if the datasource implements -tableView:moveRowAtIndexPath:toIndexPath:
- (BOOL)gridView:(GridView *)gridView canMoveRowAtIndex:(NSUInteger *)index;

// Index

- (NSArray *)sectionIndexTitlesForGridView:(GridView *)gridView;                                                    // return list of section titles to display in section index view (e.g. "ABCD...Z#")
- (NSInteger)gridView:(GridView *)gridView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSUInteger)index;  // tell table which section corresponds to section title/index (e.g. "B",1))

// Data manipulation - insert and delete support

// After a row has the minus or plus button invoked (based on the UITableViewCellEditingStyle for the cell), the dataSource must commit the change
//- (void)gridView:(GridView *)gridView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndex:(NSUInteger *)index;

// Data manipulation - reorder / moving support

- (void)gridView:(GridView *)gridView moveRowAtIndex:(NSUInteger *)sourceIndex toIndex:(NSUInteger *)destinationIndex;

@end

//_______________________________________________________________________________________________________________