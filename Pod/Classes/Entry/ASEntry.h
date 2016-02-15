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

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum {
    ASEntryAlignmentRight,
    ASEntryAlignmentLeft,
} ASEntryAlignment;

typedef enum {
    ASEntryTypeMessage,
    ASEntryTypeImage,
    ASEntryTypeAttachment,
    ASEntryTypeStatus,
} ASEntryType;

/**
 *
 * The 'ASEntry' class contains informations for a single item in the ASMessengerViewController.
 *
 * ASEntry can only be initializes through class methods.
 *
 */

@interface ASEntry : NSObject

- (instancetype)init NS_UNAVAILABLE;

// ================
// ENTRY GENERATORS
// ================

+ (instancetype)messageEntryWithAlignment:(ASEntryAlignment)alignment;
+ (instancetype)imageEntryWithAlignment:(ASEntryAlignment)alignment;
+ (instancetype)attachmentEntryWithAlignment:(ASEntryAlignment)alignment;
+ (instancetype)statusEntry;

+ (instancetype)messageEntryWithAlignment:(ASEntryAlignment)alignment name:(NSString *)name message:(NSString *)message;
+ (instancetype)imageEntryWithAlignment:(ASEntryAlignment)alignment name:(NSString *)name image:(UIImage *)image;
+ (instancetype)attachmentEntryWithAlignment:(ASEntryAlignment)alignment name:(NSString *)name title:(NSString *)title subtitle:(NSString *)subtitle attachmentInfo:(NSDictionary *)attachmentInfo;
+ (instancetype)statusEntryWithStatus:(NSString *)status;

/**
 *
 * The 'entryType' property specifies what type of content the ASEntry contains, such as a message, image, or attachment.
 *
 * Internally, ASMessengerViewController will use this value to select the appropriate UITableViewCell subclass class to used to display the entry.
 *
 */

// ==================
// SHARED PROPERTIES
// ==================

@property (nonatomic) ASEntryType entryType;

/**
 *
 * The 'alignment' property specifies what side of the ASMessengerViewController the message is aligned to. Generally, left correlates to incoming messages and right correlates to outgoing messages.
 *
 * Alignment impacts the default message bubble and text color for entries of type ASEntryTypeMessage.
 *
 * This property affects all entry types except for ASEntryTypeStatus.
 *
 */

@property (nonatomic) ASEntryAlignment alignment;

/**
 *
 * Nullable. The 'name' property specifies the text displayed above the message bubble, which is normally the name of the sender.
 *
 * Internally, ASMessengerViewController will automatically makes the change necessary to hide the label if nil.
 *
 * This property affects all entry types except for ASEntryTypeStatus.
 *
 */

@property (strong, nonatomic) NSString *name;

/**
 *
 * Nullable. The 'backgroudColor' property specifies the background color for the content bubble.
 *
 * For entry type ASEntryTypeMessage, right aligned cells will default to a shade of blue, and left aligned cell will default to a shade of gray.
 *
 * For entry type ASEntryTypeAttachment, backgroundColor will default to shade of light gray.
 *
 * This property only affects entry types ASEntryTypeMessage and ASEntryTypeAttachment.
 *
 */

@property (strong, nonatomic) UIColor *backgroudColor;

/**
 *
 * Nullable. The 'textColor' property specifies the text color of the text in the message bubble.
 *
 * For entry type ASEntryTypeMessage, right aligned cells will default to white, and left aligned cell will default to a shade of black.
 *
 * For entry type ASEntryTypeAttachment, textColor will default to a shade of black. This property does not impact the subtitle label (see 'attachmentSubtitleColor').
 *
 * This property only affects entry types ASEntryTypeMessage and ASEntryTypeAttachment.
 *
 */

@property (strong, nonatomic) UIColor *textColor;

// ========================
// MESSAGE ENTRY PROPERTIES
// ========================

/**
 *
 * The 'messageText' property specifies the text will be shown in the content bubble.
 *
 * This property only affects entry type ASEntryTypeMessage.
 *
 * Leaving this property nil will not cause a crash, but it is not recommended.
 *
 */

@property (strong, nonatomic) NSString *messageText;

// ===========================
// ATTACHMENT ENTRY PROPERTIES
// ===========================

/**
 *
 * The 'attachmentTitle' property specifies the text of the top label in the content bubble.
 *
 * This property only affects entry type ASEntryTypeAttachment.
 *
 * Leaving this property nil will not cause a crash, but it is not recommended.
 *
 */

@property (strong, nonatomic) NSString *attachmentTitle;

/**
 *
 * Nullable. The 'attachmentSubtitle' property specifies the text of the bottom label in the content bubble.
 *
 * This property only affects entry type ASEntryTypeAttachment.
 *
 */

@property (strong, nonatomic) NSString *attachmentSubtitle;

/**
 *
 * Nullable. The 'attachmentSubtitleColor' property specifies the textColor of the bottom label in the content bubble.
 *
 * This property only affects entry types ASEntryTypeAttachment.
 *
 * By default, the attachmentSubtitleColor will be a shade of black.
 *
 */

@property (strong, nonatomic) UIColor *attachmentSubtitleColor;

/**
 *
 * Nullable. The 'attachmentInfo' property should be used to store information about attachment.
 *
 * For example, if the attachment was a link, attachmentInfo may contain a NSURL.
 *
 * This property does not impact the internal workings of ASMessenger.
 *
 */

@property (strong, nonatomic) NSDictionary *attachmentInfo;

// ===========================
// IMAGE ENTRY PROPERTIES
// ===========================

/**
 *
 * The 'image' property specifies the image that should be shown in the content bubble.
 *
 * This property only affects entry type ASEntryTypeImage.
 *
 * Leaving this property nil will not cause a crash, but it is not recommended.
 *
 * The way image cells are handled will be overhauled in a future release to support asynchronous loading and caching.
 *
 */

@property (strong, nonatomic) UIImage *image;

// ===========================
// STATUS ENTRY PROPERTIES
// ===========================

/**
 *
 * The 'statusMessage' property specifies the text shown in the status cell.
 *
 * This property only affects entry type ASEntryTypeStatus.
 *
 * Leaving this property nil will not cause a crash, but it is not recommended.
 *
 */

@property (strong, nonatomic) NSString *statusMessage;

@end
