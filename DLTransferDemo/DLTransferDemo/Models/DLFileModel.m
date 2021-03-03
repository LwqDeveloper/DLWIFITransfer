//
//  DLFileModel.m
//  wifiDemo
//
//  Created by jamelee on 2021/3/3.
//

#import "DLFileModel.h"

@implementation DLFileModel

- (void)setFileSuffix:(NSString *)fileSuffix {
    _fileSuffix = fileSuffix;
    
    _fileWHRate = 1;
    _fileType = 5;
    if (fileSuffix.length > 0) {
        if ([fileSuffix isEqualToString:@"docx"] ||
            [fileSuffix isEqualToString:@"doc"] ||
            [fileSuffix isEqualToString:@"wps"] ) {
            _fileImageName = @"icon_word";
        } else if([fileSuffix isEqualToString:@"png"] ||
                  [fileSuffix isEqualToString:@"jpeg"] ||
                  [fileSuffix isEqualToString:@"jpg"]){
            _fileImageName = @"con_img_vertical";
            _fileWHRate = 120.0 /180.0;
            _fileType = 1;
        } else if([fileSuffix isEqualToString:@"excel"] ||
                  [fileSuffix isEqualToString:@"xlsx"]){
            _fileImageName = @"icon_excel";
        } else if([fileSuffix isEqualToString:@"ppt"] ||
                  [fileSuffix isEqualToString:@"pptx"]){
            _fileImageName = @"icon_ppt";
        } else if([fileSuffix isEqualToString:@"pdf"]) {
            _fileImageName = @"icon_pdf";
        } else if([fileSuffix isEqualToString:@"txt"]) {
            _fileImageName = @"icon_txt";
        } else {
            _fileImageName = @"icon_unknown";
        }
    } else {
        _fileImageName = @"icon_folder";
        _fileType = 0;
    }
}

- (NSString *)filePath {
    if (_fileType == 0) {
        _filePath = [[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:_fileFolder] stringByAppendingPathComponent:_fileName];
    } else {
        _filePath = [[[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:_fileFolder] stringByAppendingPathComponent:_fileName] stringByAppendingFormat:@".%@", _fileSuffix];
    }
    return _filePath;
}

+ (DLFileModel *)modelWithFileFolder:(NSString *)folder name:(NSString *)name {
    DLFileModel *model = [[DLFileModel alloc] init];
    model.fileFolder = folder;
    NSArray *names = [name componentsSeparatedByString:@"."];
    if (names.count > 1) {
        NSMutableArray *muNames = [NSMutableArray arrayWithArray:names];
        [muNames removeLastObject];
        model.fileName = [muNames componentsJoinedByString:@"."];
        model.fileSuffix = names.lastObject;
    } else if (names.count == 1) {
        model.fileName = names.firstObject;
        model.fileSuffix = @"";
    }
    return model;
}

@end
