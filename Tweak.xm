#import <Foundation/Foundation.h>

@interface watched : NSObject
@end

@implementation watched

- (void)addNewItemsToPlistWithPath:(NSString *)plistPath key:(NSString *)key value:(id)value {
    NSMutableDictionary *plistDictionary = [NSMutableDictionary dictionaryWithContentsOfFile:plistPath];

    if (plistDictionary == nil) {
        NSLog(@"Failed to load plist file at path: %@", plistPath);
        return;
    }

    [plistDictionary setObject:value forKey:key];

    if (![plistDictionary writeToFile:plistPath atomically:YES]) {
        NSLog(@"Failed to write plist file at path: %@", plistPath);
    } else {
        NSLog(@"Successfully added items to plist file: %@", plistPath);
    }
}

@end

%ctor {
    //require respring to apply the tweak working.
    watched *tweak = [[watched alloc] init];

    //first file
    NSString *firstPlistPath = @"/var/mobile/Library/Preferences/com.apple.NanoRegistry.plist";
    [tweak addNewItemsToPlistWithPath:firstPlistPath key:@"minPairingCompatibilityVersion" value:@(1)];
    //maxPairingCompatibilityVersion is an inclusive upper bound on the watch's
    //internal NanoRegistry pairing-compatibility number (NOT the marketing watchOS
    //version). Reference points: 9.5.1 ~= 27, 10.3.1 ~= 35-37. Setting a high ceiling
    //(9999) covers watchOS 26 and future releases. Tested: an Apple Watch on watchOS 26
    //pairs to an iPhone on iOS 16.7 with this set. A full REBOOT (not just a respring)
    //is required so nanoregistryd re-reads the value.
    [tweak addNewItemsToPlistWithPath:firstPlistPath key:@"maxPairingCompatibilityVersion" value:@(9999)];
    [tweak addNewItemsToPlistWithPath:firstPlistPath key:@"IOS_PAIRING_EOL_MIN_PAIRING_COMPATIBILITY_VERSION_CHIPIDS" value:@""];
    [tweak addNewItemsToPlistWithPath:firstPlistPath key:@"minPairingCompatibilityVersionWithChipID" value:@(1)];

    //second file
    NSString *secondPlistPath = @"/var/mobile/Library/Preferences/com.apple.pairedsync.plist";
    //maybe the same as the 37
    [tweak addNewItemsToPlistWithPath:secondPlistPath key:@"activityTimeout" value:@(35)];
}
