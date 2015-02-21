//
//  CoreDataController.m
//  ssfstca
//
//  Copyright (c) 2015 Kupferwerk GmbH. All rights reserved.
//

#import "CoreDataController.h"


static NSString * const ManagedObjectModelResourceName = @"CoreDataRossmann";
static NSString * const ManagedObjectModelExtension = @"momd";
static NSString * const PersistenStorePath = @"rossmann.sqlite";


@interface CoreDataController()
@property (nonatomic, strong, readwrite) NSManagedObjectContext *mainContext;
@end


@implementation CoreDataController


#pragma mark - Initialization

+ (instancetype)sharedInstance
{
    static id sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}


#pragma mark - Public

- (void)setup
{
    NSManagedObjectModel *managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:
                                                [[NSBundle mainBundle] URLForResource:ManagedObjectModelResourceName
                                                                        withExtension:ManagedObjectModelExtension]];
    
    NSPersistentStoreCoordinator *persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel];
    NSURL *persistentStoreURL = [[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                                         inDomains:NSUserDomainMask]
                                  firstObject]
                                 URLByAppendingPathComponent:PersistenStorePath];
    
    [self addPersistentStoreAtURL:persistentStoreURL toCoordinator:persistentStoreCoordinator requiringCompatabilityWithModel:managedObjectModel];
    
    [self createMainContextWithPersistentStoreCoordinator:persistentStoreCoordinator];
}


- (NSManagedObjectContext *)newPrivateContext
{
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    context.undoManager = nil;
    context.persistentStoreCoordinator = self.mainContext.persistentStoreCoordinator;
    
    return context;
}


- (BOOL)resetPersistentStore:(NSError **)error
{
    [self.mainContext reset];

    NSError *localError = nil;
    NSPersistentStoreCoordinator *coordinator = self.mainContext.persistentStoreCoordinator;
    for (NSPersistentStore *persistentStore in coordinator.persistentStores) {
        NSURL *storeURL = [coordinator URLForPersistentStore:persistentStore];
        BOOL success = [coordinator removePersistentStore:persistentStore error:&localError];
        if (success) {
            if ([storeURL isFileURL]) {
                if (![[NSFileManager defaultManager] removeItemAtURL:storeURL error:&localError]) {
                    NSLog(@"Failed to remove persistent store at URL: %@", storeURL);
                    if (error) { *error = localError; }

                    return NO;
                }

                for (NSString *suffix in @[ @"-shm", @"-wal" ]) {
                    NSString *supportFileName = [[storeURL lastPathComponent] stringByAppendingString:suffix];
                    NSURL *supportFileURL = [NSURL URLWithString:supportFileName relativeToURL:[storeURL URLByDeletingLastPathComponent]];
                    if ([[NSFileManager defaultManager] fileExistsAtPath:[supportFileURL path]]) {
                        if (![[NSFileManager defaultManager] removeItemAtURL:supportFileURL error:&localError]) {
                            NSLog(@"Failed to remove support file at URL %@: %@", supportFileURL, localError);
                            if (error) { *error = localError; }

                            return NO;
                        }
                    }
                }
            }
            else {
                NSLog(@"Skipped removal of persistent store file: URL for persistent store is not a file URL. (%@)", storeURL);
            }

            NSPersistentStore *newStore = [coordinator addPersistentStoreWithType:persistentStore.type
                                                                    configuration:persistentStore.configurationName
                                                                              URL:persistentStore.URL
                                                                          options:persistentStore.options
                                                                            error:&localError];
            if (!newStore) {
                if (error) { *error = localError; }

                return NO;
            }
        }
        else {
            NSLog(@"Failed reset of persistent store %@: Failed to remove persistent store with error: %@", persistentStore, localError);
            if (error) { *error = localError; }

            return NO;
        }
    }
    
    [self recreateMainContextWithPersistentStoreCoordinator:coordinator];

    return YES;
}


#pragma mark - Notifications

- (void)didSaveManagedObjectContext:(NSNotification *)notification
{
    NSManagedObjectContext *context = self.mainContext;
    if (notification.object != context) {
        [context performBlock:^{
            [context mergeChangesFromContextDidSaveNotification:notification];
        }];
    }
}


#pragma mark - Private methods

- (NSPersistentStore *)addPersistentStoreAtURL:(NSURL *)persistentStoreURL
                                 toCoordinator:(NSPersistentStoreCoordinator *)coordinator
               requiringCompatabilityWithModel:(NSManagedObjectModel *)model {
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[persistentStoreURL path]]) {
        NSError *storeMetadataError = nil;
        NSDictionary *storeMetadata = [NSPersistentStoreCoordinator metadataForPersistentStoreOfType:NSSQLiteStoreType
                                                                                                 URL:persistentStoreURL
                                                                                               error:&storeMetadataError];
        
        // If store is incompatible with the managed object model, remove the store file
        if (storeMetadataError || ![model isConfiguration:nil compatibleWithStoreMetadata:storeMetadata]) {
            
            NSError *removeStoreError = nil;
            
            if (![[NSFileManager defaultManager] removeItemAtURL:persistentStoreURL error:&removeStoreError]) {
                NSLog(@"Error removing store file at URL '%@': %@, %@", persistentStoreURL, removeStoreError, [removeStoreError userInfo]);
            }
        }
    }
    
    NSError *addStoreError = nil;
    NSPersistentStore *store = [coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:persistentStoreURL
                                                               options:nil error:&addStoreError];
    
    if (!store) {
        NSLog(@"Unable to add store: %@, %@", addStoreError, [addStoreError userInfo]);
    }
    
    return store;
}


- (void)createMainContextWithPersistentStoreCoordinator:(NSPersistentStoreCoordinator *)coordinator
{
    self.mainContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    self.mainContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy;
    self.mainContext.persistentStoreCoordinator = coordinator;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didSaveManagedObjectContext:)
                                                 name:NSManagedObjectContextDidSaveNotification
                                               object:nil];
}

- (void)recreateMainContextWithPersistentStoreCoordinator:(NSPersistentStoreCoordinator *)coordinator
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSManagedObjectContextDidSaveNotification object:nil];
    self.mainContext = nil;
    
    [self createMainContextWithPersistentStoreCoordinator:coordinator];
}

@end
