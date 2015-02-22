//
//  TableManagedDataSource.h
//  ssfstca
//  Copyright (c) 2015 madeByRoots. All rights reserved.
//

@import CoreData;
typedef void (^TableViewCellConfigureBlock)(id cell, id item);
@interface ManagedTableDataSource : NSObject <UITableViewDataSource, NSFetchedResultsControllerDelegate>

- (instancetype)initWithTableView:(UITableView *)tableView
                   cellIdentifier:(NSString *)cellIdentifier
               configureCellBlock:(void (^)(id, id))configureCellBlock;

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, assign, getter=isPaused) BOOL paused;


#pragma mark - public methods

- (void)loadContent;

@end
