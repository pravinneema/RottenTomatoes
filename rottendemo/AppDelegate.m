//
//  AppDelegate.m
//  rottendemo
//
//  Created by Pravin Neema on 6/3/14.
//  Copyright (c) 2014 Pravin Neema. All rights reserved.
//

#import "AppDelegate.h"
#import "MovieViewViewController.h"
#import "TopDVDViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    MovieViewViewController *vc = [[MovieViewViewController alloc]init];
    UINavigationController *nvc = [[UINavigationController alloc]initWithRootViewController:vc];
    nvc.title = @"Box Office";
    nvc.tabBarItem.image = [UIImage imageNamed:@"BoxOffice"];
    nvc.navigationBar.barTintColor = [UIColor lightGrayColor];

    
    TopDVDViewController *vc2 = [[TopDVDViewController alloc]init];
    UINavigationController *nvc2 = [[UINavigationController alloc]initWithRootViewController:vc2];
    nvc2.title = @"Top Dvd";
    nvc2.tabBarItem.image = [UIImage imageNamed:@"TopDvd"];
    nvc2.navigationBar.barTintColor = [UIColor lightGrayColor];
    
    // Create the tab bar controller
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    tabBarController.viewControllers=@[nvc, nvc2];

    tabBarController.tabBar.tintColor = [UIColor blackColor];
    tabBarController.tabBar.translucent = false;
    tabBarController.tabBar.barTintColor = [UIColor lightGrayColor];
    
    self.window.rootViewController = tabBarController;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
@end
