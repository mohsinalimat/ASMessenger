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

#import "ASMessageCell.h"
#import "ASBaseCell_PrivateExtension.h"
#import "ASEntry_SizingCacheExtension.h"

@interface ASMessageCell () <UITextViewDelegate>

@end

@implementation ASMessageCell

+ (NSDataDetector *)dataDetector{
    
        static NSDataDetector *dataDetector = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            
            dataDetector = [[NSDataDetector alloc] initWithTypes:NSTextCheckingAllTypes error:nil];
        });
    
        return dataDetector;
}

+ (CGSize)sizeForEntryContentViewWithEntry:(ASEntry *)entry maxWidth:(CGFloat)maxWidth{
    
    UITextView *textView = (UITextView *)[ASMessageCell generateEntryContentView];
    textView.text = entry.messageText;
    CGSize entryContentSize = [textView sizeThatFits:CGSizeMake(maxWidth, CGFLOAT_MAX)];
    
    NSInteger numberOfMatches = [[ASMessageCell dataDetector] numberOfMatchesInString:entry.messageText options:0 range:NSMakeRange(0, entry.messageText.length)];
    entry.needsDataDetection = (numberOfMatches > 0);

    return entryContentSize;
}

+ (UIView *)generateEntryContentView{
    
    static CGFloat fontSize;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        fontSize = [UIFont preferredFontForTextStyle:UIFontTextStyleBody].pointSize;
    });
    
    UITextView *messageLabel = [[UITextView alloc] init];
    
    messageLabel.backgroundColor = [UIColor redColor];
    messageLabel.editable = NO;
    messageLabel.selectable = YES;
    messageLabel.scrollEnabled = NO;
    messageLabel.dataDetectorTypes = UIDataDetectorTypeNone;
    messageLabel.linkTextAttributes = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)};
    messageLabel.textContainerInset = UIEdgeInsetsMake(5, 5, 5, 5);
    messageLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:fontSize];
    messageLabel.layer.masksToBounds = YES;
    messageLabel.layer.cornerRadius = kEntryContentViewCornerRadius;
    
    return messageLabel;
}

+ (CGFloat)minimumMarginFromContentToNonAlignedCellEdge{
    
    return 60.0f;
}

- (void)configureEntryViewWithEntry:(ASEntry *)entry{
    
    UITextView *textView = (UITextView *) self.entryContentView;
    
    if ([textView isKindOfClass:[UITextView class]]) {
        
        // disables data detection BEFORE text is assigned
        // leaving data detection enabled while setting the text would induce an expensive and unnecessary data detection pass
        if (!entry.needsDataDetection){
            textView.dataDetectorTypes = UIDataDetectorTypeNone;
            textView.text = entry.messageText;
        }
        
        // enables data detection AFTER text is assigned.
        // Since both setting the dataDetectorType and setting the text induces a data detection pass,
        // (cont.) enabling data detection last prevents an expensive and unnecessary double-pass.
        else{
            
            textView.text = entry.messageText;
            textView.dataDetectorTypes = UIDataDetectorTypeAll;
        }
        
        if (entry.backgroudColor) textView.backgroundColor = entry.backgroudColor;
        else  textView.backgroundColor = (entry.alignment == ASEntryAlignmentLeft) ? [UIColor colorWithWhite:0.9 alpha:1.0] : [UIColor colorWithRed:0.000 green:0.463 blue:1.000 alpha:1.00];
        
        if (entry.textColor) textView.textColor = entry.textColor;
        else  textView.textColor = (entry.alignment == ASEntryAlignmentLeft) ? [UIColor colorWithWhite:0.1 alpha:1.0] : [UIColor whiteColor];
        
        textView.linkTextAttributes = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),
                                        NSBackgroundColorAttributeName:textView.textColor};
    }
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deselectText) name:kDeselectMessageCellNotificationText object:nil];
    
    return self;
}

- (void)deselectText{
    
    UITextView *textView = (UITextView *)self.entryContentView;
    if (![textView isKindOfClass:[UITextView class]]) return;
    
    if (!textView.selectedTextRange.empty){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            textView.selectedTextRange = nil;
        });
    }
}

@end
