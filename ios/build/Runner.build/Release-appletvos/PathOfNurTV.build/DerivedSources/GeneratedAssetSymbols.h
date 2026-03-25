#import <Foundation/Foundation.h>

#if __has_attribute(swift_private)
#define AC_SWIFT_PRIVATE __attribute__((swift_private))
#else
#define AC_SWIFT_PRIVATE
#endif

/// The resource bundle ID.
static NSString * const ACBundleID AC_SWIFT_PRIVATE = @"com.shahab.pathOfNur.tv";

/// The "AccentColor" asset catalog color resource.
static NSString * const ACColorNameAccentColor AC_SWIFT_PRIVATE = @"AccentColor";

/// The "TopShelf" asset catalog image resource.
static NSString * const ACImageNameTopShelf AC_SWIFT_PRIVATE = @"TopShelf";

#undef AC_SWIFT_PRIVATE
