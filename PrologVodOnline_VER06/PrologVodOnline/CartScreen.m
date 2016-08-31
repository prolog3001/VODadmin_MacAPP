//
//  CartScreen.m
//  PrologVodOnline
//
//  Created by Gilad Kedmi on 08/08/2016.
//  Copyright © 2016 Gphone. All rights reserved.
//

#import "CartScreen.h"
#import "ServiceManager.h"
#import "NSImageView+WebCache.h"
#import "CommonDefs.h"
#import "MKStoreKit.h"
#import "TextManager.h"
#import "IAPManager.h"

@implementation CartScreen

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    [[NSColor blackColor] setFill];
    NSRectFill(dirtyRect);
    
    // Drawing code here.
}
- (void)awakeFromNib {
    /*
    for(NSView *view in [self subviews]) {
        NSRect frame = [view frame];
        frame.origin.y = NSMaxY([self bounds]) - NSMaxY([view frame]);
        [view setFrame:frame];
    }
     */
    [self setWantsLayer:YES];
    self.layer.masksToBounds   = YES;
    self.layer.borderWidth      = 2.0f ;
    NSColor *orangeColor = [NSColor yellowColor];
    
    // Convert to CGColorRef
    NSInteger numberOfComponents = [orangeColor numberOfComponents];
    CGFloat components[numberOfComponents];
    CGColorSpaceRef colorSpace = [[orangeColor colorSpace] CGColorSpace];
    [orangeColor getComponents:(CGFloat *)&components];
    CGColorRef orangeCGColor = CGColorCreate(colorSpace, components);
    
    // Set border
    self.layer.borderColor = orangeCGColor;
    
    // Clean up
    CGColorRelease(orangeCGColor);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(courseDetailsDownlodedNotification) name:CourseDetailsDownlodedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MKStoreKitProductsAvailableNotification) name:kMKStoreKitProductsAvailableNotification object:nil];
    
    TextManager *textM = [TextManager textmanager];
    mRestoreBtn.layer.borderWidth = 1.0f;
    mRestoreBtn.layer.borderColor = [ITEMS_COUNTUR_COLOR CGColor];
    [mRestoreBtn setTitle:textM.restore];
    [mRestoreBtn setTitleColor:[NSColor whiteColor]];
    
    mNotNowBtn.layer.borderWidth = 1.0f;
    mNotNowBtn.layer.borderColor = [ITEMS_COUNTUR_COLOR CGColor];
    [mNotNowBtn setTitle:textM.notNow];
    [mNotNowBtn setTitleColor:[NSColor whiteColor]];
    
    mUpgradeBtn.layer.borderWidth = 1.0f;
    mUpgradeBtn.layer.borderColor = [ITEMS_COUNTUR_COLOR CGColor];
    [mUpgradeBtn setTitle:textM.upgradeNow];
    [mUpgradeBtn setTitleColor:[NSColor whiteColor]];

}
-(void)updateCourseContent
{
    ServiceManager *serviceM = [ServiceManager serviceManager];
    NSString *imageUrl = [serviceM productIcon];
    [mProductIconImage setImageURL:[NSURL URLWithString:imageUrl]];
    [self updateCourseIAP];
}

-(void)updateCourseIAP
{
    [mProductTitle setStringValue:[[IAPManager iapManager] IAPProductTitle:[[ServiceManager serviceManager] currentCourseIndex]]];
    [mProductDesc setStringValue:[[IAPManager iapManager] IAPProductDesc:[[ServiceManager serviceManager] currentCourseIndex]]];
    NSString *price = [[IAPManager iapManager] IAPProductPrice: [[ServiceManager serviceManager] currentCourseIndex]];
    TextManager *textM = [TextManager textmanager];
    NSString *tmp = textM.upgradeFor;
    [mPriceTitle setStringValue:[NSString stringWithFormat:@"%@ %@?",tmp,price]];
}

-(void)courseDetailsDownlodedNotification
{
    [self updateCourseContent];
    
}

-(void)MKStoreKitProductsAvailableNotification
{
    [self updateCourseIAP];
}
-(IBAction)upgradePressed:(id)sender
{
    NSString *iapProductID = [[IAPManager iapManager] productID:[[ServiceManager serviceManager] currentCourseIndex]];
    [[MKStoreKit sharedKit] initiatePaymentRequestForProductWithIdentifier:iapProductID];
}
-(IBAction)restorePressed:(id)sender
{
    [[IAPManager iapManager] restorePressed];
}
/*
-(IBAction)upgradePressed:(id)sender
{
    NSString *iapProductID = [[IAPManager iapManager] productID:[[ServiceManager serviceManager] currentCourseIndex]];
    [[MKStoreKit sharedKit] initiatePaymentRequestForProductWithIdentifier:iapProductID];
}
-(IBAction)restorePressed:(id)sender
{
    [[IAPManager iapManager] restorePressed];
}
 */
/*
- (BOOL)isFlipped
{
    return YES;
}
 */
@end
