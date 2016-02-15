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

/* ===== ALL OF THE METHODS IN THIS EXTENSION MUST BE OVERRIDDEN BY SUBCLASSES ===== */

const static CGFloat kEntryContentViewCornerRadius = 4.0f;

@interface ASBaseCell ()

/// @breif The primary content of the cell, such as the message text view. May be UIView subclass.
@property (strong, nonatomic) UIView *entryContentView;

@property (strong, nonatomic) ASEntry *entry;

/*
 *
 * ASBaseCell will call this method to determine the of exact size of the entryContentView for a given ASEntry.
 * The value returned is used to determine total height of the cell.
 * Both the size of the content view and the height are "cached" on the ASEntry.
 *
 * IMPORTANT: These method must be overridden by ASBaseCell subclasses
 *
 */

+ (CGSize)sizeForEntryContentViewWithEntry:(ASEntry *)entry maxWidth:(CGFloat)maxWidth;
+ (UIView *)generateEntryContentView;
+ (CGFloat)minimumMarginFromContentToNonAlignedCellEdge;
- (void)configureEntryViewWithEntry:(ASEntry *)entry;

@end
