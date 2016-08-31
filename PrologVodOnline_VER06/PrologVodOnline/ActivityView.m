//
//  ActivityView.m
//  PrologVodOnline
//
//  Created by Gilad Kedmi on 17/08/2016.
//  Copyright © 2016 Gphone. All rights reserved.
//

#import "ActivityView.h"

@implementation ActivityView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    [[NSColor clearColor] setFill];
    NSRectFill(dirtyRect);
    
    // Drawing code here.
}
- (void)mouseDown:(NSEvent *)theEvent{
    //Do nothing to not propagate the click event to descendant views
}
- (void)awakeFromNib {
    [mTransView setWantsLayer:YES];
    mTransView.layer.backgroundColor = [[NSColor blackColor] CGColor];
    mTransView.alphaValue = 0.9;
    CGPoint p = CGPointMake((self.frame.origin.x + (self.frame.size.width / 2)),(self.frame.origin.y + (self.frame.size.height / 2)));
    NSImageView *view = [[NSImageView alloc] initWithFrame:CGRectMake(10, 10, 50, 50)];
    view.imageScaling = NSImageScaleNone;
    view.animates = YES;
    view.image = [NSImage imageNamed:@"loader.gif"];
    //[view.image setCacheMode:NSImageCacheAlways];
    view.canDrawSubviewsIntoLayer = YES;
    
    mLayerView = [[NSView alloc] initWithFrame:CGRectMake(p.x - 30, p.y - 30, 60, 60)];
    mLayerView.wantsLayer = YES;
    [mLayerView addSubview:view];
    
    [self addSubview:mLayerView];
    
}
-(void)viewWillLayout
{
    CGPoint p = CGPointMake((self.frame.origin.x + (self.frame.size.width / 2)),(self.frame.origin.y + (self.frame.size.height / 2)));
    mLayerView.frame = CGRectMake(p.x - 30, p.y - 30, 60, 60);
}
- (BOOL)isFlipped
{
    return YES;
}
@end
