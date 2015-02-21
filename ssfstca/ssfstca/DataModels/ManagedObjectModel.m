//
//  ManagedObjectModel.m
//  ssfstca
//  Copyright (c) 2015 madeByRoots. All rights reserved.
//

#import "ManagedObjectModel.h"

@implementation ManagedObjectModel

+ (NSString *)entityName
{
    return NSStringFromClass(self);
}


+ (NSEntityDescription *)entityWithContext:(NSManagedObjectContext *)managedObjectContext
{
    NSParameterAssert(managedObjectContext);
    return  [NSEntityDescription entityForName:self.entityName inManagedObjectContext:managedObjectContext];
}


+ (instancetype)insertNewObjectInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    NSParameterAssert(managedObjectContext);
    return [NSEntityDescription insertNewObjectForEntityForName:self.entityName inManagedObjectContext:managedObjectContext];
}

+ (NSArray *)defaultSortDescriptors
{
    return nil;
}

@end
