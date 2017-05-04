//
//  LocationBaseInfoModel.h
//  BackGroundLocation
//
//  Created by 徐银 on 2017/3/23.
//  Copyright © 2017年 徐银. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocationBaseInfoModel : NSObject<NSCoding>
@property (nonatomic, copy)  NSString *addressInfo;
@property (nonatomic, copy)  NSString *recordTime;
@property (nonatomic, copy)  NSString *latitude;
@property (nonatomic, copy)  NSString *longitude;
@property (nonatomic, copy)  NSString *appStateDescription;
@end
