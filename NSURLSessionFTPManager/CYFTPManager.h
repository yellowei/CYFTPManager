//
//  CYFTPManager.h
//  CYFTPManager
//
//  Created by yellowei on 16/5/31.
//  Copyright © 2018年 . All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CYFTPManagerDelegate <NSObject>

- (void)uploadDataWithSuccess:(BOOL)success;

- (void)downloadDataWithSuccess:(BOOL)success;

- (void)directoryListingSuccess:(BOOL)success fileNames:(NSArray *)fileNames;

- (void)ftpError:(NSString *)error;

@end

@interface CYFTPManager : NSObject

- (instancetype)initWithServer:(NSString *)server userName:(NSString *)userName password:(NSString *)password;

- (void)downloadRemoteFile:(NSString *)fileName localFileName:(NSString *)localFileName;

- (void)uploadFileWithFilePath:(NSString *)fileName;

- (void)createRemoteDirectory:(NSString *)dirName;

- (void)listRemoteDirectory;

- (void)gotoNextFile:(NSString *)fileName;

@property (nonatomic, assign) id<CYFTPManagerDelegate> delegate;

@end
