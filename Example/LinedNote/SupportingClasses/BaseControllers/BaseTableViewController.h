//
//  BaseTableViewController.h
//  LinedNote
//
//  Created by Naveen Shan on 11/10/15.
//  Copyright © 2015 LinedNote All rights reserved.
//

#import "BaseViewController.h"

@interface BaseTableViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end
