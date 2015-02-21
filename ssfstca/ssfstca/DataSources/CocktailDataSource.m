//
//  CocktailDataSource.m
//  ssfstca
//  Copyright (c) 2015 madeByRoots. All rights reserved.
//

#import "CocktailDataSource.h"
#import "CocktailObject.h"

@interface CocktailDataSource()
@property(nonatomic, strong, readwrite) NSArray *objects;
@end

@implementation CocktailDataSource

#pragma mark -

- (id)itemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    
    if (!(row >= 0 && row < (NSInteger)self.objects.count)) {
        return nil;
    }
    
    return self.objects[(NSUInteger)[indexPath row]];
}


#pragma mark - public methods

- (void)loadContent
{
    if (!self.objects) {
        self.objects = [CocktailObject createModelsFromJsonFile:@"fullcocktail"];
        self.objects = [self.objects sortedArrayUsingDescriptors:[CocktailObject defaultSortDescriptors]];
        [self.tableView reloadData];
    }
}


- (void)sortByNameAscending:(BOOL)yesOrNo;
{
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                        initWithKey: @"name" ascending:yesOrNo];

    self.objects = [self.objects sortedArrayUsingDescriptors:@[sortDescriptor]];

    [self.tableView reloadData];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (NSInteger)self.objects.count;
}

@end
