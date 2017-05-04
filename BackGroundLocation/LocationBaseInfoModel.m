//
//  LocationBaseInfoModel.m
//  BackGroundLocation
//
//  Created by 徐银 on 2017/3/23.
//  Copyright © 2017年 徐银. All rights reserved.
//

#import "LocationBaseInfoModel.h"

@implementation LocationBaseInfoModel

-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.addressInfo forKey:@"addressInfo"];
    [aCoder encodeObject:self.recordTime forKey:@"recordTime"];
    [aCoder encodeObject:self.longitude forKey:@"longitude"];
    [aCoder encodeObject:self.latitude forKey:@"latitude"];
    [aCoder encodeObject:self.appStateDescription forKey:@"appStateDescription"];

}

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if(self)
    {
        self.addressInfo = [aDecoder decodeObjectForKey:@"addressInfo"];
        self.recordTime = [aDecoder decodeObjectForKey:@"recordTime"];
        self.latitude = [aDecoder decodeObjectForKey:@"latitude"];
        self.longitude = [aDecoder decodeObjectForKey:@"longitude"];
        self.appStateDescription = [aDecoder decodeObjectForKey:@"appStateDescription"];
    }
    return self;
}
@end
