//
//  BaseViewController.h
//  LinedNote
//
//  Created by Naveen Shan on 11/10/15.
//  Copyright © 2015 LinedNote All rights reserved.
//

#import "UIKitExtentions.h"

@interface BaseViewController : UIViewController

- (void)initView;

- (void)loadSubViews;
- (void)layoutSubViews;

- (void)loadData;
- (void)reloadData;

@end
