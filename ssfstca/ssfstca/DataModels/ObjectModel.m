//
//  ObjectModel.m
//  ssfstca
//  Copyright (c) 2015 madeByRoots. All rights reserved.
//

#import "ObjectModel.h"


@implementation ObjectModel

#pragma mark - Class Methods

+ (NSArray *)createModelsFromPlistConfigurationAtPath:(NSString *)resourcePath
{
    NSParameterAssert(resourcePath);
    
    NSData *plistData = [NSData dataWithContentsOfFile:resourcePath];
    NSError *error = nil;
    id object = [NSPropertyListSerialization propertyListWithData:plistData options:NSPropertyListImmutable format:nil error:&error];
    if (!object) {
        NSLog(@"Failed to read configuration plist at path %@\n%@", resourcePath, error);
        return nil;
    }
    
    if (![object isKindOfClass:NSArray.class]) {
        NSLog(@"Root level element %@ in plist is not of kind NSArray.", NSStringFromClass([object class]));
        return nil;
    }
    
    NSMutableArray *models = [NSMutableArray array];
    for (id configuration in object) {
        if (![configuration isKindOfClass:NSDictionary.class]) {
            continue;
        }
        
        ObjectModel *model = [[self alloc] init];
        [model updateFromDictionary:configuration];
        
        [models addObject:model];
    }
    
    return models;
}


+ (NSArray *)createModelsFromJsonFile:(NSString *)fileName
{
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *resourcePath = [bundle pathForResource:fileName ofType:@"json"];
    
    NSData *jsonData = [NSData dataWithContentsOfFile:resourcePath];
    
    NSError *error;
    
    NSMutableArray *array = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    if (error)
        NSLog(@"JSONObjectWithData error: %@", error);
    
    return [array copy];
}


+ (NSArray *)defaultSortDescriptors
{
    return nil;
}


#pragma mark - protocols

- (void)updateFromDictionary:(NSDictionary *)dictionary
{
    assert(@"override!");
}

@end
