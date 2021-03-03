//
//  DLFileModel.h
//  wifiDemo
//
//  Created by jamelee on 2021/3/3.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DLFileModel : NSObject

/// fol
@property (nonatomic, strong) NSString *fileFolder;
/// name
@property (nonatomic, strong) NSString *fileName;
/// suffix
@property (nonatomic, strong) NSString *fileSuffix;
/// type
@property (nonatomic, strong) NSString *fileImageName;
/// rate
@property (nonatomic, assign) CGFloat fileWHRate;
/// path
@property (nonatomic, strong) NSString *filePath;
/// type 0:文件夹 1:图片 2:GIF 3:语音 4:视频 5:文件
@property (nonatomic, assign) NSInteger fileType;

+ (DLFileModel *)modelWithFileFolder:(NSString *)folder name:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
