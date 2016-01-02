//
//  TextNoteViewController.m
//  LinedNote
//
//  Created by Naveen Shan on 11/10/15.
//  Copyright © 2015 LinedNote All rights reserved.
//

#import "TextNoteViewController.h"

#import "LinedTextInputView.h"

@interface TextNoteViewController ()

@property (nonatomic, strong) UIScrollView *textContentView;
@property (nonatomic, strong) LinedTextInputView *textInputView;

@end

@implementation TextNoteViewController

#pragma mark - View Lifecycles

- (void)initView {
    [super initView];
    
    self.title = @"Notes";
    self.viewModel = [[TextNoteViewModel alloc] init];
    self.inputModel = [[TextNoteInputModel alloc] init];
}

- (void)loadSubViews {
    [super loadSubViews];
    
    self.textContentView = [[UIScrollView alloc] init];
    [self.view addSubview:self.textContentView];
    
    self.textInputView = [[LinedTextInputView alloc] init];
    self.textInputView.layer.masksToBounds = YES;
    self.textInputView.layer.borderWidth = 1.0;
    self.textInputView.layer.borderColor = [UIColor grayColor].CGColor;
    [self.textContentView addSubview:self.textInputView];
    
    __weak TextNoteViewController *weakSelf = self;
    [self.textInputView setFontCallback:^{
        [weakSelf showFontSelectAlert];
    }];
    [self.textInputView setColorCallback:^{
        [weakSelf showColorSelectAlert];
    }];
    [self.textInputView setSizeCallback:^{
        [weakSelf showSizeAlert];
    }];
    [self.textInputView setBackgroundColorCallback:^{
        [weakSelf showBackgroundColorSelectAlert];
    }];
    
    [self.textInputView becomeFirstResponder];
}

#pragma mark - View Layouts

- (void)layoutSubViews {
    [super layoutSubViews];
    
    self.textContentView.frame = CGRectMake(40, 40, self.view.width - 80.0f, self.view.height - 120.0f);
    self.textInputView.frame = CGRectMake(0, 0, self.textContentView.width,self.textContentView.height);
}

#pragma mark - 

- (void)showFontSelectAlert {
    // Todo : Need to create a common class for Alert Handling.
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Select Font :" message:nil preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *arialFont = [UIAlertAction actionWithTitle:@"Arial" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [self.textInputView setFont:[UIFont fontWithName:@"Arial" size:14.0]];
    }];
    [alert addAction:arialFont];
    
    UIAlertAction *courierFont = [UIAlertAction actionWithTitle:@"Courier" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [self.textInputView setFont:[UIFont fontWithName:@"Courier" size:14.0]];
    }];
    [alert addAction:courierFont];
    
    UIAlertAction *helveticaFont = [UIAlertAction actionWithTitle:@"HelveticaNeue" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [self.textInputView setFont:[UIFont fontWithName:@"HelveticaNeue" size:14.0]];
    }];
    [alert addAction:helveticaFont];

    [self presentViewController:alert animated:YES completion:nil];
}

- (void)showColorSelectAlert {
    // Todo : Need to create a common class for Alert Handling.
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Select Color :" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *blueColor = [UIAlertAction actionWithTitle:@"Blue" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [self.textInputView setTextColor:[UIColor blueColor]];
    }];
    [alert addAction:blueColor];
    
    UIAlertAction *greenColor = [UIAlertAction actionWithTitle:@"Green" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [self.textInputView setTextColor:[UIColor greenColor]];
    }];
    [alert addAction:greenColor];
    
    UIAlertAction *redColor = [UIAlertAction actionWithTitle:@"Red" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [self.textInputView setTextColor:[UIColor redColor]];
    }];
    [alert addAction:redColor];
    
    UIAlertAction *blackColor = [UIAlertAction actionWithTitle:@"Black" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [self.textInputView setTextColor:[UIColor blackColor]];
    }];
    [alert addAction:blackColor];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)showSizeAlert {
    // Todo : Need to create a common class for Alert Handling.
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Select Font Size :" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *firstFont = [UIAlertAction actionWithTitle:@"14.0" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [self.textInputView setFont:[self.textInputView.font  fontWithSize:14.0]];
    }];
    [alert addAction:firstFont];
    
    UIAlertAction *secondFont = [UIAlertAction actionWithTitle:@"18.0" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [self.textInputView setFont:[self.textInputView.font  fontWithSize:18.0]];
    }];
    [alert addAction:secondFont];
    
    UIAlertAction *thirdFont = [UIAlertAction actionWithTitle:@"22.0" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [self.textInputView setFont:[self.textInputView.font  fontWithSize:22.0]];
    }];
    [alert addAction:thirdFont];
    
    UIAlertAction *forthFont = [UIAlertAction actionWithTitle:@"25.0" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [self.textInputView setFont:[self.textInputView.font  fontWithSize:25.0]];
    }];
    [alert addAction:forthFont];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)showBackgroundColorSelectAlert {
    // Todo : Need to create a common class for Alert Handling.
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Select Background Color :" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *blueColor = [UIAlertAction actionWithTitle:@"Blue" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [self.textInputView setBackgroundColor:[UIColor blueColor]];
    }];
    [alert addAction:blueColor];
    
    UIAlertAction *greenColor = [UIAlertAction actionWithTitle:@"Green" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [self.textInputView setBackgroundColor:[UIColor greenColor]];
    }];
    [alert addAction:greenColor];
    
    UIAlertAction *redColor = [UIAlertAction actionWithTitle:@"Red" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [self.textInputView setBackgroundColor:[UIColor redColor]];
    }];
    [alert addAction:redColor];
    
    UIAlertAction *blackColor = [UIAlertAction actionWithTitle:@"Clear" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [self.textInputView setBackgroundColor:nil];
    }];
    [alert addAction:blackColor];
    
    [self presentViewController:alert animated:YES completion:nil];
}

@end
