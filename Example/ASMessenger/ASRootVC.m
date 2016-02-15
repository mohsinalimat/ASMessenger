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

#import "ASRootVC.h"
#import "ASMessengerViewControllerSubclass.h"

static NSString * kLeftPersonName = @"Johnny Appleseed";
static NSString * kRightPersonName = @"Steve Jobs";

@interface ASRootVC ()

@property (weak, nonatomic) IBOutlet UITableViewCell * basicExampleCell;
@property (weak, nonatomic) IBOutlet UITableViewCell * withDataDetectionLinksCell;
@property (weak, nonatomic) IBOutlet UITableViewCell * withoutNamesCell;
@property (weak, nonatomic) IBOutlet UITableViewCell * withCustomColorsCell;
@property (weak, nonatomic) IBOutlet UITableViewCell * withLargeDatasetCell;
@property (weak, nonatomic) IBOutlet UITableViewCell * withAttachmentsCell;
@property (weak, nonatomic) IBOutlet UITableViewCell * withStatusMessagesCell;
@property (weak, nonatomic) IBOutlet UITableViewCell * withImageCell;
@property (weak, nonatomic) IBOutlet UITableViewCell * withAllCellTypesAndLargeDatasetCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *blankConversationCell;



@property (strong, nonatomic) NSArray * exampleMessagesText;

@property (strong, nonatomic) NSArray * exampleAttachmentEntries;
@property (strong, nonatomic) NSArray * exampleStatusEntries;
@property (strong, nonatomic) NSArray * exampleImageEntries;

@end

@implementation ASRootVC

- (void)viewDidLoad{
  
    [super viewDidLoad];
    self.title = @"Menu";
    [self exampleMessagesText];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray *entries;
    
    UITableViewCell * selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (selectedCell == _basicExampleCell) {
        entries = [self entriesForBasicExample];
    }
    else if (selectedCell == _withDataDetectionLinksCell) {
        entries = [self entriesForWithDataDetectionLinks];
    }
    else if (selectedCell == _withoutNamesCell) {
        entries = [self entriesForWithoutNames];
    }
    else if (selectedCell == _withCustomColorsCell) {
        entries = [self entriesForWithCustomColors];
    }
    else if (selectedCell == _withLargeDatasetCell) {
        entries = [self entriesForWithLargeDataset];
    }
    else if (selectedCell == _withAttachmentsCell) {
        entries = [self entriesForWithAttachments];
    }
    else if (selectedCell == _withStatusMessagesCell) {
        entries = [self entriesForWithStatusMessages];
    }
    else if (selectedCell == _withImageCell) {
        entries = [self entriesForWithImages];
    }
    else if (selectedCell == _withAllCellTypesAndLargeDatasetCell) {
        entries = [self entriesForAllTypesLargeDataset];
    }
    else if (selectedCell == _blankConversationCell) {
        entries = nil;
    }
    
    ASMessengerViewControllerSubclass *messengerViewControllerSubclass = [[ASMessengerViewControllerSubclass alloc] initWithEntries:entries];
    [self.navigationController pushViewController:messengerViewControllerSubclass animated:YES];
}

#pragma mark - Example Dataset Generators

- (NSArray *)entriesForBasicExample{
    
    return [self generateExampleMessageEntriesArrayWithCount:30];
}

- (NSArray *)entriesForWithDataDetectionLinks{
    
    NSArray *textWithDataDetectableInfo = @[[ASEntry messageEntryWithAlignment:ASEntryAlignmentLeft
                                                                          name:@"Johnny Appleseed"
                                                                       message:@"My phone number is (512) 123-4567"],
                                            
                                            [ASEntry messageEntryWithAlignment:ASEntryAlignmentRight
                                                                          name:@"Mark Scott"
                                                                       message:@"The address is 123 Main St, Austin, TX. 78701"],
                                            
                                            [ASEntry messageEntryWithAlignment:ASEntryAlignmentLeft
                                                                          name:@"Johnny Appleseed"
                                                                       message: @"Paul's email is paul@example.com"],
                                            
                                            [ASEntry messageEntryWithAlignment:ASEntryAlignmentRight
                                                                          name:@"Mark Scott"
                                                                       message:@"My favorite search engine is google.com"]
                                            ];
    
    return [self exampleDatasetWithRandomlyInsertedEntries:textWithDataDetectableInfo];
}

