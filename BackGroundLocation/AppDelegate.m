 //
//  AppDelegate.m
//  BackGroundLocation
//
//  Created by 徐银 on 2017/3/23.
//  Copyright © 2017年 徐银. All rights reserved.
//

#import "AppDelegate.h"
#import "LocationService.h"

@interface AppDelegate ()
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //百度地图初始化
//    _manager = [[BMKMapManager alloc] init];
//    _coreLocationManager = [[CLLocationManager alloc] init];
//    BOOL ret = [_manager start:@"A8HhADgMjQtFcRKlxYpEEV4sgwupfQ4N" generalDelegate:self];
//    if(!ret)
//    {
//        NSLog(@"init failure");
//    }
    //进程以定位更新状态被唤醒
    self.locationService = [LocationService getInstance];
    UIAlertView *alert;
    if ([[UIApplication sharedApplication] backgroundRefreshStatus] == UIBackgroundRefreshStatusDenied) {
        alert = [[UIAlertView alloc]initWithTitle:@""
                                          message:@"请打开后台刷新保证位置后台实时上传，打开方式为 设置->通用->后台刷新"
                                         delegate:nil
                                cancelButtonTitle:@"Ok"
                                otherButtonTitles:nil, nil];
        [alert show];
    } else if ([[UIApplication sharedApplication] backgroundRefreshStatus] == UIBackgroundRefreshStatusRestricted) {
        alert = [[UIAlertView alloc]initWithTitle:@""
                                          message:@"后台刷新被禁止"
                                         delegate:nil
                                cancelButtonTitle:@"Ok"
                                otherButtonTitles:nil, nil];
        [alert show];
    } else {
        
        if(launchOptions[UIApplicationLaunchOptionsLocationKey]) {
            //被killed情况下后台唤醒
            [self.locationService startMonitoringLocation];
            self.locationService.state = UIApplicationStateInactive;
        }
    }
    [self.window makeKeyAndVisible];
    return YES;
}

//- (void)onGetNetworkState:(int)iError {
//    NSLog(@"%d",iError);
//}
//
//-(void)onGetPermissionState:(int)iError {
//    NSLog(@"%d",iError);
//}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    if([CLLocationManager significantLocationChangeMonitoringAvailable ]) {
//        [_coreLocationManager stopUpdatingLocation];
        if(self.locationService) {
            [self.locationService restartMonitoringLocation];
            self.locationService.state = UIApplicationStateBackground;
        }
    }else{
        NSLog(@"significant location change monitoring is not avaiable");
    }
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    if([CLLocationManager significantLocationChangeMonitoringAvailable]) {
        if(self.locationService) {
            [self.locationService startMonitoringLocation];
            self.locationService.state = UIApplicationStateActive;
        }
    }else{
        NSLog(@"become active Signification location change monitoring is not avaiable");
    }
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
