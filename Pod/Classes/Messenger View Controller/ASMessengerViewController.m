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

#import "ASMessengerViewController.h"
#import "ASTextInputView.h"
#import "ASMessageCell.h"
#import "ASImageCell.h"
#import "ASAttachmentCell.h"
#import "ASStatusCell.h"
#import "ASEntry_SizingCacheExtension.h"

@interface ASMessengerViewController () <UITableViewDelegate, UITableViewDataSource, ASTextInputViewDelegate, ASContentEntryTappedDelegate>

@property (strong, nonatomic, readwrite) NSMutableArray <ASEntry *> *entries;

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) ASTextInputView *textInputField;
@property (nonatomic) ASAttachmentButtonType attachmentButtonType;

@property (nonatomic) CGFloat lastKnowKeyboardHeight;
@property (nonatomic) CGFloat lastKnowKeyboardOriginY;
@property (nonatomic) CGFloat lastKnowTextInputViewHeight;

@end

/*
 * IMPORTANT INFORMATION ABOUT SIZING CALCULATIONS:
 *
 * To improve scrolling performance, expensive layout-time calculations are made in advanced when ASEntry objects are added to the _entries array.
 * The values resulting from the layout calculations are stored in "hidden" properties of the ASEntry objects. The "hidden" properties are defined and exposed by a class extension.
 * This is in contrast to a traditional setup, where these calculations are deferred until milliseconds before they are needed. This setup often causing frame rate hiccups.
 *
 * Do to this setup, the _entries array can not be directly set or modified, since simply adding entries to the _entries array will not cause the necessary calculations to be made.
 * Instead, the _entries array should be managed using the designated methods (see "Entry Management" pragma mark).
 * These helpers methods ensure that the required calculations are made and their results are stored.
 *
 * To make this possible, all cells that are used in the table view conform to the ASMessengerCellProtocol. The protocol has two purposes:
 * - calculate and store layout-related values for a given cell type and ASEntry
 * - provide a consistent way to have cells prepare themselves for reuse for any given ASEntry.
 *
 * Also see: ASBaseCell
 *
 */

@implementation ASMessengerViewController

#pragma mark - Init

- (instancetype)initWithAttachmentType:(ASAttachmentButtonType)attachmentType{
    
    self = [super init];
    
    self.attachmentButtonType = attachmentType;
    
    return self;
}

- (instancetype)init{
    
    return [[ASMessengerViewController alloc] initWithAttachmentType:ASAttachmentButtonTypeNone];
}

#pragma mark - Setup

- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    self.lastKnowKeyboardOriginY = self.view.frame.size.height;
    self.view.backgroundColor = [UIColor whiteColor];

    [self setupTextInputField];
    [self setupTableView];
    [self registerForLayoutRelatedNotifications];
}

- (void)setupTextInputField{
    
    _textInputField = [[ASTextInputView alloc] initWithAttachmentButtonType:_attachmentButtonType delegate:self];
    _lastKnowTextInputViewHeight = kEstimatedHeightForSingleTextLine;
    [self.view addSubview:_textInputField];
}

- (void)setupTableView{
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    [_tableView registerClass:[ASMessageCell class] forCellReuseIdentifier:kMessageCellReuseIdentifier];
    [_tableView registerClass:[ASImageCell class] forCellReuseIdentifier:kImageCellReuseIdentifier];
    [_tableView registerClass:[ASAttachmentCell class] forCellReuseIdentifier:kAttachmentCellReuseIdentifier];
    [_tableView registerClass:[ASStatusCell class] forCellReuseIdentifier:kStatusCellReuseIdentifier];
    
    [self.view addSubview:_tableView];
    [self.view sendSubviewToBack:_tableView];
}

- (void)registerForLayoutRelatedNotifications{
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardFrameWithChange:)
                                                 name:UIKeyboardWillChangeFrameNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(statusBarOrientationDidChange:)
                                                 name:UIApplicationDidChangeStatusBarOrientationNotification
                                               object:nil];
}

#pragma mark - Layout Management

- (void)viewWillLayoutSubviews{

    [self reframeAllSubviewsWithDuration:0.0f];
}

