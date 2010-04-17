//
//  Base64.h
//  Handoff
//
//  Created by Barry Burton on 4/17/10.
//  Copyright 2010 Gravity Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Base64 : NSObject {

}

+ (void) initialize;

+ (NSString*) encode:(const uint8_t*) input length:(NSInteger) length;

+ (NSString*) encode:(NSData*) rawBytes;

+ (NSData*) decode:(const char*) string length:(NSInteger) inputLength;

+ (NSData*) decode:(NSString*) string;

@end
