//
//  LinedTextInputView.m
//  CrossoverNote
//
//  Created by Naveen Shan on 11/10/15.
//  Copyright © 2015 Crossover. All rights reserved.
//

#import "LinedTextInputView.h"

#import <CoreText/CoreText.h>

static UIFont *defaultFont = nil;

#pragma mark -

@interface TextPosition : UITextPosition

@property (nonatomic, assign) NSUInteger position;

@end

@implementation TextPosition

@end

#pragma mark -

@interface TextRange : UITextRange

@property (nonatomic, strong) TextPosition *startPosition;
@property (nonatomic, strong) TextPosition *endPosition;

- (NSRange)textRangeRange;
- (id)initWithStartPosition:(NSUInteger)start endPosition:(NSUInteger)end;

@end

@implementation TextRange

- (id)initWithStartPosition:(NSUInteger)start endPosition:(NSUInteger)end    {
    self = [super init];
    if(self)    {
        self.startPosition = [[TextPosition alloc] init];
        [self.startPosition setPosition:start];
        
        self.endPosition = [[TextPosition alloc] init];
        [self.endPosition setPosition:end];
    }
    return self;
}

- (NSRange)textRangeRange   {
    NSRange range;
    NSUInteger start = [self.startPosition position];
    NSUInteger end = [self.endPosition position];
    range.location = start;
    range.length = end - start;
    return range;
}

@end

#pragma mark -

@interface LinedTextInputView () <UITextInput, UITextInputTraits>

@property (nonatomic, strong) UIView *caretView;
@property (nonatomic, strong) NSString *textStore;
@property (nonatomic, assign) NSUInteger textCaretIndex;
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureReognizer;

@property (nonatomic, weak) id<UITextInputDelegate> textInputDelegate;
@property (nonatomic, strong) UITextInputStringTokenizer *inputTokenizer;

@property (nonatomic, assign) CTFrameRef frameRef;
@property (nonatomic, assign) CGContextRef contextRef;
@property (nonatomic, assign) CTFramesetterRef framesetterRef;
@property (nonatomic, strong) NSMutableAttributedString *attributedString;

@property (nonatomic, strong) TextRange *selectRange;

@end

@implementation LinedTextInputView

#pragma mark -

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupView];
    }
    return self;
}

#pragma mark -

- (void)setupView {
    self.textStore = @"";
    defaultFont = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    
    self.inputTokenizer = [[UITextInputStringTokenizer alloc] initWithTextInput:self];
    
    self.textCaretIndex = 0;
    self.caretView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 10)];
    self.caretView.backgroundColor = [UIColor blueColor];
    [self addSubview:self.caretView];
    
    self.tapGestureReognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapInView:)];
    [self addGestureRecognizer:self.tapGestureReognizer];
    [self addLongPressGestureForMenu];
}

- (void)sizeToFitText   {
    CGSize sizeForText = CTFramesetterSuggestFrameSizeWithConstraints(self.framesetterRef, CFRangeMake(0, 0), NULL, CGSizeMake(CGFLOAT_MAX,CGFLOAT_MAX), NULL);
    
    if([self.superview isKindOfClass:[UIScrollView class]]) {
        UIScrollView *contentView = (UIScrollView *)self.superview;
        [contentView setContentSize:CGSizeMake(self.bounds.size.width, sizeForText.height + 20.0f)];
        if (self.frame.size.height < sizeForText.height) {
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, sizeForText.height);
        }
    }
}

#pragma mark - Overrides

- (void)setFont:(UIFont *)font {
    _font = font;
    [self setNeedsDisplay];
}

- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    [self setNeedsDisplay];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    _backgroundColor = backgroundColor;
    [self setNeedsDisplay];
}

#pragma mark - UIKeyInput Methods

- (BOOL)hasText {
    return [self.textStore length] > 0;
}

