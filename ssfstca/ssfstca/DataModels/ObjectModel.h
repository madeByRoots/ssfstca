//
//  ObjectModel.h
//  ssfstca
//  Copyright (c) 2015 madeByRoots. All rights reserved.
//

#import "ParsableModel.h"

@interface ObjectModel : NSObject <ParsableModel>

+ (NSArray *)createModelsFromPlistConfigurationAtPath:(NSString *)resourcePath;

+ (NSArray *)createModelsFromJsonFile:(NSString *)fileName;

+ (NSArray *)defaultSortDescriptors;

@end
