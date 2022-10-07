//
// Created by 刘科 on 2022/10/6.
//

#import <Foundation/Foundation.h>


@interface MacOpenPanel : NSObject

@property (nonatomic,copy) NSString *prompt;
@property (nonatomic,assign) BOOL allowsMultipleSelection;
@property (nonatomic,assign) BOOL canChooseDirectories;
@property (nonatomic,assign) BOOL canChooseFiles;
@property (nonatomic,assign) BOOL resolvesAliases;
@property (nonatomic,assign) BOOL accessoryViewDisclosed;

@property (nonatomic) NSArray *allowedFileTypes;

- (void)showPanelWithChosenFilesHandler:(nullable void(^)(NSArray<NSURL*>* _Nullable fileURLs))saveDataHandler;

@end