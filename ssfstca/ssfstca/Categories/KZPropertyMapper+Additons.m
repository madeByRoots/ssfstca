//
//  KZPropertyMapper+Additons.m
//  ssfstca
//  Copyright (c) 2015 madeByRoots. All rights reserved.
//

#import "KZPropertyMapper+Additons.h"
#import <KZPropertyMapperCommon.h>

@implementation KZPropertyMapper (Additons)


+ (NSDateFormatter *)modelObjectDateFormatter
{
    static NSDateFormatter *df = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        df = [[NSDateFormatter alloc] init];
        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        [df setLocale:locale];
        [df setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    });
    return df;
}


+ (NSNumberFormatter *)numberFromStringFormatter
{
    static NSNumberFormatter *nf = nil;
    static dispatch_once_t onceTokenTwo;
    dispatch_once(&onceTokenTwo, ^{
        nf = [[NSNumberFormatter alloc] init];
        nf.numberStyle = NSNumberFormatterDecimalStyle;
    });
    
    return nf;
}


+ (NSDate *)boxValueAsModelObjectDate:(id)value __unused
{
    if (value == nil) {
        return nil;
    }
    AssertTrueOrReturnNil([value isKindOfClass:NSString.class]);
    
    return [[self modelObjectDateFormatter] dateFromString:value];
}


+ (NSNumber *)boxValueAsUIntFromString:(id)value __unused
{
    if (value == nil) {
        return nil;
    }

    AssertTrueOrReturnNil([value isKindOfClass:NSString.class]);

    NSNumber *myNumber = [[self numberFromStringFormatter] numberFromString:value];
    
    return myNumber;
}

@end
