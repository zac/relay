//
//  HOAppInfo.h
//  Handoff
//
//  Created by Daniel DeCovnick on 4/17/10.
//  Copyright 2010 Softyards Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class HOItem;
extern NSString *const kDraggedAppName;
extern NSString *const kDraggedAppIdentifier;
@interface HOAppInfo : NSObject {

}
+(HOItem *)draggedAppInfo;
@end
