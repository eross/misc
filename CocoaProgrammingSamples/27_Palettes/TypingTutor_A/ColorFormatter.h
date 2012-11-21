//
//  ColorFormatter.h
//  TypingTutor
//
//  Created by student on Wed Sep 17 2003.
//  Copyright (c) 2003 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@class NSColorList;

@interface ColorFormatter : NSFormatter {
    NSColorList *colorList;
}
- (NSString *)firstColorKeyForPartialString:(NSString *)string;
@end
