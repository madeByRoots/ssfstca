//
//  CocktailDataSource.h
//  ssfstca
//  Copyright (c) 2015 madeByRoots. All rights reserved.
//

#import "TableDataSource.h"

@interface CocktailDataSource : TableDataSource
@property (nonatomic, strong, readonly) NSArray *objects;

- (void)sortByNameAscending:(BOOL)yesOrNo;

@end
