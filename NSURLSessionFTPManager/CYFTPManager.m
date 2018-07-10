//
//  CYFTPManager.m
//  CYFTPManager
//
//  Created by yellowei on 16/5/31.
//  Copyright © 2018年 . All rights reserved.
//

#import "CYFTPManager.h"
#import <CFNetwork/CFNetwork.h>

@interface CYFTPManager () <NSURLSessionDelegate, NSURLSessionTaskDelegate>

@property (nonatomic, copy)NSString *ftpServer;

@property (nonatomic, copy)NSString *ftpUserName;

@property (nonatomic, copy)NSString *ftpPassword;

@property (nonatomic, strong) NSURLSession *session;

@property (nonatomic, copy) NSString *url;

@end

@implementation CYFTPManager

- (instancetype)initWithServer:(NSString *)server userName:(NSString *)userName password:(NSString *)password{
    if (self = [super init]) {
        self.ftpServer = server;
        self.ftpUserName = userName;
        self.ftpPassword = password;
        
        [self setupSession];
        
        
    }
    return self;
}

- (void)setupSession{
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    _session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
}

- (void)listRemoteDirectory{
    NSString *ftpUrl = [NSString stringWithFormat:@"ftp://%@:%@@%@", self.ftpUserName, self.ftpPassword, self.ftpServer];
    [self setSessionTaskWithUrl:ftpUrl];
}


- (void)gotoNextFile:(NSString *)fileName{
//    NSString *url = [_url stringByAppendingPathComponent:fileName];
    NSString * url = [_url stringByAppendingString:[NSString stringWithFormat:@"/%@", fileName]];
    [self setSessionTaskWithUrl:url];
}

- (void)setSessionTaskWithUrl:(NSString *)urlString{
    _url = urlString;
    NSURLSessionTask *task = [_session dataTaskWithURL:[NSURL URLWithString:_url] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@", [error localizedDescription]);
            return ;
        }
        NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding                (kCFStringEncodingGB_18030_2000);
        
        NSString *result = [[NSString alloc] initWithData:data encoding:gbkEncoding];
        NSArray *array = [result componentsSeparatedByString:@"\n"];
        NSLog(@"array = %@", array);
        NSMutableArray *locations = [NSMutableArray array];
        NSArray *checkStrings = @[@"  ", @" ", @"  ", @"  ", @" ", @" ", @" ", @" "];
        NSInteger fileIndex = 0;
        if (array.count > 2){
            NSString *lineString = [NSString stringWithString:array[1]];
            NSRange range = NSMakeRange(0, 0);
            NSInteger spaceIndex = 0;
            while (range.location != NSNotFound) {
                range = [lineString rangeOfString:checkStrings[locations.count] options:NSCaseInsensitiveSearch range:NSMakeRange(spaceIndex, lineString.length-spaceIndex)];
                for (NSInteger i=range.location+range.length; i<lineString.length; i++) {
                    NSString *character = [NSString stringWithFormat:@"%C", [lineString characterAtIndex:i]];
                    if (![character isEqualToString:@" "]) {
                        spaceIndex = i;
                        break;
                    }
                }
                [locations addObject:@(range.location)];
                if (locations.count >= checkStrings.count) {
                    break;
                }
            }
            fileIndex = spaceIndex;
        }
        NSMutableArray *resultArray = [NSMutableArray array];
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx==0 || idx==array.count-1) {
            } else {
                NSString *lineString = obj;
                NSString* headerData = [lineString substringFromIndex:fileIndex];
                headerData = [headerData stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  //去除掉首尾的空白字符和换行字符
                headerData = [headerData stringByReplacingOccurrencesOfString:@"\r" withString:@""];
                headerData = [headerData stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                [resultArray addObject:headerData];
            }
        }];
        if (self.delegate && [self.delegate respondsToSelector:@selector(directoryListingSuccess:fileNames:)]) {
            [self.delegate directoryListingSuccess:YES fileNames:resultArray];
        }
    }];
    [task resume];
}


//#pragma mark - NSURLSessionDelegate
//- (void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(NSError *)error{
//    
//}
//
//- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler{
//    
//    
//}
//
//
//- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session{
//    
//}
//
//#pragma mark - NSURLSessionTaskDelegate
//- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task willPerformHTTPRedirection:(NSHTTPURLResponse *)response newRequest:(NSURLRequest *)request completionHandler:(void (^)(NSURLRequest * __nullable))completionHandler {
//    completionHandler(request);
//}
//
//
//- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * __nullable credential))completionHandler{
//    
//}
//
///* Sent if a task requires a new, unopened body stream.  This may be
// * necessary when authentication has failed for any request that
// * involves a body stream.
// */
//- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
// needNewBodyStream:(void (^)(NSInputStream * __nullable bodyStream))completionHandler{
//    
//}
//
///* Sent periodically to notify the delegate of upload progress.  This
// * information is also available as properties of the task.
// */
//- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
//   didSendBodyData:(int64_t)bytesSent
//    totalBytesSent:(int64_t)totalBytesSent
//totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend{
//    
//}
//
///* Sent as the last message related to a specific task.  Error may be
// * nil, which implies that no error occurred and this task is complete.
// */
//- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
//didCompleteWithError:(nullable NSError *)error{
//    
//}

@end








