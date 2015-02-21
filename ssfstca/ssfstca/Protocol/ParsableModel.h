//
//  ParsableModel.h
//  ssfstca
//  Copyright (c) 2015 madeByRoots. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ParsableModel <NSObject>
- (void)updateFromDictionary:(NSDictionary *)dictionary;
@end
