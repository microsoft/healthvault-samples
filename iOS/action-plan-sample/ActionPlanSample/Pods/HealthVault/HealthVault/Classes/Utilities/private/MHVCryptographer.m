//
//  MHVCryptographer.m
//  MHVLib
//
// Copyright 2017 Microsoft Corp.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
//

#import "MHVCryptographer.h"
#import <CommonCrypto/CommonHMAC.h>

@implementation MHVCryptographer

- (NSString *)computeSha256Hash: (NSString *)data
{
    const char *chars = [data cStringUsingEncoding: NSUTF8StringEncoding];
    NSData *keyData = [NSData dataWithBytes: chars length: [data lengthOfBytesUsingEncoding:NSUTF8StringEncoding]];
    
    uint8_t digest[CC_SHA256_DIGEST_LENGTH] = {0};
    CC_SHA256(keyData.bytes, (uint)keyData.length, digest);
    
    NSString *base64String = [[NSData dataWithBytes:digest length:CC_SHA256_DIGEST_LENGTH] base64EncodedStringWithOptions:kNilOptions];
    
    return base64String;
}

- (NSString *)computeSha256Hmac: (NSData *)key data:(NSString *)data
{
    NSUInteger len = [key length];
    char *cKey = (char *)[key bytes];
    
    const char *cData = [data cStringUsingEncoding: NSUTF8StringEncoding];
    
    unsigned char cHMAC[CC_SHA256_DIGEST_LENGTH];
    
    CCHmac(kCCHmacAlgSHA256, cKey, len, cData, [data lengthOfBytesUsingEncoding:NSUTF8StringEncoding], cHMAC);
    
    NSData *hmac = [[NSData alloc] initWithBytes: cHMAC length: sizeof(cHMAC)];
    
    NSString *base64String = [hmac base64EncodedStringWithOptions:kNilOptions];
    
    return base64String;
}

@end
