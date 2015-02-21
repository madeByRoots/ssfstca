//
//  ManagedCocktailDataSource.h
//  ssfstca
//
//  Created by Andreas Bohatsch on 21.02.15.
//  Copyright (c) 2015 madeByRoots. All rights reserved.
//

#import "ManagedTableDataSource.h"

@interface ManagedCocktailDataSource : ManagedTableDataSource
@property (nonatomic, strong) NSFetchRequest *fetchRequest;
@end
