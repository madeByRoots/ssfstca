//
//  AppDelegate.m
//  ssfstca
//  Copyright (c) 2015 madeByRoots. All rights reserved.
//

#import "AppDelegate.h"
#import "CoreDataController.h"
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[CoreDataController sharedInstance] setup];
    
    
    return YES;
}

@end