- (void)reframeAllSubviews{
    
    [self reframeAllSubviewsWithDuration:0.2f];
}

- (void)reframeAllSubviewsWithDuration:(CGFloat)duration{
    
    CGFloat textInputViewHeight = [_textInputField heightToFitTextViewContentWithWidth:self.view.frame.size.width];
    CGFloat totalNavigationBarHeight = self.navigationController.navigationBar.frame.size.height + [[UIApplication sharedApplication] statusBarFrame].size.height;
    CGFloat spaceForTextInputView = self.view.frame.size.height - _lastKnowKeyboardHeight - totalNavigationBarHeight;
    textInputViewHeight = MIN(spaceForTextInputView, textInputViewHeight);
    
    BOOL shouldScroll = [self shouldScrollToBottomWhenKeyboardTransitions];
    
    [UIView animateWithDuration:duration
                     animations:^{

                         _tableView.frame = CGRectMake(0.0f,
                                                       0.0f,
                                                       self.view.frame.size.width,
                                                       self.view.frame.size.height);
                         
                         _tableView.contentInset = UIEdgeInsetsMake(self.tableView.contentInset.top,
                                                                    0.0f,
                                                                    _lastKnowKeyboardHeight + textInputViewHeight,
                                                                    0.0f);
                         
                         _tableView.scrollIndicatorInsets = UIEdgeInsetsMake(_tableView.contentInset.top,
                                                                             0.0f, _lastKnowKeyboardHeight + textInputViewHeight,
                                                                             0.0f);
                         
                         _textInputField.frame = CGRectMake(0.0f,
                                                            self.view.frame.size.height - _lastKnowKeyboardHeight - textInputViewHeight,
                                                            self.view.frame.size.width,
                                                            textInputViewHeight);
                         
                         if (shouldScroll)[_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_entries.count - 1 inSection:0]
                                                            atScrollPosition:UITableViewScrollPositionNone animated:YES];
                         
                         [_textInputField reframeAllSubviews];
                     }
     ];
}

- (BOOL)shouldScrollToBottomWhenKeyboardTransitions{
    
    if (_lastKnowKeyboardHeight == 0) return NO; // keyboard is disappearing
    if (_tableView.contentSize.height - _lastKnowKeyboardHeight < 0) return NO;
    if (_tableView.contentSize.height - _tableView.contentOffset.y < self.tableView.frame.size.height * 1.5) return YES;
    
    return NO;
}

#pragma mark - Keyboard / Orientation Management

- (void)statusBarOrientationDidChange:(id)sender{
    
    if (![_textInputField isFirstResponder]) _lastKnowKeyboardOriginY = self.view.frame.size.height;
    [self reframeAllSubviews];
    [self calculateAndCacheCellFramingValuesForAllEntries];
    [self.tableView reloadData];
}

- (void)keyboardFrameWithChange:(id)sender{

    NSNotification *notification = (NSNotification*)sender;
    NSDictionary *userInfo = [notification userInfo];
    
    NSNumber *duration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSValue *rectValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect rect = [rectValue CGRectValue];
    
    _lastKnowKeyboardHeight = self.view.frame.size.height - rect.origin.y;
    
    [self reframeAllSubviewsWithDuration:duration.floatValue];
}

