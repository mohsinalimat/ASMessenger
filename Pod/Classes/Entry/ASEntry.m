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

#import "ASEntry.h"
#import "ASEntry_SizingCacheExtension.h"

@implementation ASEntry

- (instancetype)privateInit{
    
    return [super init];
}

+ (instancetype)messageEntryWithAlignment:(ASEntryAlignment)alignment{
    
    return [ASEntry messageEntryWithAlignment:alignment name:nil message:nil];
}

+ (instancetype)imageEntryWithAlignment:(ASEntryAlignment)alignment{
    
    return [ASEntry imageEntryWithAlignment:alignment name:nil image:nil];
}

+ (instancetype)attachmentEntryWithAlignment:(ASEntryAlignment)alignment{
    
    return [ASEntry attachmentEntryWithAlignment:alignment name:nil title:nil subtitle:nil attachmentInfo:nil];
}

+ (instancetype)statusEntry{
    
    return [ASEntry statusEntryWithStatus:nil];
}

+ (instancetype)messageEntryWithAlignment:(ASEntryAlignment)alignment name:(NSString *)name message:(NSString *)message{
    
    ASEntry *entry = [[ASEntry alloc] privateInit];
    
    entry.name = name;
    entry.entryType = ASEntryTypeMessage;
    entry.alignment = alignment;
    entry.messageText = message;
    
    return entry;
}

+ (instancetype)imageEntryWithAlignment:(ASEntryAlignment)alignment name:(NSString *)name image:(UIImage *)image{
    
    ASEntry *entry = [[ASEntry alloc] privateInit];
    
    entry.name = name;
    entry.entryType = ASEntryTypeImage;
    entry.alignment = alignment;
    entry.image = image;
    
    return entry;
}

+ (instancetype)attachmentEntryWithAlignment:(ASEntryAlignment)alignment name:(NSString *)name title:(NSString *)title subtitle:(NSString *)subtitle attachmentInfo:(NSDictionary *)attachmentInfo{
    
    ASEntry *entry = [[ASEntry alloc] privateInit];
    
    entry.name = name;
    entry.entryType = ASEntryTypeAttachment;
    entry.alignment = alignment;
    entry.attachmentTitle = title;
    entry.attachmentSubtitle = subtitle;
    entry.attachmentInfo = attachmentInfo;
    
    return entry;
}

+ (instancetype)statusEntryWithStatus:(NSString *)status{
    
    ASEntry *entry = [[ASEntry alloc] privateInit];
    
    entry.entryType = ASEntryTypeStatus;
    entry.statusMessage = status;
    
    return entry;
}

@end