- (void)insertText:(NSString *)text {
    // To insert text to the position where the caret resides
    NSString *beforeCaret = [self.textStore substringToIndex:self.textCaretIndex];
    NSString *afterCaret = [self.textStore substringFromIndex:self.textCaretIndex];
    
    self.textStore = [beforeCaret stringByAppendingString:text];
    self.textStore = [self.textStore stringByAppendingString:afterCaret];
    
    self.textCaretIndex++;
    
    [self setNeedsDisplay];
    [self sizeToFitText];
}

- (void)deleteBackward  {
    // To remove text to the position where the caret resides
    NSString *beforeCaret = [self.textStore substringToIndex:self.textCaretIndex];
    NSString *afterCaret = [self.textStore substringFromIndex:self.textCaretIndex];
    
    if ([beforeCaret length] > 0) {
        beforeCaret = [beforeCaret substringToIndex:[beforeCaret length] - 1];
        
        self.textStore = [beforeCaret stringByAppendingString:afterCaret];
        
        self.textCaretIndex--;
        
        [self setNeedsDisplay];
        [self sizeToFitText];
    }
}

#pragma mark - UIView Draw Methods

- (void)drawRect:(CGRect)rect    {
    [super drawRect:rect];
    
    [self drawText];
}

#pragma mark -

- (void)drawText {
    [self updateFramesetter];
    [self performTextDrawing];
}

- (void)updateFramesetter {
    self.attributedString = [[NSMutableAttributedString alloc] initWithString:self.textStore];
    
    NSRange range = NSMakeRange(0, self.textStore.length);
    UIFont *textFont = (self.font) ? self.font : defaultFont;
    UIColor *textColor = (self.textColor) ? self.textColor : [UIColor blackColor];
    
    [self.attributedString addAttribute:NSForegroundColorAttributeName value:textColor range:range];
    [self.attributedString addAttribute:NSFontAttributeName value:textFont range:range];
    
    CGFloat lineHeight = ceilf(textFont.pointSize) + 6.0;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.minimumLineHeight = lineHeight;
    paragraphStyle.maximumLineHeight = lineHeight;
    [self.attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
    
    if (self.backgroundColor) {
        [self.attributedString addAttribute:NSBackgroundColorAttributeName value:self.backgroundColor range:range];
    }
    
    TextRange *textRange = (TextRange *)[self selectedTextRange];
    if (textRange && self.attributedString.length > 0) {
        UIColor *selectedColor = [UIColor blueColor];
        NSRange selectedTextRange = NSMakeRange(textRange.startPosition.position, textRange.endPosition.position);
        [self.attributedString addAttribute:NSBackgroundColorAttributeName value:selectedColor range:selectedTextRange];
    }
    
    
    if (self.framesetterRef) {
        CFRelease(self.framesetterRef);
        self.framesetterRef = nil;
    }
    self.framesetterRef = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)self.attributedString);
}

- (void)performTextDrawing {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    
    // Set background color to white
    CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 1.0);
    CGContextFillRect(context, self.bounds);
    
    // Initialize a rectangular path.
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, self.bounds);
    if(self.frameRef)   {
        CFRelease(self.frameRef);
        self.frameRef = nil;
    }
    
    self.frameRef = CTFramesetterCreateFrame(self.framesetterRef, CFRangeMake(0, 0), path, NULL);
    
    [self.attributedString drawInRect:self.bounds];
    
    self.contextRef = context;
    CGContextRestoreGState(context);
    
    [self performLineDrawing];
    [self moveCaretToIndex:self.textCaretIndex];
}

- (void)performLineDrawing {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    CGContextSetStrokeColorWithColor(context, [UIColor lightGrayColor].CGColor);
    CGContextSetLineWidth(context, 1.0f);
    
    CGFloat boundsX = self.bounds.origin.x;
    CGFloat boundsWidth = self.bounds.size.width;
    
    UIFont *drawFont = (self.font) ? self.font : [UIFont systemFontOfSize:[UIFont systemFontSize]];
    CGFloat lineHeight = ceilf(drawFont.pointSize) + 6.0;
    NSInteger firstVisibleLine = 1;
    NSInteger lastVisibleLine = ceilf(self.bounds.size.height / drawFont.lineHeight);
    for (NSInteger line = firstVisibleLine; line <= lastVisibleLine; ++line)    {
        CGFloat linePointY = (line * lineHeight);
        CGContextMoveToPoint(context, boundsX, linePointY);
        CGContextAddLineToPoint(context, boundsWidth, linePointY);
    }
    CGContextClosePath(context);
    CGContextStrokePath(context);
}

