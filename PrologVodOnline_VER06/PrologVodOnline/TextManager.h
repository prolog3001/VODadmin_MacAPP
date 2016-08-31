//
//  TextManager.h
//  VODUniversal
//
//  Created by Gilad Kedmi on 31/12/2015.
//  Copyright © 2015 Gphone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TextManager : NSObject


@property (nonatomic, strong) NSString *getThisApp;
@property (nonatomic, strong) NSString *wouldLikeGetThisApp;
@property (nonatomic, strong) NSString *moreAppsTitle;
@property (nonatomic, strong) NSString *decideToUpgrade;
@property (nonatomic, strong) NSString *upgradeNow;
@property (nonatomic, strong) NSString *notNow;
@property (nonatomic, strong) NSString *restore;
@property (nonatomic, strong) NSString *selectALesson;
@property (nonatomic, strong) NSString *clickLesson;
@property (nonatomic, strong) NSString *itemNotAvailable;
@property (nonatomic, strong) NSString *downloadingCourse;
@property (nonatomic, strong) NSString *noInternet;
@property (nonatomic, strong) NSString *noInternetOK;
@property (nonatomic, strong) NSString *upgradeFor;
//
+ (id)textmanager;
@end
