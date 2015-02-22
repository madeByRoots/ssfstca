//
//  TableManagedDataSource.m
//  ssfstca
//  Copyright (c) 2015 madeByRoots. All rights reserved.
//

#import "ManagedTableDataSource.h"

@interface ManagedTableDataSource () 
@property (copy, nonatomic) NSString *cellIdentifier;
@property (copy, nonatomic) TableViewCellConfigureBlock configureCellBlock;
@property (weak, nonatomic) UITableView *tableView;
@end

@implementation ManagedTableDataSource

#pragma mark - Initialization

- (instancetype)initWithTableView:(UITableView *)tableView
                   cellIdentifier:(NSString *)cellIdentifier
               configureCellBlock:(void (^)(id, id))configureCellBlock
{
    self = [super init];
    
    if (!self) {
        return nil;
    }
    
    _cellIdentifier = [cellIdentifier copy];
    _configureCellBlock = [configureCellBlock copy];
    _tableView = tableView;
    _tableView.dataSource = self;
    
    return self;
}


#pragma mark - Properties

- (void)setFetchRequest:(NSFetchRequest *)fetchRequest
{
    NSAssert(YES, @"Override");
}


- (void)setPaused:(BOOL)paused
{
    if (_paused == paused) {
        return;
    }
    
    _paused = paused;
    
    if (paused) {
        self.fetchedResultsController.delegate = nil;
    }
    else {
        self.fetchedResultsController.delegate = self;
        [self.fetchedResultsController performFetch:nil];
        [self.tableView reloadData];
    }
}


- (void)setFetchedResultsController:(NSFetchedResultsController *)fetchedResultsController
{
    NSAssert(_fetchedResultsController == nil, @"This property can only assigned once.");
    
    _fetchedResultsController = fetchedResultsController;
    
    fetchedResultsController.delegate = self;
    [fetchedResultsController performFetch:nil];
}


#pragma mark - public methods
- (void)loadContent
{
    NSAssert(NO, @"Should be implemented by subclasses");
}


#pragma mark - DataSource

- (id)itemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.fetchedResultsController objectAtIndexPath:indexPath];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id<NSFetchedResultsSectionInfo> sectionInfo = self.fetchedResultsController.sections[(NSUInteger)section];
    
    NSInteger numberOfRows = (NSInteger)[sectionInfo numberOfObjects];
    
    return numberOfRows;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier
                                                            forIndexPath:indexPath];
    
    id item = [self itemAtIndexPath:indexPath];
    self.configureCellBlock(cell, item);
    
    return cell;
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController*)controller
{
    [self.tableView beginUpdates];
}


- (void)controllerDidChangeContent:(NSFetchedResultsController*)controller
{
    [self.tableView endUpdates];
}


- (void)controller:(NSFetchedResultsController*)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath*)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath*)newIndexPath
{
    if (type == NSFetchedResultsChangeInsert) {
        [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    else if (type == NSFetchedResultsChangeUpdate) {
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    else if (type == NSFetchedResultsChangeDelete) {
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    else if (type == NSFetchedResultsChangeMove) {
        [self.tableView moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
    }
    else {
        NSAssert(NO, @"Unsupported NSFetchedResultsChangeType.");
    }
}


@end