#pragma mark - Table View Delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ASEntry *entry = [_entries objectAtIndex:indexPath.row];
    
    if (entry.entryType == ASEntryTypeMessage) {
        
        ASMessageCell *messageCell = (ASMessageCell *)[tableView dequeueReusableCellWithIdentifier:kMessageCellReuseIdentifier];
        if (!messageCell.contentTappedDelegate) messageCell.contentTappedDelegate = self;
        [messageCell prepareWithEntry:entry];
        return messageCell;
    }
    
    if (entry.entryType == ASEntryTypeImage) {
        
        ASImageCell *imageCell = (ASImageCell *)[tableView dequeueReusableCellWithIdentifier:kImageCellReuseIdentifier];
        if (!imageCell.contentTappedDelegate) imageCell.contentTappedDelegate = self;
        [imageCell prepareWithEntry:entry];
        return imageCell;
    }

    if (entry.entryType == ASEntryTypeAttachment) {
        
        ASAttachmentCell *attachmentCell = (ASAttachmentCell *)[tableView dequeueReusableCellWithIdentifier:kAttachmentCellReuseIdentifier];
        if (!attachmentCell.contentTappedDelegate) attachmentCell.contentTappedDelegate = self;
        [attachmentCell prepareWithEntry:entry];
        return attachmentCell;
    }
    
    
    if (entry.entryType == ASEntryTypeStatus) {
        
        ASStatusCell *statusCell = [tableView dequeueReusableCellWithIdentifier:kStatusCellReuseIdentifier];
        [statusCell prepareWithEntry:entry];
        return statusCell;
    }
    
    NSString *exceptionMessage = [NSString stringWithFormat:@"Could not determine cell class to user for entry type %@", NSStringFromSelector(_cmd)];
    @throw [NSException exceptionWithName:@"ASMessengerInternalInconsistency"
                                   reason:exceptionMessage
                                 userInfo:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    ASEntry *entry = [_entries objectAtIndex:indexPath.row];
    return entry.cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ASEntry *entry = [_entries objectAtIndex:indexPath.row];
    return entry.cellHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return _entries.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 10.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 10.0f;
}

#pragma mark - Scroll View

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{

    dispatch_queue_t deselectTextQueue = dispatch_queue_create("deselect_text_queue", NULL);
    dispatch_async(deselectTextQueue, ^{
        
        // observer target method is thread safe
        [[NSNotificationCenter defaultCenter] postNotificationName:kDeselectMessageCellNotificationText object:nil];
    });
}

#pragma mark - Text Input View Passthrough Delegate

- (void)passthroughSendButtonPressedWithMessage:(NSString *)message{
    
    [self sendButtonPressedWithMessage:message];
}

- (void)passthroughAttachmentButtonPressed{
 
    [self attachmentButtonPressed];
}

- (void)heightRequiredToFitTextViewContentHasChanged{
    
    [self reframeAllSubviews];
}

#pragma mark - Entry Handling

- (void)sendButtonPressedWithMessage:(NSString*)message{
    
    // subclass should override
}

- (void)attachmentButtonPressed{
    
    // subclass should override
}

- (void)entrySelected:(ASEntry*)entry{
    
    // subclass should override
}

#pragma mark - Entry Management

- (void)setEntriesAndRefresh:(NSArray*)entries{
    
    _entries = [NSMutableArray arrayWithArray:entries];
    [self reloadMessenger];
}

- (void)insertEntry:(ASEntry*)entry atIndex:(NSInteger)index animated:(BOOL)animated{
    
    [self insertEntries:@[entry] atIndexs:[NSIndexSet indexSetWithIndex:index] animated:animated];
}

- (void)insertEntries:(NSArray*)entries atIndexs:(NSIndexSet*)indexs animated:(BOOL)animated{
    
    UITableViewRowAnimation rowAnimation = (animated) ? UITableViewRowAnimationFade : UITableViewRowAnimationNone;
    
    NSArray *indexPaths = [self indexPathsForIndexs:indexs];
    
    // order of ops matters
    [self.entries insertObjects:entries atIndexes:indexs];
    [self calculateAndCacheCellFramingValuesForEntries:entries];
    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:rowAnimation];
}

- (void)removeEntryAtIndex:(NSInteger)index animated:(BOOL)animated{
    
    [self removeEntriesAtIndexes:[NSIndexSet indexSetWithIndex:index] animated:animated];
}

-(void)removeEntriesAtIndexes:(NSIndexSet *)indexes animated:(BOOL)animated{
    
    UITableViewRowAnimation rowAnimation = (animated) ? UITableViewRowAnimationFade : UITableViewRowAnimationNone;
    
    NSArray *indexPaths = [self indexPathsForIndexs:indexes];
    
    [self.entries removeObjectsAtIndexes:indexes];
    [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:rowAnimation];
}

