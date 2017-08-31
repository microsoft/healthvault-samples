//
//  Logger.m
//  HealthVault Mobile Library for iOS
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


#import "MHVLogger.h"

@implementation MHVLogger

+ (void)initialize
{
	
	// set up appropriate logging mechanism
	[MHVLogger setLoggingMethod];
}


+ (void)setLoggingMethod
{
	
#if (TARGET_IPHONE_SIMULATOR == 0 ) // real device
	
//	[MHVLogger redirectConsoleLogToDocumentFolder];
	
#endif
}

+ (NSString *)createNameForLogWithName:(NSString *)name
{
	
	NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString* documentsDirectory = nil;
	
	if(paths.count > 0)	{
		
		documentsDirectory = [paths objectAtIndex: 0];
	}
	else {
		
		documentsDirectory = [NSHomeDirectory() stringByAppendingFormat: @"/Documents"];
	}
	
	NSDate *date = [NSDate date];
	
	NSDateFormatter *formatter = [NSDateFormatter new];
	[formatter setDateFormat: @"yyyy'-'MM'-'dd' 'HH'.'mm'.'ss"];
	NSString *strDate = [formatter stringFromDate: date];
	
	return [NSString stringWithFormat: @"%@/appLog_%@ %@.txt", documentsDirectory, name, strDate];
}

/// Redirects stderr stream to log file in Document directory
+ (void)redirectConsoleLogToDocumentFolder
{
	
	NSString *logErrFile = [self createNameForLogWithName: @"stderr"];
	NSString *logOutFile = [self createNameForLogWithName: @"stdout"];
	
	freopen([logErrFile cStringUsingEncoding: NSASCIIStringEncoding], "a+", stderr);
	freopen([logOutFile cStringUsingEncoding: NSASCIIStringEncoding], "a+", stdout);
}

+ (void)write:(NSString *)format, ...
{
    va_list ap;
    va_start(ap, format);
    NSString *msg = [[NSString alloc] initWithFormat:format arguments:ap];
    va_end(ap);
    
    NSLog(@"%@", msg);
}

@end
