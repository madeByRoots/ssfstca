//
//  ObjectModel.m
//  ssfstca
//  Copyright (c) 2015 madeByRoots. All rights reserved.
//

#import "ObjectModel.h"

@implementation ObjectModel

+ (NSArray *)createModelsFromConfigurationAtPath:(NSString *)resourcePath
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
        [model updateWithDictionary:configuration];
        
        [models addObject:model];
    }
    
    return models;
}


- (void)updateWithDictionary:(NSDictionary *)dictionary
{
    
}


+ (NSArray *)defaultSortDescriptors
{
    return nil;
}

@end
