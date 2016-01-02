//
//  UIView+UIViewGeometryAdditions.h
//  LinedNote
//
//  Created by Naveen Shan on 11/10/15.
//  Copyright © 2015 LinedNote All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (UIViewGeometryAdditions)

- (void)moveUpBy:(CGFloat)value;
- (void)moveDownBy:(CGFloat)value;

- (void)increaseWidthBy:(CGFloat)width;
- (void)decreaseWidthBy:(CGFloat)width;

- (void)increaseHeightBy:(CGFloat)height;
- (void)decreaseHeightBy:(CGFloat)height;

- (CGFloat)x;
- (void)setX:(CGFloat)x;
- (CGFloat)y;
- (void)setY:(CGFloat)y;

- (CGFloat)width;
- (void)setWidth:(CGFloat)width;
- (CGFloat)height;
- (void)setHeight:(CGFloat)height;

- (CGFloat)left;
- (void)setLeft:(CGFloat)left;
- (CGFloat)top;
- (void)setTop:(CGFloat)top;
- (CGFloat)right;
- (void)setRight:(CGFloat)right;
- (CGFloat)bottom;
- (void)setBottom:(CGFloat)bottom;

- (CGPoint)origin;
- (void)setOrigin:(CGPoint)origin;
- (CGSize)size;
- (void)setSize:(CGSize)size;

- (void)centralizeInParent;
- (void)centralizeVerticallyInParent;
- (void)centralizeHorizontallyInParent;

- (void)adjustHeightToFit;

@end
