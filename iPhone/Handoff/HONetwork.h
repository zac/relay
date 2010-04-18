//
//  HONetwork.h
//  Handoff
//
//  Created by Barry Burton on 4/17/10.
//  Copyright 2010 Gravity Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLIPConnection.h"

@interface HONetwork : NSObject <TCPListenerDelegate, BLIPConnectionDelegate> {

	NSString *string;
    BLIPListener *_listener;
}

@property (nonatomic, copy) NSString *string;

- (void)updateString;

@end