- (void)addNewEntry:(ASEntry*)entry{
    
    NSIndexPath *bottomIndexPath = [NSIndexPath indexPathForItem:[self tableView:_tableView numberOfRowsInSection:0] inSection:0];
    
    CGFloat visableContentHeight = self.tableView.frame.size.height - self.tableView.contentInset.top - self.tableView.contentInset.bottom;
    CGFloat contentHeight = self.tableView.contentSize.height;
    
    UITableViewRowAnimation rowAnimation;
    if (contentHeight > visableContentHeight) rowAnimation =  UITableViewRowAnimationBottom;
    else if (entry.alignment == ASEntryAlignmentLeft) rowAnimation = UITableViewRowAnimationLeft;
    else rowAnimation = UITableViewRowAnimationRight;
    
    // order of ops matters
    [self.entries addObject:entry];
    [self calculateAndCacheCellFramingValuesForEntries:@[entry]];
    [self.tableView insertRowsAtIndexPaths:@[bottomIndexPath] withRowAnimation:rowAnimation];
    
    [self.tableView scrollToRowAtIndexPath:bottomIndexPath atScrollPosition:UITableViewScrollPositionNone animated:YES];
}

#pragma mark - Cell Framing Calculations & Caching

- (void)calculateAndCacheCellFramingValuesForAllEntries{
    
    [self calculateAndCacheCellFramingValuesForEntries:_entries];
}

- (void)calculateAndCacheCellFramingValuesForEntries:(NSArray*)entries{
    
    for (ASEntry *entry in entries) {
         [self calculateAndCacheCellFramingValuesForEntry:entry];
    }
}

- (void)calculateAndCacheCellFramingValuesForEntry:(ASEntry*)entry{
    
    [self assignShouldForceHideNameForEntry:entry];
    
    if (entry.entryType == ASEntryTypeMessage){
        [ASMessageCell calculateAndAssignCellFramingValuesForEntry:entry withCellWidth:self.view.frame.size.width];
        return;
    }
    
    if (entry.entryType == ASEntryTypeImage){
        [ASImageCell calculateAndAssignCellFramingValuesForEntry:entry withCellWidth:self.view.frame.size.width];
        return;
    }
    
    if (entry.entryType == ASEntryTypeAttachment) {
        [ASAttachmentCell calculateAndAssignCellFramingValuesForEntry:entry withCellWidth:self.view.frame.size.width];
        return;
    }
    
    if (entry.entryType == ASEntryTypeStatus) {
        [ASStatusCell calculateAndAssignCellFramingValuesForEntry:entry withCellWidth:self.view.frame.size.width];
        return;
    }
}

#pragma mark - Name Helper

/// @important entry must be in the _entries array, or entry.shouldForceHideName = NO
- (void)assignShouldForceHideNameForEntry:(ASEntry *)entry{

    if (!entry.name){
        entry.shouldForceHideName = NO;
        return;
    }
    
    NSInteger indexOfEntry = [_entries indexOfObject:entry];
    if (indexOfEntry == NSNotFound || indexOfEntry == 0){
        entry.shouldForceHideName = NO;
        return;
    }

    ASEntry *priorEntry = [_entries objectAtIndex:indexOfEntry - 1];
    if ([entry.name isEqualToString:priorEntry.name] && entry.alignment == priorEntry.alignment){
        entry.shouldForceHideName = YES;
        return;
    }
    entry.shouldForceHideName = NO;
}

#pragma mark - IndexSet to IndexPath

- (NSArray *)indexPathsForIndexs:(NSIndexSet*)indexs{
    
    NSMutableArray *indexPaths = [NSMutableArray array];
    
    [indexs enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
        
        [indexPaths addObject:[NSIndexPath indexPathForItem:idx inSection:0]];
    }];

    return [NSArray arrayWithArray:indexPaths];
}

#pragma mark - ASContentEntryTappedDelegate

- (void)contentWasTappedForEntry:(ASEntry *)entry{
    
    [self entrySelected:entry];
}

#pragma mark - Subclass Helpers

- (void)resignTextInputView{
    
    [self.textInputField resign];
}

- (void)clearTextInputView{

    [self.textInputField clearTextInputView];
}

- (void)reloadMessenger{
    
    [self calculateAndCacheCellFramingValuesForAllEntries];
    [self.tableView reloadData];
}

@end