#pragma mark - User Interaction

- (BOOL)canBecomeFirstResponder  {
    return YES;
}

- (void)tapInView:(id)sender {
    CGPoint tapLocation = [sender locationInView:self];
    TextPosition *closestPositionToPoint = (TextPosition*)[self closestPositionToPoint:tapLocation];
    
    [self moveCaretToIndex:[closestPositionToPoint position]];
    [self becomeFirstResponder];
}

#pragma mark - Caret Handlers

- (void)moveCaretToIndex:(NSUInteger)index {
    self.textCaretIndex = index;
    
    CGRect characterRect = [self rectForCharacterAtIndex:index];
    [self.caretView setFrame:characterRect];
}

- (CGRect)rectForCharacterAtIndex:(NSUInteger)index {
    @try {
        CTFontRef fontForText;
        CGFloat fontSizeForText;
        
        /*if (CFAttributedStringGetLength(self.attributedStringRef) > 0)  {*/
//            fontForText = CFAttributedStringGetAttribute(self.attributedStringRef, 0, kCTFontAttributeName, NULL);
        if (self.attributedString.length > 0)  {
            fontForText = CFAttributedStringGetAttribute((CFMutableAttributedStringRef)self.attributedString, 0, kCTFontAttributeName, NULL);

            fontSizeForText = CTFontGetSize(fontForText);
        } else    {
            CTFontRef fontRef = CTFontCreateWithName((CFStringRef)[defaultFont fontName], [defaultFont pointSize], NULL);

            fontForText = fontRef;
            fontSizeForText = [UIFont systemFontSize];
        }
        
        CGFloat caretViewWidth = 3.0f;
        NSUInteger indexLine = NSUIntegerMax;
        CFArrayRef lines = CTFrameGetLines(self.frameRef);
        if(CFArrayGetCount(lines) == 0) {
            return CGRectMake(0, 0, caretViewWidth, fontSizeForText);
        }
        
        CTLineRef currentLine = nil;
        CFRange lineStringRange;
        for(NSUInteger i = 0; i < CFArrayGetCount(lines); i++)  {
            currentLine = CFArrayGetValueAtIndex(lines, i);
            lineStringRange = CTLineGetStringRange(currentLine);
            
            if((index >= lineStringRange.location) &&
               (index <= lineStringRange.location + lineStringRange.length))    {
                // We found the right line!
                indexLine = i;
                break;
            }
        }
        
        if(indexLine == NSUIntegerMax)  {
            NSLog(@"Fail to find character index - %lu", (unsigned long)index);
            return CGRectZero;
        }
        
        CTLineRef lineAtCaret = CFArrayGetValueAtIndex(lines, indexLine);
        CFArrayRef runs = CTLineGetGlyphRuns(lineAtCaret);
        
        if(CFArrayGetCount(runs) < 1)   {
            NSLog(@"Fail to find line runs for character at index %lu", (unsigned long)index);
            return CGRectZero;
        }
        
        CTRunRef run = nil;
        CFRange runRange;
        NSUInteger runForCaretIndex = NSUIntegerMax;
        for(NSUInteger i = 0; i < CFArrayGetCount(runs); i++)   {
            run = CFArrayGetValueAtIndex(runs, i);
            runRange = CTRunGetStringRange(run);
            
            if((index >= runRange.location) &&
               (index <= runRange.location + runRange.length))  {
                runForCaretIndex = i;
                break;
            }
        }
        
        if(runForCaretIndex == NSUIntegerMax)   {
            NSLog(@"Fail to find line run for character at index %lu", (unsigned long)index);
            return CGRectZero;
        }
        
        CTRunRef runForCaret = CFArrayGetValueAtIndex(CTLineGetGlyphRuns(lineAtCaret), runForCaretIndex);
        CFRange caretRunStringRange = CTRunGetStringRange(runForCaret);
        
        NSUInteger indexOfGlyph = index - caretRunStringRange.location;
        
        CGPoint glyphPosition;
        CGPoint *lineOriginsForFrame;
        
        lineOriginsForFrame = calloc(CFArrayGetCount(lines), sizeof(CGPoint));
        CTFrameGetLineOrigins(self.frameRef, CFRangeMake(0,0), lineOriginsForFrame);
        
        CGPoint lineOrigin;
        lineOrigin = lineOriginsForFrame[indexLine];
        free(lineOriginsForFrame);
        
        if(caretRunStringRange.location + caretRunStringRange.length == [self.textStore length])    {
            
            if((char)[self.textStore characterAtIndex:index-1] == '\n') {
                CGFloat yCorrection = 6.0f;
                return CGRectMake(0, self.bounds.size.height - lineOrigin.y +yCorrection, caretViewWidth, fontSizeForText);
            }
            
            glyphPosition = CTRunGetPositionsPtr(runForCaret)[indexOfGlyph-1];
            if([self.textStore length] > 0) {
                double glyphWidth = CTRunGetTypographicBounds(runForCaret, CFRangeMake(0, 1), NULL, NULL, NULL);
                glyphPosition.x += glyphWidth;
            }
        }   else    {
            glyphPosition = CTRunGetPositionsPtr(runForCaret)[indexOfGlyph];
        }
        
        return CGRectMake(glyphPosition.x,  self.bounds.size.height - lineOrigin.y - fontSizeForText, caretViewWidth, fontSizeForText);
    }
    @catch (NSException *exception) {
        NSLog(@"Exception : %@",[exception description]);
    }
    @finally {
        
    }
}

