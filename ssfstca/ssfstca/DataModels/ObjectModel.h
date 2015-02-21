//
//  ObjectModel.h
//  ssfstca
//  Copyright (c) 2015 madeByRoots. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ObjectModel : NSObject

+ (NSArray *)createModelsFromConfigurationAtPath:(NSString *)resourcePath;

- (void)updateWithDictionary:(NSDictionary *)dictionary;

+ (NSArray *)defaultSortDescriptors;

@end
