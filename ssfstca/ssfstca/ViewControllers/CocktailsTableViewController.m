//
//  CocktailsTableViewController.m
//  ssfstca
//  Copyright (c) 2015 madeByRoots. All rights reserved.
//

#import "CocktailsTableViewController.h"
#import "CocktailDataSource.h"
#import "CocktailCell.h"

#import "ManagedCocktailDataSource.h"
#import "CocktailManagedObject.h"

@class CocktailObject;

@interface CocktailsTableViewController()
@property (nonatomic, strong) TableDataSource *dataSource;
@property (nonatomic, strong) ManagedCocktailDataSource *managedDataSource;

@property (nonatomic, assign) BOOL toggleFlag;
@end


@implementation CocktailsTableViewController

#pragma mark - init

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //self.dataSource = [self configureDataSource];
    
    self.managedDataSource = [self configureManagedDataSource];
}


#pragma mark  - configuration

- (TableDataSource *)configureDataSource
{
    TableDataSource *dataSource = [[CocktailDataSource alloc] initWithTableView:self.tableView
                                                                 cellIdentifier:[CocktailCell reuseIdentifier]
                                                             configureCellBlock:^(id cell, id item) {
                                                                 
                                                                 CocktailCell *cocktailCell = (CocktailCell *)cell;
                                                                 CocktailObject *cocktailObj = (CocktailObject *)item;
                                                                 
                                                                 [cocktailCell configureWithDataObject:cocktailObj];
                                                             }];
    return dataSource;
}


- (ManagedCocktailDataSource *)configureManagedDataSource
{
    ManagedCocktailDataSource *dataSource = [[ManagedCocktailDataSource alloc] initWithTableView:self.tableView
                                                                            cellIdentifier:[CocktailCell reuseIdentifier]
                                                                        configureCellBlock:^(id cell, id item) {
                                                                            
                                                                                CocktailCell *cocktailCell = (CocktailCell *)cell;
                                                                                CocktailObject *cocktailObj = (CocktailObject *)item;
                                                                            
                                                                                [cocktailCell configureWithDataObject:cocktailObj];
                                                                            }];
    
    dataSource.fetchRequest = [CocktailManagedObject defaultFetchRequest];

    return dataSource;
}


#pragma mark - ibactions

- (IBAction)loadCocktails:(id)sender
{
    [self.managedDataSource loadContent];
}


- (IBAction)toggleFilter:(id)sender
{
    self.toggleFlag = !self.toggleFlag;

//    CocktailDataSource *cocktailSource;
//    if ([self.dataSource isKindOfClass:[CocktailDataSource class]]) {
//        cocktailSource = (CocktailDataSource *)self.dataSource;
//    }
//    
//    [cocktailSource sortByNameAscending:self.toggleFlag];
    
    [self.managedDataSource sortByNameAscending:self.toggleFlag];
}

@end
