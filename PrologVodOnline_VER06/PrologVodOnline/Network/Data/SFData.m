//
//  SFData.m
//
//  Created by  on 2/23/12.
//  Copyright (c) 2012 Tomer Lavi (Assist). All rights reserved.
//

#import "SFData.h"
#include "MiscFunc.h"
#include "AppDelegate.h"

static  SFData* instance = nil;

@implementation SFData

+ (id)sfdataSharedObject
{
    if (!instance)
    {
        instance = [[SFData alloc] init];
    }
    return  instance;
}
- (void) LoadDataFromServer:(NSString *)sGet Post:(NSDictionary *)aPost success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure {
	WebService *oWebService = [WebService SharedWebService];

	void (^oSuccessBlock)(id responseObject) = ^(id responseObject) {
		self.Data = responseObject;
		dispatch_async([MiscFunc BackgroundQueue], ^{success(responseObject);});
	};
	void (^oFailBlock)(NSError *error) = ^(NSError *error) {
		dispatch_async([MiscFunc BackgroundQueue], ^{failure(error);});
	};

	[oWebService CallWebService:self.ServiceID WithGet:sGet Post:aPost success:oSuccessBlock failure:oFailBlock];
}


/*
 
#pragma mark Web Service Delegate
- (void)requestError:(NSError*)error {
#if DEBUG
	NSLog(@"DataDownloader Error%@", error);
#endif
	[MiscFunc HideActivityView];
	[MiscFunc ShowErrorMessage:NSLocalizedString(@"Network Error", nil)];
	if (self.Delegate && [self.Delegate respondsToSelector:@selector(onDownloadFailed:)]) [self.Delegate onDownloadFailed:self.ServiceID];
}


- (BOOL) HandleWebServiceStatus:(NSDictionary *)aStatus {
	if ([aStatus[@"status"] isEqualToString:@"error"] && (!self.AllowErrors || [self.AllowErrors indexOfObject:aStatus[@"message"]] == NSNotFound)) {
		if (self.IsMandatory) [MiscFunc ShowErrorMessage:NSLocalizedString(aStatus[@"message"], nil)];
		return false;
	} else {
		return true;
	}
}

- (void)requestFinished:(id)response {
//	NSLog(@"%@", response);
#if DEBUG
	NSLog(@"Downloaded: %@", self.ServiceID);
#endif
	[MiscFunc HideActivityView];
	self.Data = response;
	if (![self HandleWebServiceStatus:self.Data]) return;
	
#if DEBUG
	NSLog(@"Success Downloaded: %@", self.ServiceID);
#endif
	if (self.Delegate) [self.Delegate onDownloadSuccess:self.ServiceID];
}
*/

@end
