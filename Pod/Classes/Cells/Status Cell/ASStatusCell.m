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

#import "ASStatusCell.h"
#import "ASEntry_SizingCacheExtension.h"

const static CGFloat kHorizontalMarginTop = 8.0f;
const static CGFloat kHorizontalMarginBottom = 2.0f;
const static CGFloat kVerticalMargin = 3.0f;

@interface ASStatusCell ()

@property (strong, nonatomic) UILabel *statusLabel;
@property (strong, nonatomic) ASEntry *entry;

@end

@implementation ASStatusCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    self.statusLabel = [ASStatusCell generateStatusLabel];
    [self addSubview:self.statusLabel];
    
    return self;
}

- (void)prepareWithEntry:(ASEntry*)entry{
    
    _entry = entry;
    _statusLabel.textColor = entry.backgroudColor ? entry.backgroudColor : [UIColor lightGrayColor];
    _statusLabel.text = entry.statusMessage;
}

- (void)layoutSubviews{
    
    _statusLabel.frame = CGRectMake((self.frame.size.width - _entry.entryContentSize.width) / 2,
                                    kHorizontalMarginTop,
                                    _entry.entryContentSize.width,
                                    _entry.entryContentSize.height);
    
}

+ (void)calculateAndAssignCellFramingValuesForEntry:(ASEntry *)entry withCellWidth:(CGFloat)cellWidth{
    
    UILabel *statusLabel = [ASStatusCell generateStatusLabel];
    statusLabel.text = entry.statusMessage;
    CGSize contentSize = [statusLabel sizeThatFits:CGSizeMake(cellWidth - kVerticalMargin * 2, CGFLOAT_MAX)];
    
    entry.cellHeight = contentSize.height + kHorizontalMarginTop + kHorizontalMarginBottom;
    entry.entryContentSize = contentSize;
}

+ (UILabel *)generateStatusLabel{
    
    static CGFloat fontSize;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        fontSize = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote].pointSize;
    });
    
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor darkGrayColor];
    label.font = [UIFont fontWithName:@"Avenir-Heavy" size:fontSize];
    label.textAlignment = NSTextAlignmentCenter;
    
    return label;
}

@end
