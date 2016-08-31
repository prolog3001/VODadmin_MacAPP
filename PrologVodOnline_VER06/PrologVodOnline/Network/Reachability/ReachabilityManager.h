//
//  ReachabilityManager.h
//  nextTo
//
//  Created by Gilad Kedmi on 11/24/14.
//  Copyright (c) 2014 Gphone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

@interface ReachabilityManager : NSObject
{
    Reachability* reachability;
    NetworkStatus status;
}

+ (id)reachabilityManager;
-(BOOL)isReachable;
@end
