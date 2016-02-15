//
// ASMessenger
//
// Copyright (c) 2015 Amit Sharma <amitsharma@mac.com>
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "ASTextInputView.h"

const static CGFloat kTextViewTopBottomMargin = 5;
const static CGFloat kGeneralVerticalMargin = 10;
const static CGFloat kSendButtonBottomMargin = 6;
const static CGFloat kAttachmentButtonBottomMargin = 12;

@interface ASTextInputView () <UITextViewDelegate>

@property (strong, nonatomic) UITextView *textView;
@property (strong, nonatomic) UIButton *sendButton;
@property (strong, nonatomic) UIButton *attachmentButton;
@property (strong, nonatomic) UIView *topBorderline;

@property (nonatomic) ASAttachmentButtonType attachmentButtonType;

@property (weak, nonatomic) id<ASTextInputViewDelegate> delegate;

@property (nonatomic) CGPoint panTouchDownPoint;
@property (nonatomic) CGFloat lastKnownTextViewContentHeight;
@property (nonatomic) BOOL firstTimeLayingOut;

@end

@implementation ASTextInputView

#pragma mark - Init

- (instancetype)initWithAttachmentButtonType:(ASAttachmentButtonType)attachmentButtonType delegate:(id<ASTextInputViewDelegate>)delegate{
    
    // text input view
    self = [super initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight]];
    self.firstTimeLayingOut = YES;
    self.delegate = delegate;
    self.topBorderline = [[UIView alloc] init];
    self.topBorderline.backgroundColor = [UIColor colorWithWhite:0.8f alpha:1.0];
    [self addSubview:self.topBorderline];
    
    // text view
    self.textView = [[UITextView alloc] init];
    self.textView.font = [UIFont fontWithName:@"Avenir-Medium" size:[self textViewFontSize]];
    self.textView.delegate = self;
    self.textView.backgroundColor = [UIColor whiteColor];
    self.textView.layer.cornerRadius = 5.0f;
    self.textView.layer.borderWidth = 0.5f;
    self.textView.layer.borderColor = [[UIColor colorWithWhite:0.8 alpha:1.0] CGColor];
    self.textView.layer.masksToBounds = YES;
    self.textView.scrollsToTop = NO;
    [self addSubview:self.textView];
    
    // send button
    self.sendButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.sendButton.titleLabel setFont:[UIFont systemFontOfSize:18.0f weight:0.3f]];
    [self.sendButton setTitle:@"Send" forState:UIControlStateNormal];
    [self.sendButton addTarget:self action:@selector(tellDelegateSendButtonPressedWithMessage) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.sendButton];
    
    // attachment button
    if (attachmentButtonType == ASAttachmentButtonTypePlus) {
        self.attachmentButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
        [self.attachmentButton addTarget:self action:@selector(tellDelegateAttachmentButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.attachmentButton];
    }
    
    [self setupSwipeToDismissPanRecognizer];
        
    return self;
}

#pragma mark - Pan Gesture Recognizer

-(void)setupSwipeToDismissPanRecognizer{
    
    UIPanGestureRecognizer *swipeToDismiss = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    [self addGestureRecognizer:swipeToDismiss];
}

-(void)handlePanGesture:(UIPanGestureRecognizer*)panRec{
    
    if (panRec.state == UIGestureRecognizerStateBegan) {
        
        _panTouchDownPoint = [panRec locationInView:self];
    }
    
    if (panRec.state == UIGestureRecognizerStateChanged) {
        
        if ([panRec locationInView:self].y > _panTouchDownPoint.y + 10) {
            [self resign];
        }
    }
}

#pragma mark - Text View Delegate

- (void)textViewDidChange:(UITextView *)textView{
    
    if (_lastKnownTextViewContentHeight == textView.contentSize.height) return;
    
    _lastKnownTextViewContentHeight = textView.contentSize.height;
    [_delegate heightRequiredToFitTextViewContentHasChanged];
}

#pragma mark - Layout Management

- (void)layoutSubviews{

    [super layoutSubviews];
    [self reframeAllSubviews];
}

- (CGFloat)heightToFitTextViewContentWithWidth:(CGFloat)width{
    
    return self.textView.contentSize.height + kTextViewTopBottomMargin * 2;
}

- (void)reframeAllSubviews{
    
    CGSize sendButtonSize = [_sendButton sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
    _sendButton.frame = CGRectMake(self.frame.size.width - kGeneralVerticalMargin - sendButtonSize.width,
                                   self.frame.size.height - kSendButtonBottomMargin - sendButtonSize.height,
                                   sendButtonSize.width,
                                   sendButtonSize.height);
    
    CGSize attachmentButtonSize;
    if (_attachmentButtonType != ASAttachmentButtonTypeNone) {
        
        attachmentButtonSize = [_attachmentButton sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
        _attachmentButton.frame = CGRectMake(kGeneralVerticalMargin,
                                       self.frame.size.height - kAttachmentButtonBottomMargin - attachmentButtonSize.height,
                                       attachmentButtonSize.width,
                                       attachmentButtonSize.height);
    }
    
    CGFloat textViewOriginX = (_attachmentButtonType != ASAttachmentButtonTypeNone) ? attachmentButtonSize.width + 2 * kGeneralVerticalMargin : kGeneralVerticalMargin;
    CGFloat textViewWidth = self.frame.size.width - kGeneralVerticalMargin * 3 - sendButtonSize.width;
    
    if (_attachmentButtonType != ASAttachmentButtonTypeNone) textViewWidth -= kGeneralVerticalMargin + attachmentButtonSize.width;
    _textView.frame = CGRectMake(textViewOriginX,
                                 kTextViewTopBottomMargin,
                                 textViewWidth,
                                 self.frame.size.height - kTextViewTopBottomMargin * 2);
    
    _topBorderline.frame = CGRectMake(0, 0, self.frame.size.width, 0.5f);
}

- (CGFloat)textViewFontSize{
    
    static CGFloat fontSize;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        fontSize = [UIFont preferredFontForTextStyle:UIFontTextStyleBody].pointSize;
    });

    return fontSize;
}

#pragma mark - Text Input View Delegate

- (void)tellDelegateSendButtonPressedWithMessage{
    
    if (_textView.text.length == 0) return;
    
    [_delegate passthroughSendButtonPressedWithMessage:_textView.text];
}

- (void)tellDelegateAttachmentButtonPressed{
    
    [_delegate passthroughAttachmentButtonPressed];
}

#pragma mark - Other

- (void)resign{
    
    [_textView resignFirstResponder];
}

- (BOOL)isFirstResponder{
    
    return [_textView isFirstResponder];
}

- (void)clearTextInputView{
    
    _textView.text = nil;
    [self textViewDidChange:_textView];
}

@end
