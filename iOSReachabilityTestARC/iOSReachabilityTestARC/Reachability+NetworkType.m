//
//  Reachability+NetworkType.m
//  iOSReachabilityTestARC
//
//  Created by arvin.tan on 2016/12/20.
//
//

#import "Reachability+NetworkType.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>

@implementation Reachability (NetworkType)

- (DetailNetWorkStatus)networkStatus {
  SCNetworkReachabilityFlags flags = self.reachabilityFlags;
  if ((flags & kSCNetworkReachabilityFlagsReachable) == 0)
  {
    // The target host is not reachable.
    return DetailNetWorkStatusNotReachable;
  }
  
  DetailNetWorkStatus returnValue = DetailNetWorkStatusNotReachable;
  if ((flags & kSCNetworkReachabilityFlagsConnectionRequired) == 0)
  {
    /*
     If the target host is reachable and no connection is required then we'll assume (for now) that you're on Wi-Fi...
     */
    returnValue = DetailNetWorkStatusWiFi;
  }
  
  if ((((flags & kSCNetworkReachabilityFlagsConnectionOnDemand ) != 0) ||
       (flags & kSCNetworkReachabilityFlagsConnectionOnTraffic) != 0))
  {
    /*
     ... and the connection is on-demand (or on-traffic) if the calling application is using the CFSocketStream or higher APIs...
     */
    
    if ((flags & kSCNetworkReachabilityFlagsInterventionRequired) == 0)
    {
      /*
       ... and no [user] intervention is needed...
       */
      returnValue = DetailNetWorkStatusWiFi;
    }
  }
  
  if ((flags & kSCNetworkReachabilityFlagsIsWWAN) == kSCNetworkReachabilityFlagsIsWWAN)
  {
    /*
     ... but WWAN connections are OK if the calling application is using the CFNetwork APIs.
     */
    NSArray *typeStrings2G = @[CTRadioAccessTechnologyEdge,
                               CTRadioAccessTechnologyGPRS,
                               CTRadioAccessTechnologyCDMA1x];
    
    NSArray *typeStrings3G = @[CTRadioAccessTechnologyHSDPA,
                               CTRadioAccessTechnologyWCDMA,
                               CTRadioAccessTechnologyHSUPA,
                               CTRadioAccessTechnologyCDMAEVDORev0,
                               CTRadioAccessTechnologyCDMAEVDORevA,
                               CTRadioAccessTechnologyCDMAEVDORevB,
                               CTRadioAccessTechnologyeHRPD];
    
    NSArray *typeStrings4G = @[CTRadioAccessTechnologyLTE];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
      CTTelephonyNetworkInfo *teleInfo= [[CTTelephonyNetworkInfo alloc] init];
      NSString *accessString = teleInfo.currentRadioAccessTechnology;
      if ([typeStrings4G containsObject:accessString]) {
        return DetailNetWorkStatusWWAN4G;
      } else if ([typeStrings3G containsObject:accessString]) {
        return DetailNetWorkStatusWWAN3G;
      } else if ([typeStrings2G containsObject:accessString]) {
        return DetailNetWorkStatusWWAN2G;
      } else {
        return DetailNetWorkStatusWWANUnknow;
      }
    } else {
      return DetailNetWorkStatusWWANUnknow;
    }
  }
  
  return returnValue;
}
@end
