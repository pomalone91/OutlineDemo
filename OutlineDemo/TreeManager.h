//
//  TreeManager.h
//  OutlineDemo
//
//  Created by Paul Malone on 12/19/20.
//  Copyright © 2020 Paul Malone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Node.h"

#ifndef TreeManager_h
#define TreeManager_h

@interface TreeManager : NSObject

// Properties
@property NSMutableArray *nodes;

// Method API

// Add a new entry to the tree
- (id)initWithDirectory:(NSString*)rootPath;

@end


#endif /* TreeManager_h */
