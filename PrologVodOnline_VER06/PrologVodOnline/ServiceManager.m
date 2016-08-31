//
//  ServiceManager.m
//  VODUniversal
//
//  Created by Gilad Kedmi on 01/12/2015.
//  Copyright © 2015 Gphone. All rights reserved.
//

#import "ServiceManager.h"
#import "MiscFunc.h"
#import "CommonDefs.h"
#import "SFData.h"
#import "DigitalProductItemList.h"
#import "IAPManager.h"
#import "TextManager.h"
//#import "UIAlertView+Blocks.h"

static  ServiceManager* instance = nil;

@implementation ServiceManager

+ (id)serviceManager
{
    if (!instance)
    {
        instance = [[ServiceManager alloc] init];
    }
    return  instance;
}
-(id)init
{
    [IAPManager iapManager];
    mNoReachabilityShown = NO;
    [self setCurrentCourseDic];
    [self setMoreIconsDic];
    self.BackgroundQueue = dispatch_queue_create("prologVOD", NULL);
    [self setprologIDs];
    mReachability = [Reachability reachabilityForInternetConnection];
    [mReachability startNotifier];
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(handleNetworkChange:) name: kReachabilityChangedNotification object: nil];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ReachabilityIsON) name:ReachabilityONNotification object:nil];
    return self;
}
- (void)handleNetworkChange:(NSNotification *)notice
{
    NetworkStatus remoteHostStatus = [mReachability currentReachabilityStatus];
    
    if          (remoteHostStatus == NotReachable)
    {
        DLog(@"no");
        //[[NSNotificationCenter defaultCenter] postNotificationName:ReachabilityOFFNotification object:nil userInfo:nil];
    }
    else if     (remoteHostStatus == ReachableViaWiFi)
    {
        DLog(@"wifi");
        if(!mNoReachabilityShown)
            [self ReachabilityChangedToON];
        //[[NSNotificationCenter defaultCenter] postNotificationName:ReachabilityONNotification object:nil userInfo:nil];
    }
    else if     (remoteHostStatus == ReachableViaWWAN)
    {
        DLog(@"cell");
        if(mNoReachabilityShown)
            [self ReachabilityChangedToON];
        //[[NSNotificationCenter defaultCenter] postNotificationName:ReachabilityONNotification object:nil userInfo:nil];
    }
}
-(void)ReachabilityChangedToON
{
    mNoReachabilityShown = NO;
    /*
    if(mNoReachabilityAlert)
        [mNoReachabilityAlert didDismissBlock];
     */
    [self downloadCourse:mCourseIndexAfterReach WithAnim:mCourseAnimAfterReach andView:mViewAfterReach];
    [self downlaodMoreAppsIcons];
}
-(void)setCurrentCourseDic
{
    NSString *cachePath = [MiscFunc getCacheDirPath];
    NSString *filePath = [cachePath stringByAppendingPathComponent:@"CoursesDic.plist"];
    DLog(@"CoursesDic = %@",filePath);
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath])//first time running
    {
        mCurrentCourseRawDic = nil;
    }
    else
    {
        NSDictionary *coursesDic = [NSDictionary dictionaryWithContentsOfFile:filePath];
        NSString * currentCourseIndex = [coursesDic objectForKey:@"currentCourseIndex"];
        mCurrentCourseRawDic = [coursesDic objectForKey:currentCourseIndex];
        mBaseClass = [BaseClass modelObjectWithDictionary:mCurrentCourseRawDic];
        
    }
}
-(void)setMoreIconsDic
{
    NSString *cachePath = [MiscFunc getCacheDirPath];
    NSString *filePath = [cachePath stringByAppendingPathComponent:@"MoreIconsDic.plist"];
    DLog(@"MoreIconsDic = %@",filePath);
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath])//first time running
    {
        mMoreAppsIconsDic = [NSDictionary dictionaryWithContentsOfFile:filePath];
    }
    
}
-(void)setprologIDs
{
    //NSString *cachePath = [MiscFunc getCacheDirPath];
    //NSString *filePath = [cachePath stringByAppendingPathComponent:@"MessagesDic.plist"];
    //DLog(@"setMessagesDic = %@",filePath);
    if(!mPrologIDs)
    {
        NSString *appDetailsFile = [[NSBundle mainBundle] pathForResource:@"AppDetails" ofType:@"plist"];
        NSDictionary *dic  = [NSDictionary dictionaryWithContentsOfFile:appDetailsFile];
        mShowMoreAppsAferSplash = [[dic objectForKey:@"show more apps after splash"] boolValue];
        mShowBanner = [[dic objectForKey:@"show banner"] boolValue];
        mPrologIDs = [dic objectForKey:@"prolog ids"];
        mBannerLink = [dic objectForKey:@"banner link"];
        mRTL = [[dic objectForKey:@"RTL"] boolValue];
        mAppleId = [dic objectForKey:@"apple ID for rating"];
        //mMoreAppsIcons = [dic objectForKey:@"more Apps icons images"];
    }
}
-(NSString *)bannerLink
{
    return mBannerLink;
}
-(BOOL)RTL
{
    return mRTL;
}
-(NSString *)appleId
{
    return  mAppleId;
}
-(NSArray *)prologIDs
{
    return mPrologIDs;
}
-(NSString *)moreAppIconImage:(NSString *)appIdx
{
    if(mMoreAppsIconsDic)
    {
        return [[mMoreAppsIconsDic objectForKey:appIdx] objectForKey:@"Icon"] ;
    }
    else
    {
        return nil;
    }
    //return [mMoreAppsIcons objectAtIndex:appIdx];
}
-(NSString *)moreAppIconTitle:(NSString *)appIdx
{
    if(mMoreAppsIconsDic)
    {
        return [[mMoreAppsIconsDic objectForKey:appIdx] objectForKey:@"Name"] ;
    }
    else
    {
        return nil;
    }
}
-(BOOL)hasMoreApps
{
    return mMoreAppsIconsDic != nil;
}
-(int)numOfLessons
{
    return (int)[mBaseClass.mDigitalVimeoProductItemList count];
}
-(NSString *)vimeoLessonItemTitle:(int)lessonIndex
{
    DigitalProductItemList *item = [mBaseClass.mDigitalVimeoProductItemList objectAtIndex:lessonIndex];
    return item.name;
}
-(NSString *)vimeoLessonItemDesc:(int)lessonIndex
{
    DigitalProductItemList *item = [mBaseClass.mDigitalVimeoProductItemList objectAtIndex:lessonIndex];
    return item.digitalProductItemListDescription;
}
-(NSString *)vimeoLessonItemUrl:(int)lessonIndex
{
    DigitalProductItemList *item = [mBaseClass.mDigitalVimeoProductItemList objectAtIndex:lessonIndex];
    return item.urlCurrent;
}
-(NSString *)vimeoLessonPreviewImage:(int)lessonIndex
{
    DigitalProductItemList *item = [mBaseClass.mDigitalVimeoProductItemList objectAtIndex:lessonIndex];
    return item.vimeoPreviewImage;
}
-(BOOL)vimeoLessonLTRDirection:(int)lessonIndex
{
    DigitalProductItemList *item = [mBaseClass.mDigitalVimeoProductItemList objectAtIndex:lessonIndex];
    return ((int)item.spokenLanguageID != 1 && (int)item.spokenLanguageID != 11);
}
-(BOOL)productLTRDirection
{
    return ((int)mBaseClass.spokenLanguagesID != 1 && (int)mBaseClass.spokenLanguagesID != 11);
}
-(BOOL)pdfLTRDirection:(int)lessonIndex
{
    DigitalProductItemList *item = [mBaseClass.mDigitalPdfProductItemList objectAtIndex:lessonIndex];
    return ((int)item.spokenLanguageID != 1 && (int)item.spokenLanguageID != 11);
}
-(int)numOfCoursePdfs
{
    return (int)[mBaseClass.mDigitalPdfProductItemList count];
}
-(NSString *)pdfItemTitle:(int)pdfIndex
{
    DigitalProductItemList *item = [mBaseClass.mDigitalPdfProductItemList objectAtIndex:pdfIndex];
    return item.chapterName;
}
-(NSString *)pdfItemDesc:(int)pdfIndex
{
    DigitalProductItemList *item = [mBaseClass.mDigitalPdfProductItemList objectAtIndex:pdfIndex];
    return item.digitalProductItemListDescription;
}
-(NSString *)pdfItemUrl:(int)pdfIndex
{
    DigitalProductItemList *item = [mBaseClass.mDigitalPdfProductItemList objectAtIndex:pdfIndex];
    return item.urlCurrent;
}
-(BOOL)isThisLessonFree:(int)lessonIndex
{
    if([mBaseClass.mDigitalVimeoProductItemList count] < lessonIndex)
        return NO;
    DigitalProductItemList *item = [mBaseClass.mDigitalVimeoProductItemList objectAtIndex:lessonIndex];
    return item.isFree;
}
-(BOOL)isThisLessonFreeOrPurchased:(int)lessonIndex
{
    if([mBaseClass.mDigitalVimeoProductItemList count] < lessonIndex)
        return NO;
    DigitalProductItemList *item = [mBaseClass.mDigitalVimeoProductItemList objectAtIndex:lessonIndex];
    return (item.isFree || [self isThisCoursePro:[self currentPrologAppID]]);
}
-(BOOL)isThisPdfFree:(int)lessonIndex
{
    if([mBaseClass.mDigitalPdfProductItemList count] < lessonIndex)
        return NO;
    DigitalProductItemList *item = [mBaseClass.mDigitalPdfProductItemList objectAtIndex:lessonIndex];
    return item.isFree;
}
-(BOOL)isThisPdfFreeOrPurchased:(int)lessonIndex
{
    if([mBaseClass.mDigitalPdfProductItemList count] < lessonIndex)
        return NO;
    DigitalProductItemList *item = [mBaseClass.mDigitalPdfProductItemList objectAtIndex:lessonIndex];
    return (item.isFree || [self isThisCoursePro:[self currentPrologAppID]]);
}
-(BOOL)isThisCoursePro:(NSString *)courseID
{
    int productIDIdx = [mPrologIDs indexOfObject:courseID];
    return [[IAPManager iapManager] isThisCoursePurchased:productIDIdx];
}
-(BOOL)isCurrentCoursePro
{
    return [self isThisCoursePro:[self currentPrologAppID]];
}
-(BOOL)hasContent
{
    if(mCurrentCourseRawDic)
        return YES;
    return NO;
}
-(BOOL)hacContentForThisCourse:(int)courseIndex
{
    NSString *cachePath = [MiscFunc getCacheDirPath];
    NSString *filePath = [cachePath stringByAppendingPathComponent:@"CoursesDic.plist"];
    //DLog(@"CoursesDic = %@",filePath);
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        NSDictionary *coursesDic = [NSDictionary dictionaryWithContentsOfFile:filePath];
        NSString *existPrologAppID = [mPrologIDs objectAtIndex:courseIndex];
        return ([coursesDic objectForKey:existPrologAppID] != nil);
    }
    else
        return NO;

}
-(int)currentCourseIndex
{
    //int a = (int)mBaseClass.productID;
    return [mPrologIDs indexOfObject:[NSString stringWithFormat:@"%d",(int)mBaseClass.productID]];
}
/*
-(void)appWasSelected:(int)addIndex
{
    NSString *appSelectedID = [mPrologIDs objectAtIndex:addIndex];
    if(![appSelectedID isEqualToString:[self currentPrologAppID]])// user choosed the current course
    {
        [self downloadCourse:addIndex];
    }
}
 */