#pragma mark - UITextInput Methods

- (UIView *)textInputView    {
    return self;
}

- (id<UITextInputTokenizer>)tokenizer    {
    return self.inputTokenizer;
}

- (UITextStorageDirection)selectionAffinity  {
    return UITextStorageDirectionForward;
}

- (void)setSelectionAffinity:(UITextStorageDirection)selectionAffinity   {
    // Todo - Not for now
}

- (UITextRange *)selectedTextRange   {
    return self.selectRange;
}

- (void)setSelectedTextRange:(UITextRange *)selectedTextRange    {
    self.selectRange = (TextRange *)selectedTextRange;
    [self setNeedsDisplay];
}

- (UITextRange *)markedTextRange    {
    return nil;
}

- (NSDictionary *)markedTextStyle   {
    return @{NSBackgroundColorAttributeName:[UIColor whiteColor],
             NSForegroundColorAttributeName:[UIColor blackColor],
             NSFontAttributeName:[UIFont systemFontOfSize:[UIFont systemFontSize]]
             };
}

- (id<UITextInputDelegate>)inputDelegate {
    return self.textInputDelegate;
}

- (void)setInputDelegate:(id<UITextInputDelegate>)inputDelegate {
    self.textInputDelegate = inputDelegate;
}

- (UITextPosition *)beginningOfDocument   {
    TextPosition* beginning = [[TextPosition alloc] init];
    [beginning setPosition:0];
    return beginning;
}

- (UITextPosition *)endOfDocument    {
    TextPosition *end = [[TextPosition alloc] init];
    [end setPosition:[self.textStore length]];
    return end;
}

- (NSString *)textInRange:(UITextRange *)range {
    NSRange stringRange = [(TextRange *)range textRangeRange];
    return [self.textStore substringWithRange:stringRange];
}

- (void)replaceRange:(UITextRange *)range withText:(NSString *)text    {
    NSRange stringRange = [(TextRange *)range textRangeRange];
    NSString *textToReplace = [self.textStore substringWithRange:stringRange];
    
    [textToReplace stringByReplacingOccurrencesOfString:textToReplace withString:text options:0 range:stringRange];
}

- (void)unmarkText   {
    
}

- (void)setMarkedText:(NSString *)markedText selectedRange:(NSRange)selectedRange {
    // Todo - Not for now
}

