//
//  ManagedObjectModel.h
//  ssfstca
//  Copyright (c) 2015 madeByRoots. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface ManagedObjectModel : NSManagedObject

+ (NSString *)entityName;

+ (NSEntityDescription *)entityWithContext:(NSManagedObjectContext *)managedObjectContext;

+ (instancetype)insertNewObjectInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

+ (NSArray *)defaultSortDescriptors;

@end
