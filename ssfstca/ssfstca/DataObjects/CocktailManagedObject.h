//
//  CocktailManagedObjectModel.h
//  ssfstca
//  Copyright (c) 2015 madeByRoots. All rights reserved.
//

#import "ManagedObjectModel.h"
#import "ParsableModel.h"

@interface CocktailManagedObject : ManagedObjectModel <ParsableModel>
@property (copy, nonatomic) NSString *name;
@property (assign, nonatomic) NSUInteger identifier;
@property (copy, nonatomic) NSDate *creationDate;
@property (copy, nonatomic) NSDate *updateDate;

+ (NSFetchRequest *)defaultFetchRequest;
@end