- (UITextRange *)textRangeFromPosition:(UITextPosition *)fromPosition toPosition:(UITextPosition *)toPosition   {
    NSUInteger from = [(TextPosition*)fromPosition position];
    NSUInteger to = [(TextPosition*)toPosition position];
    
    return [[TextRange alloc] initWithStartPosition:from endPosition:to];
}

- (UITextPosition *)positionFromPosition:(UITextPosition *)position offset:(NSInteger)offset    {
    NSUInteger from = [(TextPosition *)position position];
    TextPosition* shiftedPosition = [[TextPosition alloc] init];
    shiftedPosition.position = from + offset;
    
    return shiftedPosition;
}

- (UITextPosition *)positionFromPosition:(UITextPosition *)position inDirection:(UITextLayoutDirection)direction offset:(NSInteger)offset   {
    return [self positionFromPosition:position offset:offset];
}

- (NSInteger)offsetFromPosition:(UITextPosition *)from toPosition:(UITextPosition *)toPosition    {
    NSUInteger fromIndexPosition = [(TextPosition*)from position];
    NSUInteger toIndexPosition = [(TextPosition*)toPosition position];
    
    return toIndexPosition - fromIndexPosition;
}

- (UITextPosition *)positionWithinRange:(UITextRange *)range farthestInDirection:(UITextLayoutDirection)direction   {
    TextPosition* startPosition = (TextPosition*)[(TextRange*)range start];
    TextPosition* endPosition = (TextPosition*)[(TextRange*)range end];
    
    // If the layout direction is left or top, return the start position
    if((direction == UITextLayoutDirectionLeft) ||
       (direction == UITextLayoutDirectionDown))    {
        return startPosition;
    }
    
    // If not, return the end position
    return endPosition;
}

- (UITextRange *)characterRangeByExtendingPosition:(UITextPosition *)position inDirection:(UITextLayoutDirection)direction    {
    // If the layout direction is left or top, return to the start of the string
    if((direction == UITextLayoutDirectionLeft) ||
       (direction == UITextLayoutDirectionDown))    {
        return [[TextRange alloc] initWithStartPosition:0 endPosition:[(TextPosition*)position position]];
    }
    
    // If not, return from the position to the end of the string
    return [[TextRange alloc] initWithStartPosition:[(TextPosition*)position position] endPosition:[self.textStore length] - 1];
    
}

- (NSComparisonResult)comparePosition:(UITextPosition *)position toPosition:(UITextPosition *)other {
    NSUInteger from = [(TextPosition*)position position];
    NSUInteger to = [(TextPosition*)other position];
    
    NSInteger result = to - from;
    if(result > 0)  {
        return NSOrderedAscending;
    } else if(result < 0)   {
        return NSOrderedDescending;
    }
    return NSOrderedSame;
}

- (UITextWritingDirection)baseWritingDirectionForPosition:(UITextPosition *)position inDirection:(UITextStorageDirection)direction  {
    return UITextWritingDirectionLeftToRight;
}

- (void)setBaseWritingDirection:(UITextWritingDirection)writingDirection forRange:(UITextRange *)range   {
    // Todo - Not for now
}

- (CGRect)firstRectForRange:(UITextRange *)range  {
    return CGRectZero;
}

- (CGRect)caretRectForPosition:(UITextPosition *)position    {
    CGRect characterRect = [self rectForCharacterAtIndex:[(TextPosition*)position position]];
    characterRect.size = CGSizeMake(5, characterRect.size.height);
    return characterRect;
}

- (NSArray *)selectionRectsForRange:(UITextRange *)range {
    return nil;
}

- (UITextPosition *)closestPositionToPoint:(CGPoint)point   {
    return [self closestPositionToPoint:point withinRange:[[TextRange alloc] initWithStartPosition:0 endPosition:[self.textStore length] - 1]];
}

