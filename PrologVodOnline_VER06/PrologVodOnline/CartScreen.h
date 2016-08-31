//
//  CartScreen.h
//  PrologVodOnline
//
//  Created by Gilad Kedmi on 08/08/2016.
//  Copyright © 2016 Gphone. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CustomFontLabel.h"
#import "CustomFontButton.h"

@interface CartScreen : NSView
{
    IBOutlet NSImageView *mProductIconImage;
    IBOutlet CustomFontLabel *mPriceTitle;
    IBOutlet CustomFontLabel *mProductTitle;
    IBOutlet CustomFontLabel *mProductDesc;
    IBOutlet CustomFontButton *mUpgradeBtn;
    IBOutlet CustomFontButton *mNotNowBtn;
    IBOutlet CustomFontButton *mRestoreBtn;
    IBOutlet CustomFontLabel *mTitle;
}
-(IBAction)upgradePressed:(id)sender;
-(IBAction)restorePressed:(id)sender;
@end
