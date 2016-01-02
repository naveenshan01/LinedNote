//
//  BaseViewController.m
//  LinedNote
//
//  Created by Naveen Shan on 11/10/15.
//  Copyright © 2015 LinedNote All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        [self performSelector:@selector(initView)];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self performSelector:@selector(loadSubViews)];
    [self performSelector:@selector(loadData)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self performSelector:@selector(reloadData)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    [self layoutSubViews];
}

#pragma mark - View Lifecycles

- (void)initView {
    
}

- (void)loadSubViews {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
}

- (void)layoutSubViews {
    
}

- (void)loadData {
    
}

- (void)reloadData {
    
}

@end
