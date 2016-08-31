//
//  ReachabilityManager.m
//  nextTo
//
//  Created by Gilad Kedmi on 11/24/14.
//  Copyright (c) 2014 Gphone. All rights reserved.
//

#import "ReachabilityManager.h"

static  ReachabilityManager* instance = nil;

@implementation ReachabilityManager


+ (id)reachabilityManager
{
    if (!instance)
    {
        instance = [[ReachabilityManager alloc] init];
    }
    return  instance;
}
-(id)init
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNetworkChange:) name:kReachabilityChangedNotification object:nil];
    
    reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
    
    NetworkStatus remoteHostStatus = [reachability currentReachabilityStatus];
    
    if(remoteHostStatus == NotReachable) {NSLog(@"no");}
    else if (remoteHostStatus == ReachableViaWiFi) {NSLog(@"wifi"); }
    else if (remoteHostStatus == ReachableViaWWAN) {NSLog(@"cell"); }
    status = remoteHostStatus;
    return self;
}
- (void) handleNetworkChange:(NSNotification *)notice
{
    
    NetworkStatus remoteHostStatus = [reachability currentReachabilityStatus];
    status = remoteHostStatus;
    if(remoteHostStatus == NotReachable) {NSLog(@"no");}
    else if (remoteHostStatus == ReachableViaWiFi) {NSLog(@"wifi"); }
    else if (remoteHostStatus == ReachableViaWWAN) {NSLog(@"cell"); }
}
-(BOOL)isReachable
{
    return (status == ReachableViaWiFi || status == ReachableViaWWAN);
}
@end
