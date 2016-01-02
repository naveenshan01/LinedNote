//
//  BaseTableViewController.m
//  LinedNote
//
//  Created by Naveen Shan on 11/10/15.
//  Copyright © 2015 LinedNote All rights reserved.
//

#import "BaseTableViewController.h"

@interface BaseTableViewController ()

@end

@implementation BaseTableViewController

#pragma mark - View Lifecycles

- (void)loadSubViews {
    [super loadSubViews];
    
    self.tableView = [[UITableView alloc]
                      initWithFrame:self.view.bounds
                      style:[self styleForTableView]];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;

    
    [self clearHeaderView];
    [self clearFooterView];
    
    [self.view addSubview:self.tableView];
}

#pragma mark - Table view customization - Override to customize

- (UITableViewStyle)styleForTableView {
    return UITableViewStylePlain;
}

- (void)clearFooterView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    view.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = view;
}

- (void)clearHeaderView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    view.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = view;
}

#pragma mark - View Layouts

- (void)layoutSubViews {
    [super layoutSubViews];
    self.tableView.frame = self.view.bounds;
}

#pragma mark - View Methods

- (void)reloadData {
    [super reloadData];
    
    [self.tableView reloadData];
}

#pragma mark - UITableView Data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}


@end
