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

#import "ASMessengerViewControllerSubclass.h"

@interface ASMessengerViewControllerSubclass ()

@end

@implementation ASMessengerViewControllerSubclass

-(void)viewDidLoad{
    
    [super viewDidLoad];
    self.title = @"ASMessenger";
}

- (instancetype)initWithEntries:(NSArray *)entries{
    
    self = [super initWithAttachmentType:ASAttachmentButtonTypePlus];
    
    [self setEntriesAndRefresh:entries]; // see ASRootVC for entry generating code
    
    return self;
}

#pragma mark - ASMessengerViewController Overrides

- (void)sendButtonPressedWithMessage:(NSString*)message{
    
    [self clearTextInputView]; // call BEFORE adding a new entry.
    
    [self addNewEntry:[ASEntry messageEntryWithAlignment:ASEntryAlignmentRight name:@"Johnny Appleseed" message:message]];
}

- (void)attachmentButtonPressed{
    
    NSLog(@"attachment button was pressed!");
}

- (void)entrySelected:(ASEntry*)entry{

    NSLog(@"entry was selected!");
}

@end
