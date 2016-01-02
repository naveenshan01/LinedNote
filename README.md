# LinedNote
iOS lined note textview. It's a quick start for those who plan to create a lined note in iOS. It uses block based call back for menu actions in note.

![alt LinedNote.png](https://github.com/naveenshan01/LinedNote/blob/master/LinedNote_Screen.png)

To integrate,
```
    self.textContentView = [[UIScrollView alloc] init];
    [self.view addSubview:self.textContentView];
    
    self.textInputView = [[LinedTextInputView alloc] init];
    self.textInputView.layer.masksToBounds = YES;
    self.textInputView.layer.borderWidth = 1.0;
    self.textInputView.layer.borderColor = [UIColor grayColor].CGColor;
    [self.textContentView addSubview:self.textInputView];
    
    __weak TextNoteViewController *weakSelf = self;
    [self.textInputView setFontCallback:^{
        // Show Font Select option
    }];
    [self.textInputView setColorCallback:^{
        // Show Color Select option
    }];
    [self.textInputView setSizeCallback:^{
        // Show Size Select option
    }];
    [self.textInputView setBackgroundColorCallback:^{
        // Show Background Select option
    }];
    
    [self.textInputView becomeFirstResponder];
```

Checkout the sample project for more details.
