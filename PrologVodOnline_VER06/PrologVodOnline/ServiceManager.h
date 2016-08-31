//
//  ServiceManager.h
//  VODUniversal
//
//  Created by Gilad Kedmi on 01/12/2015.
//  Copyright © 2015 Gphone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseClass.h"
#import <Cocoa/Cocoa.h>
#import "ReachabilityManager.h"

@interface ServiceManager : NSObject
{
    Reachability* mReachability;
    NSArray *mPrologIDs;
    NSArray *mProductsIDs;
    NSArray *mMoreAppsIcons;
    BaseClass *mBaseClass;
    NSDictionary *mCurrentCourseRawDic;
    BOOL mShowMoreAppsAferSplash;
    BOOL mShowBanner;
    NSDictionary *mMoreAppsIconsDic;
    ReachabilityManager *mReachabilityManager;
    NSString *mBannerLink;
    BOOL mRTL;
    BOOL mNoReachabilityShown;
    //UIAlertView *mNoReachabilityAlert;
    NSString *mAppleId;
    
    int mCourseIndexAfterReach;
    BOOL mCourseAnimAfterReach;
    NSView *mViewAfterReach;
}

+ (id)serviceManager;
-(NSArray *)prologIDs;
-(NSString *)moreAppIconImage:(NSString *)appIdx;
-(NSString *)moreAppIconTitle:(NSString *)appIdx;
-(BOOL)hasMoreApps;
-(int)numOfLessons;
-(BOOL)isThisLessonFree:(int)lessonIndex;
-(BOOL)isThisLessonFreeOrPurchased:(int)lessonIndex;
-(BOOL)isThisPdfFree:(int)lessonIndex;
-(BOOL)isThisPdfFreeOrPurchased:(int)lessonIndex;
-(void)downloadCourse:(int)courseIndex WithAnim:(BOOL)anim andView:(NSView *)viewForLoader;
-(void)downlaodMoreAppsIcons;
-(BOOL)hasContent;
-(BOOL)hacContentForThisCourse:(int)courseIndex;
-(int)currentCourseIndex;
//-(void)appWasSelected:(int)addIndex;
-(NSString *)currentPrologAppID;
-(BOOL)showMoreAppsAfterSplash;
-(BOOL)isCurrentCoursePro;
-(BOOL)needToShowBanner;

-(NSString *)productName;
-(NSString *)productDescription;
-(NSString *)productMakat;
-(NSString *)productIcon;
-(NSString *)productBaseURL;
-(NSString *)vimeoLessonItemTitle:(int)lessonIndex;
-(NSString *)vimeoLessonItemDesc:(int)lessonIndex;
-(NSString *)vimeoLessonItemUrl:(int)lessonIndex;
-(NSString *)vimeoLessonPreviewImage:(int)lessonIndex;

-(int)numOfCoursePdfs;
-(NSString *)pdfItemTitle:(int)pdfIndex;
-(NSString *)pdfItemDesc:(int)pdfIndex;
-(NSString *)pdfItemUrl:(int)pdfIndex;
-(BOOL)pdfLTRDirection:(int)lessonIndex;
-(BOOL)productLTRDirection;

-(BOOL)vimeoLessonLTRDirection:(int)lessonIndex;
-(NSString *)bannerLink;
-(BOOL)RTL;
-(NSString *)appleId;

@property (nonatomic, retain) dispatch_queue_t BackgroundQueue;

-(void)setCurrentCourseDic;
-(void)setMoreIconsDic;
-(void)setprologIDs;
@end
