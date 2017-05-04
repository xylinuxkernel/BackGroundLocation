//
//  AppDelegate.h
//  BackGroundLocation
//
//  Created by 徐银 on 2017/3/23.
//  Copyright © 2017年 徐银. All rights reserved.
//
/****************************************/
/*
  后台定位：1.按home键进入休眠（3分钟左右挂起）
           2.App被划掉.任然可以running
 //////
 */

#import <UIKit/UIKit.h>
@class LocationService;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) LocationService *locationService;

@end