-(void)downlaodMoreAppsIcons
{
    SFData *SFDataM =  [SFData sfdataSharedObject];
    void (^oSuccessBlock)(id responseObject) = ^(id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            //DLog(@"downlaodMoreAppsIcons: %@", responseObject);
            mMoreAppsIconsDic = responseObject;
            [[NSNotificationCenter defaultCenter] postNotificationName:MoreAppsIconsDownlodedNotification object:nil userInfo:nil];
            //NSString *json = [self dicToJSON:responseObject];
            //DLog(@"json = %@",json);
            
        });
    };
    void (^oFailBlock)(NSError *error) = ^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            //[MiscFunc HideActivityView ];
            DLog(@"ERROR = %@",error.description);
            BOOL reach = [mReachabilityManager isReachable];
            if(reach)
                [self downlaodMoreAppsIcons];
            
        });
    };
    //NSMutableString *getUrl = [[NSMutableString alloc] initWithString:@"DigitalProductIcons/"];
    NSMutableString *getUrl = [[NSMutableString alloc] initWithString:@"DigitalProductMainDetails/"];
    for (int i  = 0; i < [mPrologIDs count]; ++i) {
        if(i == [mPrologIDs count] - 1)
        {
            [getUrl appendString:[mPrologIDs objectAtIndex:i]];
        }
        else
        {
            [getUrl appendString:[NSString stringWithFormat:@"%@,",[mPrologIDs objectAtIndex:i]]];
        }
    }
    SFDataM.ServiceID = getUrl;
    
    [SFDataM LoadDataFromServer:nil Post:nil success:oSuccessBlock failure:oFailBlock];
}
-(void)downloadCourse:(int)courseIndex WithAnim:(BOOL)anim andView:(NSView *)viewForLoader
{
    [self checkForExistingcourse:courseIndex];
    
    BOOL reach = [[ReachabilityManager reachabilityManager] isReachable];
    if(!reach && !mNoReachabilityShown)
    {
        mCourseIndexAfterReach = courseIndex;
        mCourseAnimAfterReach = anim;
        mViewAfterReach = viewForLoader;
        mNoReachabilityShown = YES;
        NSString *message =  ((TextManager *)[TextManager textmanager]).noInternet;
        /*
        mNoReachabilityAlert = [UIAlertView showWithTitle:nil
                           message:message
                 cancelButtonTitle:((TextManager *)[TextManager textmanager]).noInternetOK
                 otherButtonTitles:nil
                          tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                              if (buttonIndex == [alertView cancelButtonIndex]) {
                              }
                              else  {
                                  
                              }
                          }];
         */
        return;
    }
    
    SFData *SFDataM =  [SFData sfdataSharedObject];
    void (^oSuccessBlock)(id responseObject) = ^(id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            //if(anim)
              //  [MiscFunc HideActivityView ];
            //[self downloadMarketsSuccess:responseObject];
            //DLog(@"downloadProducts: %@", responseObject);
            //NSString *json = [self dicToJSON:responseObject];
            //DLog(@"json = %@",json);
             NSDictionary *dic = [responseObject nestedDictionaryByReplacingNullsWithNil:responseObject];
            [self courseDownloadedSuccefull:dic];
                    });
    };
    void (^oFailBlock)(NSError *error) = ^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            //if(anim)
              //  [MiscFunc HideActivityView ];
            //[MiscFunc HideActivityView ];
            DLog(@"ERROR = %@",error.description);
            BOOL reach = [mReachabilityManager isReachable];
            if(reach)
                [self downloadCourse:courseIndex WithAnim:anim andView:viewForLoader];
            
        });
    };
    //[MiscFunc ShowActivityView:self.view];
    //NSString *currentPrologAppID = [self currentPrologAppID];
    NSString *currentPrologAppID = [mPrologIDs objectAtIndex:courseIndex];
    NSString *getUrl = [NSString stringWithFormat:@"%@?useremail=oded@prolog.co.il",currentPrologAppID];
    SFDataM.ServiceID = getUrl;
    /*
    NSString *q = NULL;
    NSMutableDictionary *postParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       q?q:@"קפ" , @"q",
                                       [NSNumber numberWithInt:1] , @"Page",
                                       @"Relevance" , @"Sort",
                                       nil];
    */
    if(anim)
    {
        //[MiscFunc ShowActivityView:[[[UIApplication sharedApplication] delegate] window] message:@"Downloading new course"];
        //[MiscFunc ShowActivityView:viewForLoader message:((TextManager *)[TextManager textmanager]).downloadingCourse];
        //
    }
    [SFDataM LoadDataFromServer:nil Post:nil success:oSuccessBlock failure:oFailBlock];
    
}
-(void)checkForExistingcourse:(int)courseIndex
{
    NSString *cachePath = [MiscFunc getCacheDirPath];
    NSString *filePath = [cachePath stringByAppendingPathComponent:@"CoursesDic.plist"];
    //DLog(@"CoursesDic = %@",filePath);
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        NSDictionary *coursesDic = [NSDictionary dictionaryWithContentsOfFile:filePath];
        NSString *existPrologAppID = [mPrologIDs objectAtIndex:courseIndex];
        mCurrentCourseRawDic = [coursesDic objectForKey:existPrologAppID];
        if(mCurrentCourseRawDic)
        {
            if(mBaseClass)
                mBaseClass = nil;
            mBaseClass = [BaseClass modelObjectWithDictionary:mCurrentCourseRawDic];
            [[NSNotificationCenter defaultCenter] postNotificationName:CourseDetailsDownlodedNotification object:nil userInfo:nil];
        }
    }
    
}
-(NSString *)currentPrologAppID
{
    if(mCurrentCourseRawDic)
    {
        return [NSString stringWithFormat:@"%d",(int)mBaseClass.productID];
    }
    else
    {
        return [mPrologIDs objectAtIndex:0];
    }
}
-(BOOL)showMoreAppsAfterSplash
{
    return mShowMoreAppsAferSplash;
}
-(BOOL)needToShowBanner
{
    return mShowBanner;
}
-(void)courseDownloadedSuccefull:(NSDictionary *)courseDetails
{
    if(mBaseClass)
        mBaseClass  = nil;
    mBaseClass = [BaseClass modelObjectWithDictionary:courseDetails];
    if(mCurrentCourseRawDic)
    {
        mCurrentCourseRawDic = nil;
    }
    NSString *cachePath = [MiscFunc getCacheDirPath];
    NSString *filePath = [cachePath stringByAppendingPathComponent:@"CoursesDic.plist"];
    DLog(@"filePath = %@",filePath);
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath])//first time running
    {
        NSMutableDictionary *dicToInsert = [[NSMutableDictionary alloc] init];
        [dicToInsert setObject:[courseDetails mutableCopy] forKey:[NSString stringWithFormat:@"%d",(int)mBaseClass.productID]];
        [dicToInsert setObject:[NSString stringWithFormat:@"%d",(int)mBaseClass.productID] forKey:@"currentCourseIndex"];
        //NSDictionary *dic = [NSDictionary dictionaryWithDictionary:dicToInsert];
        //NSDictionary *dic = [dicToInsert nestedDictionaryByReplacingNullsWithNil:dicToInsert];
        [dicToInsert writeToFile:filePath atomically:YES];
        
        //BOOL a = [dicToInsert writeToFile:filePath atomically:YES];
        //int d = 6;
    }
    else
    {
        NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:filePath];
        NSMutableDictionary *dicToInsert = [NSMutableDictionary dictionaryWithDictionary:dic];
        [dicToInsert setObject:courseDetails forKey:[NSString stringWithFormat:@"%d",(int)mBaseClass.productID]];
        [dicToInsert setObject:[NSString stringWithFormat:@"%d",(int)mBaseClass.productID] forKey:@"currentCourseIndex"];
        [dicToInsert writeToFile:filePath atomically:YES];
    }
    mCurrentCourseRawDic = courseDetails;
    [[NSNotificationCenter defaultCenter] postNotificationName:CourseDetailsDownlodedNotification object:nil userInfo:nil];
    
}
-(NSString *)dicToJSON:(NSMutableDictionary *)dic
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    if (! jsonData) {
        NSLog(@"bv_jsonStringWithPrettyPrint: error: %@", error.localizedDescription);
        return @"{}";
    } else {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}

#pragma mark ghetters
-(NSString *)productName
{
    return mBaseClass.productName;
}
-(NSString *)productIcon
{
    return mBaseClass.productImageDataURL;
}
-(NSString *)productDescription
{
    return mBaseClass.productDescription;
}
-(NSString *)productMakat
{
    return mBaseClass.makat;
}
-(NSString *)productBaseURL
{
    //return @"http://www.prolog.co.il/ContentImages/DigitalEditions/Products/";
    return [NSString stringWithString:@"http://www.prolog.co.il/ContentImages/DigitalEditions/Products/"];
}
@end
