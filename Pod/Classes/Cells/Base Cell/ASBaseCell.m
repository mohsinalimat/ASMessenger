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

#import "ASBaseCell.h"
#import "ASBaseCell_PrivateExtension.h"
#import "ASEntry_SizingCacheExtension.h"

// name label framing
const static CGFloat kNameLabelHeight = 14.0f;
const static CGFloat kNameLabelToTopMargin = 10.0f;
const static CGFloat kNameLabelToSideMargin = 12.0f;

// content container framing
const static CGFloat kContentContainerToNameLabelMargin = 3.0f;
const static CGFloat kContentContainerToTopMargin = 4.0f; // used if name label is hidden
const static CGFloat kContentContainerToBottomMargin = 0.0f;
const static CGFloat kContentContainerAlignedSideOutsideMargin = 10.0;

@interface ASBaseCell ()

@property (strong, nonatomic) UILabel *nameLabel;

@property (strong, nonatomic) UITapGestureRecognizer *tapRecognizer;

@end

// IMPORTANT: Class description and important subclassing information are available in the header.

@implementation ASBaseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.nameLabel = [self generateNameLabel];
    [self addSubview:self.nameLabel];
    
    self.entryContentView = [[self class] generateEntryContentView];
    [self addSubview:self.entryContentView];
    
    self.tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRecognized:)];
    [self.entryContentView addGestureRecognizer:self.tapRecognizer];
    
    return self;
}

#pragma mark - Tap Recognizer

- (void)tapRecognized:(UITapGestureRecognizer *)tapGestureRecognizer{
    
    if (_contentTappedDelegate && [_contentTappedDelegate respondsToSelector:@selector(contentWasTappedForEntry:)]){
        
        [_contentTappedDelegate contentWasTappedForEntry:_entry];
    }
}

#pragma mark - ASMessengerCellProtocol

- (void)prepareWithEntry:(ASEntry *)entry{
    
    _entry = entry;
    
    if (!_entry.name || entry.shouldForceHideName) [self setNameLabelText:nil];
    
    else {
        
        _nameLabel.textAlignment = (entry.alignment == ASEntryAlignmentLeft) ? NSTextAlignmentLeft : NSTextAlignmentRight;
        [self setNameLabelText:entry.name];
    }

    [self configureEntryViewWithEntry:entry];
}

#pragma mark - Layout Management

- (void)layoutSubviews{
    
    [self layoutAllSubviews];
}


- (void)layoutAllSubviews{
    
    // frames name label (if necessary)
    if (!_nameLabel.hidden) _nameLabel.frame = CGRectMake(kNameLabelToSideMargin,
                                                          kNameLabelToTopMargin,
                                                          self.frame.size.width - kNameLabelToSideMargin * 2,
                                                          kNameLabelHeight);
    
    // frames entry content view
    CGFloat messageContainerOriginY;
    if (!_nameLabel.hidden) messageContainerOriginY = kNameLabelHeight + kNameLabelToTopMargin + kContentContainerToNameLabelMargin;
    else messageContainerOriginY = kContentContainerToTopMargin;
    
    CGFloat messageContainerOriginX;
    if (_entry.alignment == ASEntryAlignmentRight) messageContainerOriginX = self.frame.size.width - kContentContainerAlignedSideOutsideMargin - _entry.entryContentSize.width;
    else messageContainerOriginX = kContentContainerAlignedSideOutsideMargin;
        
    _entryContentView.frame = CGRectMake(messageContainerOriginX,
                                         messageContainerOriginY,
                                         _entry.entryContentSize.width, // entry size pre-calculated and cached in the entry
                                         _entry.entryContentSize.height);
}

#pragma mark - ASMessengerCellProtocol

+ (void)calculateAndAssignCellFramingValuesForEntry:(ASEntry *)entry withCellWidth:(CGFloat)cellWidth{
    
    CGFloat heightOfCell = 0;
    
    if (entry.name && !entry.shouldForceHideName) heightOfCell += kNameLabelHeight + kNameLabelToTopMargin + kContentContainerToNameLabelMargin;
    else heightOfCell += kContentContainerToTopMargin;
    
    CGFloat messageLabelMaxWidth = cellWidth - kContentContainerAlignedSideOutsideMargin - [self minimumMarginFromContentToNonAlignedCellEdge];
    CGSize entryContentSize = [self sizeForEntryContentViewWithEntry:entry maxWidth:messageLabelMaxWidth];
    heightOfCell += entryContentSize.height + kContentContainerToBottomMargin;
    
    entry.cellHeight = heightOfCell;
    entry.entryContentSize = entryContentSize;
}

#pragma mark - Methods To Be Overridden

/*
 * IMPORTANT: ALL OF THE METHODS IN THIS "PRAGMA MARK SECTION" MUST BE OVERRIDDEN BY SUBCLASSES
 *
 * Method are declared in the a class extension so subclasses can safely override them
 *
 * See ASBaseCell.h for details
 *
 */

+ (CGSize)sizeForEntryContentViewWithEntry:(ASEntry *)entry maxWidth:(CGFloat)maxWidth{
    
    @throw [NSException exceptionWithName:@"ASMessengerInternalInconsistency"
                                   reason:[NSString stringWithFormat:@"+%s must be overridden by ASBaseCell subclass",sel_getName(_cmd)]
                                 userInfo:nil];
}

+ (UIView *)generateEntryContentView{
    
    @throw [NSException exceptionWithName:@"ASMessengerInternalInconsistency"
                                   reason:[NSString stringWithFormat:@"+%s must be overridden by ASBaseCell subclass",sel_getName(_cmd)]
                                 userInfo:nil];
}

+ (CGFloat)minimumMarginFromContentToNonAlignedCellEdge{
    
    @throw [NSException exceptionWithName:@"ASMessengerInternalInconsistency"
                                   reason:[NSString stringWithFormat:@"+%s must be overridden by ASBaseCell subclass",sel_getName(_cmd)]
                                 userInfo:nil];
}

- (void)configureEntryViewWithEntry:(ASEntry *)entry{
    
    
    @throw [NSException exceptionWithName:@"ASMessengerInternalInconsistency"
                                   reason:[NSString stringWithFormat:@"+%s must be overridden by ASBaseCell subclass",sel_getName(_cmd)]
                                 userInfo:nil];
}

#pragma mark - Name Label Helpers

- (void)setNameLabelText:(NSString *)nameText{
    
    if (nameText) {
        _nameLabel.hidden = NO;
        _nameLabel.text = nameText;
    }
    
    else{
        _nameLabel.hidden = YES;
        _nameLabel.text = nil;
    }
}

- (UILabel *)generateNameLabel{
    
    UILabel *nameLabel = [[UILabel alloc]init];
    
    nameLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:12.0f];
    nameLabel.textColor = [UIColor lightGrayColor];
    
    return nameLabel;
}

@end