- (NSArray *)entriesForWithoutNames{
    
    NSArray * entries = [self generateExampleMessageEntriesArrayWithCount:30];
    
    for (ASEntry *entry in entries) {
        entry.name = nil;
    }
    
    return entries;
}

- (NSArray *)entriesForWithCustomColors{
    
    NSArray * entries = [self generateExampleMessageEntriesArrayWithCount:30];
    
    for (ASEntry *entry in entries) {
        
        if (entry.alignment == ASEntryAlignmentRight){
            
            entry.backgroudColor = [UIColor colorWithRed:0.141 green:0.635 blue:0.482 alpha:1.00];
            entry.textColor = [UIColor whiteColor];
        }
        
        else {
            
            entry.backgroudColor = [UIColor colorWithRed:0.223 green:0.589 blue:0.688 alpha:1.00];
            entry.textColor = [UIColor whiteColor];
        }
    }
    
    return entries;
}

- (NSArray *)entriesForWithLargeDataset{
    
    return [self generateExampleMessageEntriesArrayWithCount:150];
}

- (NSArray *)entriesForWithAttachments{
    
    return [self exampleDatasetWithRandomlyInsertedEntries:self.exampleAttachmentEntries];
}

- (NSArray *)entriesForWithStatusMessages{
    
    return [self exampleDatasetWithRandomlyInsertedEntries:self.exampleStatusEntries];
}

- (NSArray *)entriesForWithImages{
    
    return [self exampleDatasetWithRandomlyInsertedEntries:self.exampleImageEntries];
}

- (NSArray *)entriesForAllTypesLargeDataset{
    
    NSMutableArray *mixedEntryTypes = [[NSMutableArray alloc] init];
    
    [mixedEntryTypes addObjectsFromArray:self.exampleAttachmentEntries];
    [mixedEntryTypes addObjectsFromArray:self.exampleImageEntries];
    [mixedEntryTypes addObjectsFromArray:self.exampleStatusEntries];
    [mixedEntryTypes addObjectsFromArray:[self generateExampleMessageEntriesArrayWithCount:100]];

    return [self exampleDatasetWithRandomlyInsertedEntries:[NSArray arrayWithArray:mixedEntryTypes]];
}

#pragma mark - Example Dataset Generator Helpers

- (NSArray *)generateExampleMessageEntriesArrayWithCount:(NSInteger)entriesCount{
    
    NSString *firstEntryMessage = @"Hey there! Below are unordered ASMessenger tid-bits, 'Austin-y' things, and random messages of various lengths.";
    ASEntry *firstEntry = [ASEntry messageEntryWithAlignment:ASEntryAlignmentRight
                                                        name:kRightPersonName
                                                     message:firstEntryMessage];
    
    NSMutableArray *exampleEntries = [NSMutableArray arrayWithObject:firstEntry];
    entriesCount --;
    
    NSInteger exampleMessagesCount = self.exampleMessagesText.count;
    
    for (int i = 0; i < entriesCount; i ++) {
        
        BOOL randomBool = (BOOL)arc4random_uniform(2);
        NSString *message = [self.exampleMessagesText objectAtIndex:arc4random_uniform((u_int32_t)exampleMessagesCount)];
        
        [exampleEntries addObject:[ASEntry messageEntryWithAlignment:randomBool ? ASEntryAlignmentLeft : ASEntryAlignmentRight
                                                                name:randomBool ? kLeftPersonName : kRightPersonName
                                                             message:message]
         ];
    }
    
    return [NSArray arrayWithArray:exampleEntries];
}

- (NSArray *)exampleDatasetWithRandomlyInsertedEntries:(NSArray *)entries{
    
    NSMutableArray *combinedEntries = [NSMutableArray arrayWithArray:[self generateExampleMessageEntriesArrayWithCount:30]];
    NSUInteger maxIndex = combinedEntries.count;
    
    for (ASEntry *entry in entries) {
        
        [combinedEntries insertObject:entry atIndex:arc4random_uniform((u_int32_t)maxIndex)];
    }
    
    return [NSArray arrayWithArray:combinedEntries];
}

