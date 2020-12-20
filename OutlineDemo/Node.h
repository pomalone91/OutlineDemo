//
//  Node.h
//  OutlineDemo
//
//  Created by Paul Malone on 12/19/20.
//  Copyright © 2020 Paul Malone. All rights reserved.
//

#ifndef Node_h
#define Node_h
#import <Cocoa/Cocoa.h>

#endif /* Node_h */

@interface Node : NSObject

#pragma mark - Properties
@property (nonatomic) NSString *relativePath;
@property Node *parent;
@property (nonatomic) NSMutableArray *children;

#pragma mark - Initializers
- (id)init;
- (id)initWithPath:(NSString*)value parent:(Node *) children;
- (id)initWithRootItem:(NSString*)rootPath;

#pragma mark - Public Methods
- (NSString *)fullPath;
- (NSString *)relativePath;
- (Node *)childAtIndex:(NSInteger)index;
- (NSInteger)numberOfChildren;

@end
