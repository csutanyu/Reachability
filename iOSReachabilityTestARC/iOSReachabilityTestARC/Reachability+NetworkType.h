//
//  Reachability+NetworkType.h
//  iOSReachabilityTestARC
//
//  Created by arvin.tan on 2016/12/20.
//
//

#import "Reachability.h"

typedef NS_ENUM(NSUInteger, DetailNetWorkStatus) {
  DetailNetWorkStatusNotReachable = 0,
  DetailNetWorkStatusWWANUnknow = 1,
  DetailNetWorkStatusWWAN2G = 2,
  DetailNetWorkStatusWWAN3G = 3,
  DetailNetWorkStatusWWAN4G = 4,
  DetailNetWorkStatusWiFi = 9
};

// Ref: http://www.jianshu.com/p/7b98fb9dad45
// If the network is WWAN, can distinguish the mobile netowrk generation
@interface Reachability (NetworkType)
- (DetailNetWorkStatus)networkStatus;
@end
