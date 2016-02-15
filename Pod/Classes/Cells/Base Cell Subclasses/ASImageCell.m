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

#import "ASImageCell.h"
#import "ASBaseCell_PrivateExtension.h"
#import "NSBundle+ASMessengerBundle.h"

static const CGFloat kNoImageImageHeight = 100.0f;
static const CGFloat kNoImageImageWidth = 100.0f;

@implementation ASImageCell

+ (CGSize)sizeForEntryContentViewWithEntry:(ASEntry *)entry maxWidth:(CGFloat)maxWidth{
    
    CGSize imageSize = entry.image.size;
    if (imageSize.height == 0 || imageSize.width == 0) return CGSizeMake(kNoImageImageWidth, kNoImageImageHeight);
    
    CGFloat heightToWidthRatio = imageSize.height / imageSize.width;
    
    CGFloat imageWidth = MIN(imageSize.width, maxWidth);
    CGFloat imageHeight = imageWidth * heightToWidthRatio;
    
    return CGSizeMake(imageWidth, imageHeight);
}

+ (UIView *)generateEntryContentView{
    
    UIImageView *imageView = [[UIImageView alloc] init];
    
    imageView.userInteractionEnabled = YES;
    imageView.clipsToBounds = YES;
    imageView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    imageView.layer.cornerRadius = kEntryContentViewCornerRadius;
    
    return imageView;
}

+ (CGFloat)minimumMarginFromContentToNonAlignedCellEdge{
    
    return 65.0f;
}

- (void)configureEntryViewWithEntry:(ASEntry *)entry{
    
    UIImageView *imageView = (UIImageView *) self.entryContentView;
    
    if ([imageView isKindOfClass:[UIImageView class]]) {
        
        if (entry.image) imageView.image = entry.image;
        else imageView.image = [UIImage imageNamed:@"no_image.png" inBundle:[NSBundle ASMessengerBundle] compatibleWithTraitCollection:nil];
    }
}

@end
