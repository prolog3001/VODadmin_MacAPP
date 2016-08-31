//
//  ActivityView.h
//  PrologVodOnline
//
//  Created by Gilad Kedmi on 17/08/2016.
//  Copyright © 2016 Gphone. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ActivityView : NSView
{
    NSView *mLayerView;
    IBOutlet NSView *mTransView;
}
-(void)viewWillLayout;
@end
