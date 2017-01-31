#import <Foundation/Foundation.h>
#import "AFURLResponseSerialization.h"

@interface TextResponseSerializer : AFHTTPResponseSerializer

+ (instancetype)serializer:(NSDictionary*)headers;

@end