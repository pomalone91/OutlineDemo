//
//  ViewController.h
//  OutlineDemo
//
//  Created by Paul Malone on 12/19/20.
//  Copyright © 2020 Paul Malone. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "TreeManager.h"

@interface ViewController : NSViewController <NSOutlineViewDataSource, NSOutlineViewDelegate>
@property (strong) IBOutlet NSOutlineView *outlineView;
@property TreeManager *treeManager;


@end

