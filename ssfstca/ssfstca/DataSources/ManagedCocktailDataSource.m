//
//  ManagedCocktailDataSource.m
//  ssfstca
//
//  Created by Andreas Bohatsch on 21.02.15.
//  Copyright (c) 2015 madeByRoots. All rights reserved.
//

#import "ManagedCocktailDataSource.h"
#import "CoreDataController.h"

@implementation ManagedCocktailDataSource
- (void)setFetchRequest:(NSFetchRequest *)fetchRequest
{
    _fetchRequest = fetchRequest;
    
    NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                                               managedObjectContext:[CoreDataController sharedInstance].mainContext
                                                                                                 sectionNameKeyPath:nil
                                                                                                          cacheName:nil];
    self.fetchedResultsController = fetchedResultsController;
}
@end
