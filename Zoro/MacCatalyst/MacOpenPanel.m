//
// Created by 刘科 on 2022/10/6.
//

#import "MacOpenPanel.h"


@interface NSOpenPanel_Catalyst : NSObject

+ (instancetype)openPanel;

@property (nonatomic) BOOL allowsMultipleSelection;
@property (nonatomic) BOOL canChooseDirectories;
@property (nonatomic) BOOL canChooseFiles;
@property (nonatomic) BOOL resolvesAliases;
@property (nonatomic) BOOL accessoryViewDisclosed;

@property (nonatomic) NSArray *allowedFileTypes;

@property (nonatomic,readonly) NSArray<NSURL *>*URLs;

- (NSInteger)runModal;

- (void)beginSheetModalForWindow:(id)sheetWindow completionHandler:(void (^)(NSInteger returnCode))handler;

@end

@implementation MacOpenPanel

- (instancetype)init
{
    self = [super init];
    if (!self) return nil;

    self.canChooseFiles = YES;
    self.resolvesAliases = YES;

    return self;
}

- (void)showPanelWithChosenFilesHandler:(void(^)(NSArray<NSURL*>*fileURLs))openDataHandler {
    if (!openDataHandler) {
        return;
    }
    NSOpenPanel_Catalyst *openPanel = [NSClassFromString(@"NSOpenPanel") openPanel];
    openPanel.allowsMultipleSelection = self.allowsMultipleSelection;
    openPanel.canChooseDirectories = self.canChooseDirectories;
    openPanel.canChooseFiles = self.canChooseFiles;
    openPanel.resolvesAliases = self.resolvesAliases;
    openPanel.accessoryViewDisclosed = self.accessoryViewDisclosed;
    [openPanel setAllowedFileTypes:self.allowedFileTypes];

    id app = [NSClassFromString(@"NSApplication") performSelector:@selector(sharedApplication)];
    id keyWindow = [app performSelector:@selector(keyWindow)];
    if (!keyWindow) return;

    __weak typeof(openPanel) weakOpenPanel = openPanel;
    [openPanel beginSheetModalForWindow:keyWindow completionHandler:^(NSInteger returnCode) {
        if (returnCode == 0) {
            //取消
            openDataHandler(nil);
        } else if (returnCode == 1) {
            //确诊
            openDataHandler(weakOpenPanel.URLs);
        }
    }];
}

@end