- (UITextPosition *)closestPositionToPoint:(CGPoint)point withinRange:(UITextRange*)range   {
    CTLineRef closestLineVerticallyToPoint = [self closestLineToPoint:point inRange:(TextRange *)range];
    
    CFIndex indexIntoString = CTLineGetStringIndexForPosition(closestLineVerticallyToPoint, point);
    if((indexIntoString > 0) && ((char)[self.textStore characterAtIndex:indexIntoString-1] == '\n'))    {
        indexIntoString--;
    }
    
    TextPosition* closestPosition = [[TextPosition alloc] init];
    if (indexIntoString < 0)
        [closestPosition setPosition:0];
    else
        [closestPosition setPosition:indexIntoString];
    
    return closestPosition;
}

- (UITextRange *)characterRangeAtPoint:(CGPoint)point   {
    CTLineRef closestLineVerticallyToPoint = [self closestLineToPoint:point inRange:[[TextRange alloc] initWithStartPosition:0 endPosition:[self.textStore length]]];
    
    // Now that we have the closest line vertically, find the index for the point
    CFIndex indexIntoString = CTLineGetStringIndexForPosition(closestLineVerticallyToPoint, point);
    TextRange* characterRangeAtPoint = [[TextRange alloc] initWithStartPosition:indexIntoString endPosition:indexIntoString+1];
    
    return characterRangeAtPoint;
}

- (CTLineRef)closestLineToPoint:(CGPoint)point inRange:(TextRange *)range   {
    
    CFArrayRef lines = CTFrameGetLines(self.frameRef);
    CGPoint lineOrigins[CFArrayGetCount(lines)];
    CTFrameGetLineOrigins(self.frameRef, CFRangeMake(0, 0), lineOrigins);
    
    NSRange characterRange = [(TextRange *)range textRangeRange];
    NSUInteger rangeStart = characterRange.location;
    NSUInteger rangeEnd = characterRange.location = characterRange.length;
    
    CTLineRef closestLineVerticallyToPoint = NULL;
    if(CFArrayGetCount(lines) < 1)  {
        return NULL;
    }
    
    CTLineRef currentLine = nil;
    for(NSUInteger i = 0; i < CFArrayGetCount(lines); i++)  {
        currentLine = CFArrayGetValueAtIndex(lines, i);
        
        CGPoint currentLineOriginCGCoords = lineOrigins[i];
        CGPoint currentLineOrigin = CGPointMake(currentLineOriginCGCoords.x, [self frame].size.height - currentLineOriginCGCoords.y);
        
        CFArrayRef runsForCurrentLine = CTLineGetGlyphRuns(currentLine);
        if(CFArrayGetCount(runsForCurrentLine) < 1) {
            NSLog(@"Fail to find runs for line");
            return NULL;
        }

        CTRunRef runForCurrentLine = CFArrayGetValueAtIndex(runsForCurrentLine, 0);
        CGRect runFrame = CTRunGetImageBounds(runForCurrentLine, self.contextRef, CFRangeMake(0, 0));
        currentLineOrigin.y-=runFrame.size.height;
        
        CFRange lineStringRange = CTLineGetStringRange(currentLine);
        NSUInteger lineRangeStart = lineStringRange.location;
        NSUInteger lineRangeEnd = lineStringRange.location = lineStringRange.length;
        if((lineRangeStart > rangeEnd) ||
           (lineRangeEnd - 1 > rangeEnd) ||
           (lineRangeEnd < rangeStart)) {
            continue;
        }
        
        if(currentLineOrigin.y < point.y)   {
            closestLineVerticallyToPoint = currentLine;
        }   else    {
            if(closestLineVerticallyToPoint != NULL) {
                break;
            }
        }
    }
    CFRetain(closestLineVerticallyToPoint);
    return closestLineVerticallyToPoint;
}

#pragma mark - UITextInputTraits Methods

- (BOOL)isSecureTextEntry    {
    return NO;
}

- (UIReturnKeyType)returnKeyType {
    return UIReturnKeyDefault;
}

- (UIKeyboardType)keyboardType   {
    return UIKeyboardTypeDefault;
}

- (BOOL)enablesReturnKeyAutomatically    {
    return YES;
}

- (UIKeyboardAppearance)keyboardAppearance   {
    return UIKeyboardAppearanceDefault;
}

