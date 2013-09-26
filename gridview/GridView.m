//
//  GridView.m
//  album
//
//  Created by Isken Huang on 12/6/12.
//  Copyright (c) 2012 Isken Huang. All rights reserved.
//

#import "GridView.h"

@implementation GridView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.dataArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)reloadData{
    // reloads everything from scratch. redisplays visible rows. because we only keep info about visible rows, this is cheap. will adjust offset if table shrinks
}

// Info
- (GridViewCell *)cellForRowAtIndex:(NSUInteger *)index{
    // returns nil if cell is not visible or index path is out of range
    if (![self.dataArray objectAtIndex:(NSInteger)index]) {
        return nil;
    }
    
    return [self.dataArray objectAtIndex:(NSInteger)index];
}

- (void)scrollToRowAtIndex:(NSUInteger *)index atScrollPosition:(GridViewScrollPosition)scrollPosition animated:(BOOL)animated{

}

- (void)insertRowsAtIndexs:(NSArray *)indexs{

}

- (void)deleteRowsAtIndexs:(NSArray *)indexs{

}

- (void)reloadRowsAtIndexs:(NSArray *)indexs{

}

- (void)moveRowAtIndex:(NSUInteger *)index toIndex:(NSUInteger *)newIndex{

}

@end
