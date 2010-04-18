//
//  HONetwork.h
//  Handoff
//
//  Created by Barry Burton on 4/17/10.
//  Copyright 2010 Gravity Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLIPConnection.h"

@protocol HONetworkDelegate

- (void) messageReceived:(NSString*)message;

@end


@interface HONetwork : NSObject <TCPListenerDelegate, BLIPConnectionDelegate> {

	NSString *string;
	
    BLIPListener *_listener;
	
	id <HONetworkDelegate> delegate;
}

@property (nonatomic, copy) NSString *string;

@property (nonatomic, retain) id <HONetworkDelegate> delegate;

- (id) initWithDelegate:(id <HONetworkDelegate>)delegate;

- (BOOL) sendMessage:(NSString*)message;

@end
