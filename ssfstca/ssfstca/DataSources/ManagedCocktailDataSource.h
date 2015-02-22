//
//  ManagedCocktailDataSource.h
//  ssfstca
//  Copyright (c) 2015 madeByRoots. All rights reserved.
//

#import "ManagedTableDataSource.h"

@interface ManagedCocktailDataSource : ManagedTableDataSource
@property (nonatomic, strong) NSFetchRequest *fetchRequest;

- (void)sortByNameAscending:(BOOL)yesOrNo;
@end
