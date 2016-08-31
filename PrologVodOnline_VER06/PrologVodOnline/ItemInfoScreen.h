//
//  ItemInfoScreen.h
//  PrologVodOnline
//
//  Created by Gilad Kedmi on 11/08/2016.
//  Copyright © 2016 Gphone. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ItemInfoScreen : NSView
{
    IBOutlet NSTextView *mTextView;
    IBOutlet NSScrollView *mScrollView;
    IBOutlet NSTextField *mTitle;
}
-(void)updateContent:(NSString *)title Desc:(NSString *)desc andDir:(BOOL)LTR;
@end