#pragma mark - Lazy Inits

- (NSArray *)exampleMessagesText{
    
    if (!_exampleMessagesText) {
        
        _exampleMessagesText = @[@"It's easy to implement",
                                 @"ASMessenger is a lightweight and modern",
                                 @"Keep Austin Weird",
                                 @"Chase Tower",
                                 @"This library was made for brief, customer-support type conversations",
                                 @"What's up?",
                                 @"Internally, a bunch of fancy optimizations improve scrolling performance",
                                 @"Mozart's Coffee",
                                 @"ASMessenger was originally developed for a specific app, but is now being open sourced!",
                                 @"Rainy Street",
                                 @"ASMessenger was made in Austin",
                                 @"Hello friend",
                                 @"It is intentionally simple, serving as a alternative for when more full-featured libraries are an overkill",
                                 @"This library features a slick, minimalistic interface",
                                 @"Okie Dokie",
                                 @"There is always money in the banana stand",
                                 @"I'll call you back",
                                 @"Thirsty Goat",
                                 @"Guacamole is extra, is that OK?",
                                 @"Internally, it is packed with a bunch of small optimizations to maximize scrolling performance.",
                                 @"It's very cool.",
                                 @"I've heard the developer is a cool guy."
                                 ];
    }
    
    return _exampleMessagesText;
}

- (NSArray *)exampleImageEntries{
    
    if (!_exampleImageEntries) {
        
        _exampleImageEntries = @[[ASEntry imageEntryWithAlignment:ASEntryAlignmentLeft
                                                              name:kLeftPersonName
                                                             image:[UIImage imageNamed:@"sample_image_0.png"]],
                                  [ASEntry imageEntryWithAlignment:ASEntryAlignmentLeft
                                                              name:kLeftPersonName
                                                             image:[UIImage imageNamed:@"sample_image_0.png"]],
                                  [ASEntry imageEntryWithAlignment:ASEntryAlignmentRight
                                                              name:kRightPersonName
                                                             image:[UIImage imageNamed:@"sample_image_0.png"]],
                                  [ASEntry imageEntryWithAlignment:ASEntryAlignmentRight
                                                              name:kRightPersonName
                                                             image:[UIImage imageNamed:@"sample_image_0.png"]],
                                  ];
    }
    
    return _exampleImageEntries;
}

- (NSArray *)exampleStatusEntries{
    
    if (!_exampleStatusEntries) {
        
        _exampleStatusEntries = @[[ASEntry statusEntryWithStatus:@"The user has left the chat"],
                                           [ASEntry statusEntryWithStatus:@"Today 1:45 PM"],
                                           [ASEntry statusEntryWithStatus:@"Tuesday, January 15th"],
                                  [ASEntry statusEntryWithStatus:@"You'll be connected with an agent shortly."]
                                  ];
    }
                                  
    return _exampleStatusEntries;
}

- (NSArray *)exampleAttachmentEntries{
    
    if (!_exampleAttachmentEntries) {
        
        _exampleAttachmentEntries = @[[ASEntry attachmentEntryWithAlignment:ASEntryAlignmentRight
                                          name:@"Mark Scott"
                                         title:@"Mark's Seafood Menu"
                                      subtitle:@"PDF Attachment"
                                attachmentInfo:nil],
         
         [ASEntry attachmentEntryWithAlignment:ASEntryAlignmentRight
                                          name:@"Mark Scott"
                                         title:@"Mark's Seafood Location"
                                      subtitle:@"View on Map"
                                attachmentInfo:nil],
         
         [ASEntry attachmentEntryWithAlignment:ASEntryAlignmentLeft
                                          name:@"Johnny Appleseed"
                                         title:@"Work Invoice"
                                      subtitle:@"PDF Attachment"
                                attachmentInfo:nil],
         
         [ASEntry attachmentEntryWithAlignment:ASEntryAlignmentLeft
                                          name:@"Johnny Appleseed"
                                         title:@"Johnny's Profile"
                                      subtitle:@"Tap to View Profile"
                                attachmentInfo:nil],
         ];
    }
    
    return _exampleAttachmentEntries;
}

@end
