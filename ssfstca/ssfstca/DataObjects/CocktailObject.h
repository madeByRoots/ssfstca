//
//  CocktailObjectModel.h
//  ssfstca
//  Copyright (c) 2015 madeByRoots. All rights reserved.
//

#import "ObjectModel.h"


@interface CocktailObject : ObjectModel

@property (nonatomic, assign, readonly) NSNumber *identifier;
@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, strong, readonly) NSDate *creationDate;
@property (nonatomic, strong, readonly) NSDate *updateDate;

@end
