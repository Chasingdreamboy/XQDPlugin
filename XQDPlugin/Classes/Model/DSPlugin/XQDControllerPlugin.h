
#import "XQDBasePlugin.h"

@interface XQDControllerPlugin : XQDBasePlugin {
    // Member variables go here.
}

- (void)push:(NSDictionary*)command;
- (void)pop:(NSDictionary*)command;
- (void)popTo:(NSDictionary*)command;
- (void)exit:(NSDictionary*)command;
- (void)logout:(NSIndexPath*)command;

@end
