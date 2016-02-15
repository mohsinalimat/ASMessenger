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

#import <UIKit/UIKit.h>
#import "ASEntry.h"
#import "ASAttachmentButtonTypes.h"

// =========================
// ASMessengerViewController
// =========================

/**
 *
 * ASMessengerViewController is a generic messaging interface.
 * It consist of two main components: a UITableView and an ASTextInputView.
 *
 * ## Usage
 *
 * - Subclass ASMessengerViewController and utilize the entry management methods to populate the messaging interface (see the "ENTRY MANAGEMENT" pragma mark in the ASMessengerViewController header).
 * 
 * - Events should be handled by overriding the default implementations of the event handling methods (see the "EVENT HANDLING" pragma in the ASMessengerViewController header).
 *
 * ## Important
 *
 * @important Do not directly modifying the entries array. Instead, use the helper methods (see the "ENTRY MANAGEMENT" in the ASMessengerViewController header).
 * @important: This class is intended to be subclassed and should not be initialized directly.
 *
 */

@interface ASMessengerViewController : UIViewController

// =======
// ENTRIES
// =======

/**
 *
 * The 'entries' array should only contain ASEntry objects.
 *
 * Internally, the array serves as a data source of ASEntry object for the table view.
 *
 * @important Do not directly modifying the entries array. Instead, use the helper methods (see the "ENTRY MANAGEMENT" pragma mark in the ASMessengerViewController header).
 *
 */

@property (strong, nonatomic, readonly) NSMutableArray <ASEntry *> *entries;

// ====
// INIT
// ====

/**
 *
 * @param attachmentType specifies what type of button appears to the left of the text input (if any).
 *
 */

- (instancetype)initWithAttachmentType:(ASAttachmentButtonType)attachmentType;

// ================
// ENTRY MANAGEMENT
// ================

/*
 *
 * Use the following methods to manage what entries are show in the messages table view.
 *
 * @important Do not directly modifying the entries array. Instead, use the helper methods (see the "ENTRY MANAGEMENT" pragma mark in the ASMessengerViewController header).
 *
 */

/**
 *
 * @param entries can be NSMutableArray
 *
 */

- (void)setEntriesAndRefresh:(NSArray *)entries;
- (void)insertEntry:(ASEntry *)entry atIndex:(NSInteger)index animated:(BOOL)animated;
- (void)removeEntryAtIndex:(NSInteger)index animated:(BOOL)animated;
- (void)insertEntries:(NSArray *)entries atIndexs:(NSIndexSet *)indexs animated:(BOOL)animated;
- (void)removeEntriesAtIndexes:(NSIndexSet *)indexes animated:(BOOL)animated;
- (void)addNewEntry:(ASEntry *)entry;

// ==============
// EVENT HANDLING
// ==============

/**
 *
 * This method is called when the user presses the send button.
 *
 * The default implementation of this method does nothing.
 *
 * @param message the text in the text input view.
 *
 * @imporant It is recommended that clearTextInput is called **before** an entry is added.
 *
 */

- (void)sendButtonPressedWithMessage:(NSString *)message;

/**
 *
 * This method is called when the user presses the attachment button.
 *
 * The default implementation of this method does nothing.
 *
 */

- (void)attachmentButtonPressed;

/**
 *
 * This method is called when the user taps on an the content of an entry.
 *
 * The default implementation of this method does nothing.
 *
 * @param the entry selected
 *
 */

- (void)entrySelected:(ASEntry *)entry;

// =======
// HELPERS
// =======

/**
 *
 * Resigns the text input view
 *
 */

- (void)resignTextInputView;

/**
 *
 * Clears the text in the text input view
 *
 */

- (void)clearTextInputView;

/**
 *
 * Recalculates the height of all the entries and reloads the message table view.
 *
 */

- (void)reloadMessenger;

@end

