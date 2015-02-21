//
//  CoreDataController.h
//  ssfstca
//
//  Copyright (c) 2015 Kupferwerk GmbH. All rights reserved.
//

@import CoreData;


typedef void (^CoreDataControllerBlock)(NSManagedObjectContext *context);


@interface CoreDataController : NSObject


@property (nonatomic, strong, readonly) NSManagedObjectContext *mainContext;

+ (instancetype)sharedInstance;

- (void)setup;

- (NSManagedObjectContext *)newPrivateContext;

- (BOOL)resetPersistentStore:(NSError **)error;

@end
