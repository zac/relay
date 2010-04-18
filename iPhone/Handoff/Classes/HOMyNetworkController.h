//
//  hoMyNetworkController.h
//  Handoff
//
//  Created by Haseman on 4/16/10.
//  Copyright 2010 Gravity Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLIP.h"

@protocol HOConnectionListener
-(void)gotDataPayload:(NSDictionary *)payload;
@end

@interface HOMyNetworkController : NSObject <
									TCPListenerDelegate,
									BLIPConnectionDelegate>
{
	id delegate;
	BLIPListener *_listener;
}

-(NSArray *)getAvailableDevices;
-(void)sendString:(NSString*)data;
-(void)sendData:(NSString*)data;
-(id)init;
-(void)processIncomingData: (NSData*)data: (NSString *)contentType;
- (NSString *)processOutgoingData: (NSDictionary *)data content:(NSString *)contentType;
-(NSObject *)getData:(NSString *)data: (NSString *)contentType;

@property (nonatomic, assign) id delegate;

@end
