#import "TextResponseSerializer.h"

static BOOL AFErrorOrUnderlyingErrorHasCodeInDomain(NSError *error, NSInteger code, NSString *domain) {
    if ([error.domain isEqualToString:domain] && error.code == code) {
        return YES;
    } else if (error.userInfo[NSUnderlyingErrorKey]) {
        return AFErrorOrUnderlyingErrorHasCodeInDomain(error.userInfo[NSUnderlyingErrorKey], code, domain);
    }

    return NO;
}

@implementation TextResponseSerializer

+ (instancetype)serializer:(NSDictionary *)headers {
    TextResponseSerializer *serializer = [[self alloc] init: headers];
    return serializer;
}

- (instancetype)init:(NSDictionary *)headers {
    self = [super init];
    if (!self) {
        return nil;
    }

    self.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"text/html", @"text/json", @"application/json", @"text/xml", @"application/xml", @"text/css", nil];

    if ([headers objectForKey:@"Accept"]) {
        NSString *acceptHeader = [headers valueForKeyPath:@"Accept"];
        acceptHeader = [acceptHeader stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSArray *acceptHeaderList = [acceptHeader componentsSeparatedByString:@","];
        self.acceptableContentTypes = [self.acceptableContentTypes setByAddingObjectsFromArray:acceptHeaderList];
    }

    return self;
}

#pragma mark - AFURLResponseSerialization

- (id)responseObjectForResponse:(NSURLResponse *)response
                           data:(NSData *)data
                          error:(NSError *__autoreleasing *)error
{
    if (![self validateResponse:(NSHTTPURLResponse *)response data:data error:error]) {
        if (!error || AFErrorOrUnderlyingErrorHasCodeInDomain(*error, NSURLErrorCannotDecodeContentData, AFURLResponseSerializationErrorDomain)) {
            return nil;
        }
    }

    // Workaround for behavior of Rails to return a single space for `head :ok` (a workaround for a bug in Safari), which is not interpreted as valid input by NSJSONSerialization.
    // See https://github.com/rails/rails/issues/1742
    NSStringEncoding stringEncoding = self.stringEncoding;
    if (response.textEncodingName) {
        CFStringEncoding encoding = CFStringConvertIANACharSetNameToEncoding((CFStringRef)response.textEncodingName);
        if (encoding != kCFStringEncodingInvalidId) {
            stringEncoding = CFStringConvertEncodingToNSStringEncoding(encoding);
        }
    }

    NSString *responseString = [[NSString alloc] initWithData:data encoding:stringEncoding];

    return responseString;
}

@end