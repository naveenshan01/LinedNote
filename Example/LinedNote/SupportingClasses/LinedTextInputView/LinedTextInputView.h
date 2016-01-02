//
//  LinedTextInputView.h
//  LinedNote
//
//  Created by Naveen Shan on 11/10/15.
//  Copyright © 2015 LinedNote All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^FontSelectCallback)();
typedef void(^SizeSelectCallback)();
typedef void(^ColorSelectCallback)();
typedef void(^BackgroundColorSelectCallback)();

@interface LinedTextInputView : UIView

@property(nullable, nonatomic,strong) UIFont *font;
@property(nullable, nonatomic,strong) UIColor *textColor;
@property(nullable, nonatomic,strong) UIColor *backgroundColor;

@property (nullable, nonatomic, copy) FontSelectCallback fontCallback;
@property (nullable, nonatomic, copy) SizeSelectCallback sizeCallback;
@property (nullable, nonatomic, copy) ColorSelectCallback colorCallback;
@property (nullable, nonatomic, copy) BackgroundColorSelectCallback backgroundColorCallback;

@end
