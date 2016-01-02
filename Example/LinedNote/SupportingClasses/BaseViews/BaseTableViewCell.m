//
//  BaseTableViewCell.m
//  LinedNote
//
//  Created by Naveen Shan on 11/10/15.
//  Copyright © 2015 LinedNote All rights reserved.
//

#import "BaseTableViewCell.h"

@implementation BaseTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initView];
        [self loadSubViews];
    }
    return self;
}

#pragma mark - View Lifecycles

- (void)initView {
    
}

- (void)loadSubViews {
    
}

#pragma mark - View Layouts

- (void)layoutSubViews {
    [super layoutSubviews];
}

@end