- (UITextAutocorrectionType)autocorrectionType  {
    return UITextAutocorrectionTypeNo;
}

- (UITextAutocapitalizationType)autocapitalizationType  {
    return UITextAutocapitalizationTypeNone;
}

#pragma mark - UIMenuController Methods

- (void)addLongPressGestureForMenu {
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressOccured:)];
    [self addGestureRecognizer:longPressGesture];
}

- (void)longPressOccured:(UILongPressGestureRecognizer *) gestureRecognizer {
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        CGPoint location = [gestureRecognizer locationInView:[gestureRecognizer view]];
        UIMenuController *menuController = [UIMenuController sharedMenuController];
        UIMenuItem *fontMenuItem = [[UIMenuItem alloc] initWithTitle:@"Font" action:@selector(selectFont:)];
        UIMenuItem *colorMenuItem = [[UIMenuItem alloc] initWithTitle:@"Color" action:@selector(selectColor:)];
        UIMenuItem *sizeMenuItem = [[UIMenuItem alloc] initWithTitle:@"Size" action:@selector(selectSize:)];
        UIMenuItem *backgroundMenuItem = [[UIMenuItem alloc] initWithTitle:@"Background" action:@selector(selectBackground:)];
        UIMenuItem *removeMenuItem = [[UIMenuItem alloc] initWithTitle:@"Remove" action:@selector(removeSelection:)];
        
        if ([self selectedTextRange]) {
            [menuController setMenuItems:[NSArray arrayWithObjects:removeMenuItem,fontMenuItem,colorMenuItem,sizeMenuItem,backgroundMenuItem,nil]];
        } else {
            [menuController setMenuItems:[NSArray arrayWithObjects:fontMenuItem,colorMenuItem,sizeMenuItem,backgroundMenuItem,nil]];
        }
        
        [menuController setTargetRect:CGRectMake(location.x, location.y, 0.0f, 0.0f) inView:[gestureRecognizer view]];
        [menuController setMenuVisible:YES animated:YES];
    }
}

- (BOOL)canPerformAction:(SEL)selector withSender:(id) sender {
    BOOL canPerform = NO;
    BOOL isTextSelected = [self selectedTextRange];
    if (isTextSelected) {
        if (selector == @selector(selectFont:) ||
            selector == @selector(selectColor:) ||
            selector == @selector(selectSize:) ||
            selector == @selector(selectBackground:) ||
            selector == @selector(removeSelection:) ||
            selector == @selector(copy:) ||
            selector == @selector(cut:) ||
            selector == @selector(paste:) ) {
            canPerform = YES;
        }
    } else {
        if (selector == @selector(selectFont:) ||
            selector == @selector(selectColor:) ||
            selector == @selector(selectSize:) ||
            selector == @selector(selectBackground:) ||
            selector == @selector(selectAll:) ) {
            canPerform = YES;
        }
    }
    
    return canPerform;
}

- (void)selectFont:(id) sender {
    if (self.fontCallback) {
        self.fontCallback();
    }
}

- (void)selectColor:(id) sender {
    if (self.colorCallback) {
        self.colorCallback();
    }
}

- (void)selectSize:(id) sender {
    if (self.sizeCallback) {
        self.sizeCallback();
    }
}

- (void)selectBackground:(id) sender {
    if (self.backgroundColorCallback) {
        self.backgroundColorCallback();
    }
}

- (void)cut:(id) sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.textStore;
    self.textStore = @"";
    self.textCaretIndex = 0;
    [self setNeedsDisplay];
}

- (void)copy:(id) sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.textStore;
}

- (void)paste:(id)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    NSString *string = pasteboard.string;
    [self insertText:string];
    [self setSelectedTextRange:nil];
}

- (void)selectAll:(id) sender {
    TextRange *range = (self.textStore.length > 0) ? [[TextRange alloc] initWithStartPosition:0 endPosition:self.textStore.length] : nil;
    [self setSelectedTextRange:range];
}

- (void)removeSelection:(id) sender {
    [self setSelectedTextRange:nil];
}

@end
