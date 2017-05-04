//
//  LocationService.m
//  BackGroundLocation
//
//  Created by 徐银 on 2017/3/23.
//  Copyright © 2017年 徐银. All rights reserved.
//

#import "LocationService.h"
#import "LocationBaseInfoModel.h"
#import "NSDate+Addition.h"
#import <AddressBookUI/AddressBookUI.h>
@interface LocationService()<CLLocationManagerDelegate>
{
    NSTimer *_timer;
    BOOL isNeedFresh;
}
@property (nonatomic , strong) CLLocationManager *locationManager;
@end

@implementation LocationService

+(id)getInstance {
    
    static LocationService *shareManager = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        shareManager = [[[self class] alloc]init];
        [shareManager startTimer];
    });
    return shareManager;
}

//-(instancetype)init {
//    self = [super init];
//    if(self) {
//        self.locationManager = [CLLocationManager new];
//        self.locationManager.delegate = self;
//        self.locationManager.distanceFilter = 500;
//        self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
//        //        _localService.allowsBackgroundLocationUpdates = YES;
//    }
//    return self;
//}

//-(void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation {
//    CLLocationCoordinate2D pt = CLLocationCoordinate2DMake([userLocation.location coordinate].latitude, [userLocation.location coordinate].longitude);
//    BMKReverseGeoCodeOption *reverseGeoCodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
//    reverseGeoCodeSearchOption.reverseGeoPoint = pt;
//    BOOL flag = [_search reverseGeoCode:reverseGeoCodeSearchOption];
//    if(flag)
//    {
//        NSLog(@"反geo检索发送成功");
//    }
//    else
//    {
//        NSLog(@"反geo检索发送失败");
//    }
//}
//
//- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error {
//    if(error == BMK_SEARCH_NO_ERROR) {
//        NSLog(@"%@",result.address);
//        NSString *detailTime = [NSDate nowDateToString];
//        LocationBaseInfoModel *localModel = [[LocationBaseInfoModel alloc] init];
//        localModel.longitude =  [NSString stringWithFormat:@"%f",[result location].longitude];
//        localModel.latitude =  [NSString stringWithFormat:@"%f",[result location].latitude];
//        localModel.addressInfo = result.address;
//        localModel.recordTime = detailTime;
//        [self saveLocationData:localModel];
//    }
//}
#pragma mark - location
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocationCoordinate2D pt = CLLocationCoordinate2DMake([manager.location coordinate].latitude, [manager.location coordinate].longitude);
    //反地理编码
    CLGeocoder *geocoder = [CLGeocoder new];
    [geocoder reverseGeocodeLocation:manager.location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if(!error) {
            if(placemarks.count) {
                CLPlacemark *plaMark = placemarks[0];
                NSString *detailAddress = [plaMark.addressDictionary[@"FormattedAddressLines"][0]   stringByRemovingPercentEncoding] ;
                NSLog(@"%@",detailAddress);
                NSString *detailTime = [NSDate nowDateToString];
                LocationBaseInfoModel *localModel = [[LocationBaseInfoModel alloc] init];
                localModel.longitude =  [NSString stringWithFormat:@"%f",pt.longitude];
                localModel.latitude =  [NSString stringWithFormat:@"%f",pt.latitude];
                localModel.addressInfo = detailAddress;
                localModel.recordTime = detailTime;
                localModel.appStateDescription = (self.state == UIApplicationStateActive ? @"前台运行获取":self.state == UIApplicationStateBackground ? @"后台挂起获取":@"杀掉唤醒获取");
                [self saveLocationData:localModel];
            }
        }
    }];
//    BMKReverseGeoCodeOption *reverseGeoCodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
//    reverseGeoCodeSearchOption.reverseGeoPoint = pt;
//    BOOL flag = [_search reverseGeoCode:reverseGeoCodeSearchOption];
//    if(flag)
//    {
//        NSLog(@"反geo检索发送成功");
//    }
//    else
//    {
//        NSLog(@"反geo检索发送失败");
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error  {
    if(error) {
        NSLog(@"location error");
    }
}

- (void)startTimer {
    if(!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:30.0f target:self selector:@selector(getArchievedData) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    isNeedFresh = YES;
    [self getArchievedData];
}

- (void)startMonitoringLocation {
    if(_locationManager) {
        [_locationManager stopMonitoringSignificantLocationChanges];
    }
    self.locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    _locationManager.distanceFilter = 100;
    _locationManager.pausesLocationUpdatesAutomatically = NO;
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
    [self.locationManager requestAlwaysAuthorization];
#endif
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 90000
    [self.locationManager setAllowsBackgroundLocationUpdates:YES];
#endif
    [self.locationManager startUpdatingLocation];
    [self.locationManager startMonitoringSignificantLocationChanges];
}

- (void)restartMonitoringLocation {
    [self.locationManager stopMonitoringSignificantLocationChanges];
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
    [self.locationManager requestAlwaysAuthorization];
#endif
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 90000
    [self.locationManager setAllowsBackgroundLocationUpdates:YES];
#endif
    [self.locationManager startMonitoringSignificantLocationChanges];
    self.locationManager.pausesLocationUpdatesAutomatically = NO;
    [self.locationManager startUpdatingLocation];
    [self.locationManager startUpdatingLocation];
}


- (void)getArchievedData {
    NSDictionary *location = [self readLocationData];
    if(isNeedFresh){
        self.dataSource = location;
        isNeedFresh = NO;
    }
}

- (void)saveLocationData:(LocationBaseInfoModel *)baseModel {
    NSString *sectionTitleKey = [[NSDate date] toStringWithFormat:@"yyyy-MM-dd"];
    NSMutableDictionary *tempLocationList = [[self readLocationData] mutableCopy];
    if(tempLocationList){
        if([[tempLocationList allKeys] containsObject:sectionTitleKey]) {
            //tail add
            NSMutableArray *tempTailAddArr = [tempLocationList objectForKey:sectionTitleKey];
            [tempTailAddArr addObject:baseModel];
            
        } else {
            //new add
            NSMutableArray *tempNewAddArr = [NSMutableArray arrayWithObject:baseModel];
            [tempLocationList setObject:tempNewAddArr forKey:sectionTitleKey];
        }
    }
    else {
        //all new add
        NSMutableArray *tempNewAddArr = [NSMutableArray arrayWithObject:baseModel];
        tempLocationList = [NSMutableDictionary dictionaryWithObject:tempNewAddArr forKey:sectionTitleKey];
    }
    
    NSString *sandxLibrary = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *locationFile = [NSString stringWithFormat:@"%@/location.data",sandxLibrary];
    
    BOOL success =[NSKeyedArchiver archiveRootObject:tempLocationList toFile:locationFile];
    if(success) {
        NSLog(@"archieved success");
        isNeedFresh = YES;
    }
}

- (NSDictionary *)readLocationData {
    NSString *sandxLibrary = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *locationFile = [NSString stringWithFormat:@"%@/location.data",sandxLibrary];
    NSData *data = [NSData dataWithContentsOfFile:locationFile];
    NSDictionary  *location = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    if([location isKindOfClass:[NSDictionary class]]) {
        return location;
    }
    return  nil;
}

- (void)removeArchieveData {
    NSString *sandxLibrary = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *locationFile = [NSString stringWithFormat:@"%@/location.data",sandxLibrary];
    NSFileManager *file = [NSFileManager defaultManager];
    if([file fileExistsAtPath:locationFile]) {
        [file removeItemAtPath:locationFile error:nil];
    }
    self.dataSource  = nil;
}
@end
