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
#import "ASMessengerCellProtocol.h"

/*
 * ASBaseCell is an abstract class that provides a consistent implementation of functionality that is shared amongst most table view cells in this project.
 * This functionality set includes having a name displayed above the content of a message, and the ability to have content aligned left or right.
 * Please note that while most cell in this project inherit from ASBaseCell, not all do.
 *
 * This class must be subclassed and should never be directly initialized.
 * Furthermore, there are several method that must be overridden, or an exception will be thrown.
 * The methods that must be overridden are declared in ASBaseCell_PrivateExtension.h
 *
 */

@protocol ASContentEntryTappedDelegate <NSObject>

- (void)contentWasTappedForEntry:(ASEntry *)entry;

@end

@interface ASBaseCell : UITableViewCell <ASMessengerCellProtocol>

@property (weak, nonatomic) id<ASContentEntryTappedDelegate> contentTappedDelegate;

@end