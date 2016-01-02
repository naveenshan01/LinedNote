//
//  UIView+UIViewGeometryAdditions.m
//  LinedNote
//
//  Created by Naveen Shan on 11/10/15.
//  Copyright © 2015 LinedNote All rights reserved.
//


#import "UIView+UIViewGeometryAdditions.h"

@implementation UIView (UIViewGeometryAdditions)

#pragma mark - Frame adjustment helpers

- (void)moveUpBy:(CGFloat)value {
    CGRect frame = self.frame;
    frame.origin.y -= value;
    self.frame = frame;
}

- (void)moveDownBy:(CGFloat)value {
    CGRect frame = self.frame;
    frame.origin.y += value;
    self.frame = frame;
}

- (void)increaseWidthBy:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width += width;
    self.frame = frame;
}

- (void)decreaseWidthBy:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width -= width;
    self.frame = frame;
}

- (void)increaseHeightBy:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height += height;
    self.frame = frame;
}

- (void)decreaseHeightBy:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height -= height;
    self.frame = frame;
}

#pragma mark -

- (void)centralizeInParent {
    UIView *superview = self.superview;
    self.center = CGPointMake(superview.center.x - superview.frame.origin.x, superview.center.y - superview.frame.origin.y);
//    self.center = CGPointMake(superview.width / 2, superview.height / 2);
}

- (void)centralizeVerticallyInParent {
    UIView *superview = self.superview;
    self.center = CGPointMake(self.center.x, superview.center.y - superview.frame.origin.y);
}

- (void)centralizeHorizontallyInParent {
    UIView *superview = self.superview;
    self.center = CGPointMake(superview.center.x - superview.frame.origin.x, self.center.y);
}

// Adjust the height to extend up to the last row of its largest child
- (void)adjustHeightToFit {
    CGFloat maxHeight = 0;

    for (UIView *view in self.subviews) {
        maxHeight = fmaxf(maxHeight, CGRectGetMaxY(view.frame));
    }

    [self setHeight:maxHeight];
}

#pragma mark -

- (CGFloat)x {
    return self.frame.origin.x;
}

- (void)setX:(CGFloat)x {
    self.frame = (CGRect) {.origin.x=x, .origin.y=self.frame.origin.y, .size=self.frame.size};
}

- (CGFloat)y {
    return self.frame.origin.y;
}

- (void)setY:(CGFloat)y {
    self.frame = (CGRect) {.origin.x=self.frame.origin.x, .origin.y=y, .size=self.frame.size};
}

- (CGFloat)width {
    return self.bounds.size.width;
}

- (void)setWidth:(CGFloat)width {
    self.frame = (CGRect) {.origin=self.frame.origin, .size.width=width, .size.height=self.frame.size.height};
}

- (CGFloat)height {
    return self.bounds.size.height;
}

- (void)setHeight:(CGFloat)height {
    self.frame = (CGRect) {.origin=self.frame.origin, .size.width=self.frame.size.width, .size.height=height};
}

- (CGFloat)left {
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)left {
    self.frame = (CGRect) {.origin.x=left, .origin.y=self.frame.origin.y, .size.width=fmaxf(self.frame.origin.x + self.frame.size.width - left, 0), .size.height=self.frame.size.height};
}

- (CGFloat)top {
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)top {
    self.frame = (CGRect) {.origin.x=self.frame.origin.x, .origin.y=top, .size.width=self.frame.size.width, .size.height=fmaxf(self.frame.origin.y + self.frame.size.height - top, 0)};
}

- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)right {
    self.frame = (CGRect) {.origin=self.frame.origin, .size.width=fmaxf(right - self.frame.origin.x, 0), .size.height=self.frame.size.height};
}

- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)bottom {
    self.frame = (CGRect) {.origin=self.frame.origin, .size.width=self.frame.size.width, .size.height=fmaxf(bottom - self.frame.origin.y, 0)};
}

#pragma mark -

- (CGPoint)origin {
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin {
    self.frame = (CGRect) {.origin=origin, .size=self.frame.size};
}

- (CGSize)size {
    return self.frame.size;
}

- (void)setSize:(CGSize)size {
    self.frame = (CGRect) {.origin=self.frame.origin, .size=size};
}

@end


