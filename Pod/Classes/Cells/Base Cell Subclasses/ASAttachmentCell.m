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

#import "ASAttachmentCell.h"
#import "ASBaseCell_PrivateExtension.h"
#import "ASEntry_SizingCacheExtension.h"
#import "NSBundle+ASMessengerBundle.h"

#pragma mark - ASAttachmentView

const static CGFloat kAttachmentViewHorizontalMargins = 5.0f;
const static CGFloat kAttachmentViewVerticalMargins = 8.0f;
const static CGFloat kAttachmentViewSpaceBetweenLabels = 0.0f;
const static CGFloat kAttachmentViewMinimumHeight = 45.0f;

static NSString * kDetailImageName = @"detail_arrow";
const static CGFloat kDetailIconWidth = 25.0f;
const static CGFloat kDetailIconHeight = 30.0f;

@interface ASAttachmentView : UIView

@property (strong, nonatomic) UILabel *attachmentTitleLabel;
@property (strong, nonatomic) UILabel *attachmentSubtitleLabel;
@property (strong, nonatomic) UIImageView *detailIcon;

+ (CGSize)determineAndCacheAttachmentViewSizeForEntry:(ASEntry *)entry maxWidth:(CGFloat)maxWidth;
- (void)reframeAllSubviewsWithEntry:(ASEntry *)entry;

@end

@implementation ASAttachmentView

- (instancetype)init{
    
    self = [super init];
    self.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    
    self.attachmentTitleLabel = [[UILabel alloc] init];
    self.attachmentTitleLabel.font = [ASAttachmentView titleFont];
    [self addSubview:_attachmentTitleLabel];
    
    self.attachmentSubtitleLabel = [[UILabel alloc] init];
    self.attachmentSubtitleLabel.font = [ASAttachmentView subtitleFont];
    [self addSubview:_attachmentSubtitleLabel];
    
    self.detailIcon = [[UIImageView alloc] init];
    self.detailIcon.image = [UIImage imageNamed:@"detail_arrow.png" inBundle:[NSBundle ASMessengerBundle] compatibleWithTraitCollection:nil];
    [self addSubview:self.detailIcon];
    
    return self;
}

+ (UIFont*)titleFont{
    
    static CGFloat fontSize;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        fontSize = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline].pointSize;
    });
    
    return [UIFont fontWithName:@"Avenir-Medium" size:fontSize];
}

+ (UIFont*)subtitleFont{
    
    static CGFloat fontSize;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        fontSize = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote].pointSize;
    });
    
    return [UIFont fontWithName:@"Avenir-Medium" size:fontSize];
}


+ (CGSize)determineAndCacheAttachmentViewSizeForEntry:(ASEntry *)entry maxWidth:(CGFloat)maxWidth{
    
    CGFloat maxLabelWidth = maxWidth - kAttachmentViewVerticalMargins * 2 - kDetailIconWidth;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [ASAttachmentView titleFont];
    titleLabel.text = entry.attachmentTitle;
    CGSize titleLabelSize = [titleLabel sizeThatFits:CGSizeMake(maxLabelWidth, CGFLOAT_MAX)];
    entry.attachmentTitleLabelSize = titleLabelSize;
    
    UILabel *subtitleLabel = [[UILabel alloc] init];
    subtitleLabel.font = [ASAttachmentView subtitleFont];
    subtitleLabel.text =  entry.attachmentSubtitle;
    CGSize subtitleLabelSize = [subtitleLabel sizeThatFits:CGSizeMake(maxLabelWidth, CGFLOAT_MAX)];
    entry.attachmentSubtitleLabelSize = subtitleLabelSize;
    
    CGFloat totalWidth = MAX(subtitleLabelSize.width, titleLabelSize.width) + kAttachmentViewVerticalMargins * 2 + kDetailIconWidth;
    
    CGFloat height = titleLabelSize.height + subtitleLabelSize.height + kAttachmentViewSpaceBetweenLabels + kAttachmentViewHorizontalMargins * 2;
    CGFloat totalHeight = MAX(kAttachmentViewMinimumHeight, height);
    
    return CGSizeMake(totalWidth, totalHeight);
}

- (void)reframeAllSubviewsWithEntry:(ASEntry *)entry{
    
    _attachmentTitleLabel.frame = CGRectMake(kAttachmentViewVerticalMargins,
                                             kAttachmentViewHorizontalMargins,
                                             entry.attachmentTitleLabelSize.width,
                                             entry.attachmentTitleLabelSize.height);
    
    CGFloat subtitleOriginY = kAttachmentViewHorizontalMargins + entry.attachmentTitleLabelSize.height + kAttachmentViewSpaceBetweenLabels;
    _attachmentSubtitleLabel.frame = CGRectMake(kAttachmentViewVerticalMargins,
                                                subtitleOriginY,
                                                entry.attachmentSubtitleLabelSize.width,
                                                entry.attachmentSubtitleLabelSize.height);
    
    _detailIcon.frame = CGRectMake(self.frame.size.width - kDetailIconWidth,
                                   (self.frame.size.height - kDetailIconHeight) / 2,
                                   kDetailIconWidth,
                                   kDetailIconHeight);
}

@end

#pragma mark - ASAttachmentCell

@implementation ASAttachmentCell

+ (CGSize)sizeForEntryContentViewWithEntry:(ASEntry *)entry maxWidth:(CGFloat)maxWidth{
    
    CGSize entryContentSize = [ASAttachmentView determineAndCacheAttachmentViewSizeForEntry:entry maxWidth:maxWidth];
    return entryContentSize;
}

+ (UIView *)generateEntryContentView{
    
    ASAttachmentView *attachmentView = [[ASAttachmentView alloc] init];
    
    attachmentView.layer.masksToBounds = YES;
    attachmentView.layer.cornerRadius = kEntryContentViewCornerRadius;
    
    return attachmentView;
}

+ (CGFloat)minimumMarginFromContentToNonAlignedCellEdge{
    
    return 25.0f;
}

- (void)configureEntryViewWithEntry:(ASEntry *)entry{
    
    ASAttachmentView *attachmentView = (ASAttachmentView *) self.entryContentView;
    
    if ([attachmentView isKindOfClass:[attachmentView class]]) {
        
        attachmentView.attachmentTitleLabel.text = entry.attachmentTitle;
        attachmentView.attachmentTitleLabel.textColor = entry.textColor ? entry.textColor : [UIColor colorWithWhite:0.1 alpha:1.0];
        
        attachmentView.attachmentSubtitleLabel.text = entry.attachmentSubtitle;
        attachmentView.attachmentSubtitleLabel.textColor = entry.textColor ? entry.textColor : [UIColor colorWithWhite:0.5 alpha:1.0];
        
        attachmentView.backgroundColor = entry.backgroudColor ? entry.backgroudColor : [UIColor colorWithWhite:0.9 alpha:1.0];
    }
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    ASAttachmentView *attachmentView = (ASAttachmentView *) self.entryContentView;
    
    if ([attachmentView isKindOfClass:[attachmentView class]]) {
        [attachmentView reframeAllSubviewsWithEntry:self.entry];
    }
}

@end

