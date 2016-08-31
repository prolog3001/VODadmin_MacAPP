//
//  CustomFontButton.m
//  nextTo
//
//  Created by Gilad Kedmi on 1/14/15.
//  Copyright (c) 2015 Gphone. All rights reserved.
//

#import "CustomFontButton.h"
#import "MiscFunc.h"

@implementation CustomFontButton

- (void)awakeFromNib {
    [super awakeFromNib];
    //self.font = [UIFont fontWithName:@"OpenSans-Bold" size:self.font.pointSize];
    //self.titleLabel.font = [NSFont fontWithName:[MiscFunc fontWithIndex:(int)self.tag] size:self.titleLabel.font.pointSize];
    
    [self setFont:[NSFont fontWithName:[MiscFunc fontWithIndex:(int)self.tag] size:self.font.pointSize]];
    //self.font = [UIFont fontWithName:[MiscFunc fontWithIndex:(int)self.tag] size:self.font.pointSize];
    //DLog(@"self.font.pointSize = %2f",self.font.pointSize);
}
- (NSColor *)titleColor
{
    NSColor *l_textColor = [NSColor controlTextColor];
    
    NSAttributedString *l_attributedTitle = [self attributedTitle];
    NSUInteger l_len = [l_attributedTitle length];
    
    if (l_len)
    {
        NSDictionary *l_attrs = [l_attributedTitle fontAttributesInRange:NSMakeRange(0, 1)];
        
        if (l_attrs)
        {
            l_textColor = [l_attrs objectForKey:NSForegroundColorAttributeName];
        }
    }
    
    return l_textColor;
}

- (void) setTitleColor:(NSColor *)a_textColor
{
    NSMutableAttributedString *l_attributedTitle = [[NSMutableAttributedString alloc]
                                                    initWithAttributedString:[self attributedTitle]];
    NSUInteger l_len = [l_attributedTitle length];
    NSRange l_range = NSMakeRange(0, l_len);
    [l_attributedTitle addAttribute:NSForegroundColorAttributeName
                              value:a_textColor
                              range:l_range];
    [l_attributedTitle fixAttributesInRange:l_range];
    
    [self setAttributedTitle:l_attributedTitle];
    
#if !__has_feature(objc_arc)
    [l_attributedTitle release];
#endif
}
/*
- (void)mouseDown:(NSEvent *)theEvent{
    //Do nothing to not propagate the click event to descendant views
}
 */
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
