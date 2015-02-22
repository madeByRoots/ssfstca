//
//  CocktailManagedObjectModel.m
//  ssfstca
//  Copyright (c) 2015 madeByRoots. All rights reserved.
//

#import "CocktailManagedObject.h"
#import <KZPropertyMapper/KZPropertyMapper.h>

@implementation CocktailManagedObject
@dynamic name;
@dynamic identifier;
@dynamic creationDate;
@dynamic updateDate;

#pragma mark - RSMManagedObject


+ (NSString *)entityName
{
    return @"Cocktail";
}


- (void)updateFromDictionary:(NSDictionary *)dictionary
{
    NSDictionary *cocktailsAttributes = [dictionary objectForKey:@"@attributes"];
    
    [KZPropertyMapper mapValuesFrom:cocktailsAttributes
                         toInstance:self usingMapping:@{@"id" :   KZBox(UIntFromString, identifier),
                                                        @"name" : KZProperty(name),
                                                        @"insertDate" :  KZBox(ModelObjectDate, creationDate),
                                                        @"updateDate" : KZBox(ModelObjectDate, creationDate)
                                                        }];

}


+ (NSFetchRequest *)defaultFetchRequest
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[self entityName]];
    
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"identifier" ascending:YES]];
    fetchRequest.fetchBatchSize = 20;
    return fetchRequest;
}

@end
