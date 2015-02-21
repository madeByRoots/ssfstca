//
//  CocktailObjectModel.m
//  ssfstca
//  Copyright (c) 2015 madeByRoots. All rights reserved.
//

#import "CocktailObject.h"
#import <KZPropertyMapper/KZPropertyMapper.h>


@interface CocktailObject(Private)
@property (nonatomic, assign, readwrite) NSNumber *identifier; //change to uint
@property (nonatomic, copy, readwrite) NSString *name;
@property (nonatomic, strong, readwrite) NSDate *creationDate;
@property (nonatomic, strong, readwrite) NSDate *updateDate;
@end

@implementation CocktailObject

#pragma mark - class methods

+ (NSArray *)createModelsFromJsonFile:(NSString *)fileName
{
    NSArray *result = [super createModelsFromJsonFile:fileName];
    
    NSMutableArray *models = [NSMutableArray array];
    for (id dataObject in result) {
        if (![dataObject isKindOfClass:NSDictionary.class]) {
            continue;
        }
        
        ObjectModel *model = [[self alloc] init];
        [model updateFromDictionary:dataObject];
            
        [models addObject:model];
    }
    
    return models;
}


+ (NSArray *)defaultSortDescriptors
{
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                        initWithKey: @"identifier" ascending: YES];
    
    return @[sortDescriptor];
}


#pragma mark - init

- (instancetype)initWithDictionary:(NSDictionary *)initData
{
    self = [super init];
    
    if (self) {
        
        if (!initData) {
            return nil;
        }
        
        [self updateFromDictionary:initData];
    }
    
    return self;
}


#pragma mark - protocols

- (void)updateFromDictionary:(NSDictionary *)dictionary
{
    //TODO:
    NSDictionary *cocktailsAttributes = [dictionary objectForKey:@"@attributes"];
    
    [KZPropertyMapper mapValuesFrom:cocktailsAttributes
                         toInstance:self usingMapping:@{@"id" :  KZBox(UIntFromString, identifier),
                                                        @"name" : KZProperty(name),
                                                        @"insertDate" :  KZBox(ModelObjectDate, creationDate),
                                                        @"updateDate" : KZBox(ModelObjectDate, creationDate)
                                                        }];
}


@end
