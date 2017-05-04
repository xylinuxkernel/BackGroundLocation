//
//  LocationService.h
//  BackGroundLocation
//
//  Created by 徐银 on 2017/3/23.
//  Copyright © 2017年 徐银. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "AppDelegate.h"
@class LocationBaseInfoModel;

@interface LocationService :NSObject

@property (nonatomic, copy) NSDictionary *dataSource;
@property (nonatomic, readonly) CLLocationManager *locationManager;
@property (nonatomic, assign) UIApplicationState state;

+ (id)getInstance;
- (void)startMonitoringLocation;
- (void)restartMonitoringLocation;
- (void)removeArchieveData;
@end
