//
//  CustomFontLabel.m
//  nextTo
//
//  Created by Gilad Kedmi on 1/13/15.
//  Copyright (c) 2015 Gphone. All rights reserved.
//

#import "CustomFontLabel.h"
#import "MiscFunc.h"

@implementation CustomFontLabel

- (void)awakeFromNib {
    [super awakeFromNib];
    //DLog(@"self.font.pointSize = %2f",self.font.pointSize);
    //CGFloat pointSize = self.font.pointSize;
    NSFont *font1 = [NSFont fontWithName:[MiscFunc fontWithIndex:0] size:10.0];
    NSFont *font2 = [NSFont fontWithName:[MiscFunc fontWithIndex:1] size:10.0];
    NSFont *font3 = [NSFont fontWithName:[MiscFunc fontWithIndex:2] size:10.0];
    NSFont *font4 = [NSFont fontWithName:[MiscFunc fontWithIndex:3] size:10.0];
    //oded change here custom fonts
    [self setFont:[NSFont fontWithName:[MiscFunc fontWithIndex:(int)self.tag] size:self.font.pointSize]];
    
    NSFont *ff = [NSFont fontWithName:[MiscFunc fontWithIndex:(int)self.tag] size:50.0];
    int a = 9;
    //[self setFont:[NSFont fontWithName:[MiscFunc fontWithIndex:(int)self.tag] size:50.0]];
    /*
    [numberLbl setAlignment:NSTextAlignmentCenter];
    [numberLbl.layer setBackgroundColor:[[NSColor clearColor] CGColor]];
    [numberLbl setBackgroundColor:[NSColor clearColor]];
    [numberLbl setDrawsBackground:YES];
    [numberLbl setBordered:NO];
     */
}
/*
-(void)drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {
    NSAttributedString *attrString = self.attributedStringValue;
    
    // if your values can be attributed strings, make them white when selected 
    if (self.isHighlighted && self.backgroundStyle==NSBackgroundStyleDark) {
        NSMutableAttributedString *whiteString = attrString.mutableCopy;
        [whiteString addAttribute: NSForegroundColorAttributeName
                            value: [NSColor whiteColor]
                            range: NSMakeRange(0, whiteString.length) ];
        attrString = whiteString;
    }
    
    [attrString drawWithRect: [self titleRectForBounds:cellFrame]
                     options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin];
}
*/
- (NSRect)titleRectForBounds:(NSRect)theRect {
    /* get the standard text content rectangle */
    NSRect titleFrame = self.frame;//[super titleRectForBounds:theRect];
    
    /* find out how big the rendered text will be */
    NSAttributedString *attrString = self.attributedStringValue;
    NSRect textRect = [attrString boundingRectWithSize: titleFrame.size
                                               options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin ];
    
    /* If the height of the rendered text is less then the available height,
     * we modify the titleRect to center the text vertically */
    if (textRect.size.height < titleFrame.size.height) {
        titleFrame.origin.y = theRect.origin.y + (theRect.size.height - textRect.size.height) / 2.0;
        titleFrame.size.height = textRect.size.height;
    }
    return titleFrame;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
