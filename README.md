# ASMessenger [PRE-RELEASE]

**IMPORTANT: This is a pre-release. There are known bugs. Features and the API is subject to change.**

[![Version](https://img.shields.io/cocoapods/v/ASMessenger.svg?style=flat)](http://cocoapods.org/pods/ASMessenger)
[![License MIT](https://img.shields.io/cocoapods/l/ASMessenger.svg?style=flat)](http://cocoapods.org/pods/ASMessenger)
[![Platform](https://img.shields.io/cocoapods/p/ASMessenger.svg?style=flat)](http://cocoapods.org/pods/ASMessenger)

[PRE-RELEASE] ASMessenger is a lightweight and performant messenger interface that's easy to implement. It's ideal for customer-support type conversations, such as a discussion between an Uber driver and rider.

![alt tag](http://i.imgur.com/UbuSILm.png)

## Demo

View a [GIF](http://i.imgur.com/ZFNBA6Z.gifv) of the demo app, or try it out yourself by running `pod try ASMessenger`.

## About

`ASMessenger` was originally created to meet the needs of a specific project. Realizing that the library was versatile enough that others may find it useful, I decided to open source it.

`ASMessenger` is intended for simple use cases and is kept on a strict diet. I want to keep it as a distinctly lightweight option for when more powerful messaging libraries are an overkill. Consequently, `ASMessenger` will not support "heavier" features such as inline GIFs, videos, maps, avatar images, or extensive cell customizations.

If you need a more powerful or customizable messaging interface, I highly recommend [JSQMessagesViewController](https://github.com/jessesquires/JSQMessagesViewController).

## Features

* Easy integration
* Automagical scroll performance optimization
* Customizable color schemes
* Group-chat style name labels
* Selectable and copyable messages
* Dynamic Type support
* Data Detection
* Text input field that tightly follows keyboard through appearing, disappearing, and rotations.
* Well documented
* Nifty example app (try it! `pod try ASMessenger`)

## Planned Features

* More customizations (including fonts!)
* Automatic time stamping
* Built in support for asynchronous image loading and caching
* "Is-Typing" indicator

*Planned features are subject to change.*

## Usage

Install using [CocoaPods](http://cocoapods.org)

````ruby
pod 'ASMessenger'
````

Once you've installed `ASMessenger`, create a subclass of `ASMessengerViewController`.

Copy and paste the quick-start template below into your subclass's implementation:

```objective-c


// If you're using storyboards, override init to specify what attachment type to use.
// If you're creating the view controller programmatically, this isn't necessary.
- (instancetype)init{

  return [super initWithAttachmentType:ASAttachmentButtonTypePlus];
}

- (void)viewDidLoad{

  [super viewDidLoad];
  [self addInitialEntries];
}

// This is just an example! Replace this with however you would like to add your initial set of entries (if there are any).
- (void)addInitialEntries{

  NSArray * exampleEntryArray = @[[ASEntry messageEntryWithAlignment:ASEntryAlignmentRight name:@"Johnny Appleseed" message:@"Hello!"],
                                  [ASEntry messageEntryWithAlignment:ASEntryAlignmentLeft name:@"Bobby Someone" message:@"Hey, what's up?"],
                                  [ASEntry messageEntryWithAlignment:ASEntryAlignmentRight name:@"Johnny Appleseed" message:@"Not much!"],
                                  [ASEntry attachmentEntryWithAlignment:ASEntryAlignmentLeft name:@"Bobby Someone" title:@"Movie Tickets" subtitle:@"PDF Attachment" attachmentInfo:nil]
                                  ];

  [self setEntriesAndRefresh:exampleEntryArray];
}

#pragma mark - Event Handling Overrides

- (void)sendButtonPressedWithMessage:(NSString *)message{

  // No need to call super, the default implementation does nothing.

  [self clearTextInputView]; // call BEFORE adding a new entry.

  [self addNewEntry:[ASEntry messageEntryWithAlignment:ASEntryAlignmentRight name:@"Johnny Appleseed" message:message]];
}

- (void)attachmentButtonPressed{

  // No need to call super, the default implementation does nothing.

  NSLog(@"attachment button was pressed!");
}

- (void)entrySelected:(ASEntry*)entry{

  // No need to call super, the default implementation does nothing.

  NSLog(@"entry was selected!");
}


```

Boom, that's it! You're up and running with `ASMessenger`!

Next Steps:

- See the `ASEntry` header to see the different ways you can create `ASEntry`s.
- Manage what entries are shown by using the entry management methods built into `ASMessengerViewController` (see the header).
- Add custom event handling in the methods under the "Event Handling Overrides" pragma mark.

**IMPORTANT: Do not directly set or modify the `self.entries` array. It will cause unexpected behavior.**

## Requirements

* iOS 8.0 +
* ARC

## Credits

`ASMessenger` is written and maintained by [Amit Sharma](https://github.com/asharma-atx).

## License

ASMessenger is available under the MIT license. See the LICENSE file for more info.
