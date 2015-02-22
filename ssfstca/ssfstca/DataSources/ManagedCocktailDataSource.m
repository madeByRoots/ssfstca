//
//  ManagedCocktailDataSource.m
//  ssfstca
//  Copyright (c) 2015 madeByRoots. All rights reserved.
//

#import "ManagedCocktailDataSource.h"
#import "CoreDataController.h"

#import "CocktailManagedObject.h"

#import "CocktailObject.h"

@interface ManagedCocktailDataSource()
@property (strong, nonatomic) NSManagedObjectContext *privateContext;
@end

@implementation ManagedCocktailDataSource


#pragma mark - public methods

- (void)setFetchRequest:(NSFetchRequest *)fetchRequest
{
    _fetchRequest = fetchRequest;
    
    NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                                               managedObjectContext:[CoreDataController sharedInstance].mainContext
                                                                                                 sectionNameKeyPath:nil
                                                                                                          cacheName:nil];
    self.fetchedResultsController = fetchedResultsController;
}


//Discuss: Is this really a good place to import data to coredata?
- (void)loadContent
{
    if (!_privateContext) {
        _privateContext = [[CoreDataController sharedInstance] newPrivateContext];
        
        [self.privateContext performBlockAndWait:^{
            [self importData];
        }];
    }
}


- (void)importData
{
    //Loading data localy until nentwork fetching is implemented
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *resourcePath = [bundle pathForResource:@"fullcocktail" ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:resourcePath];
    NSError *error;
    
    NSMutableArray *dataObjects = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    
    if (error) {
        NSLog(@"JSONObjectWithData error: %@", error);
    }
    
    CocktailManagedObject *cocktailManagedObject;
    
    for(id object in dataObjects){
        
        if (![object isKindOfClass:NSDictionary.class]) {
            continue;
        }
        
        cocktailManagedObject = [CocktailManagedObject insertNewObjectInManagedObjectContext:self.privateContext];
        [cocktailManagedObject updateFromDictionary:object];
    }
    
    NSError *saveError = nil;
    if (![self.privateContext save:&saveError]) {
        NSLog(@"Failed to save managed object context: %@", [saveError localizedDescription]);
        NSAssert(NO, @"Managed object context save failed.");
    }
}


- (void)sortByNameAscending:(BOOL)yesOrNo;
{
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                        initWithKey: @"name" ascending:yesOrNo];
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[CocktailManagedObject entityName]];
    
    fetchRequest.sortDescriptors = @[sortDescriptor];
    fetchRequest.fetchBatchSize = 20;
    self.fetchRequest = fetchRequest;
}

@end
