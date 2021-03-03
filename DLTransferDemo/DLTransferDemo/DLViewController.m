//
//  DLViewController.m
//  wifiDemo
//
//  Created by jamelee on 2021/3/1.
//

#import "DLViewController.h"
#import <GCDWebServer/GCDWebUploader.h>
#import "IPHelper.h"
#import <Masonry/Masonry.h>
#import "DLFileItemCell.h"
#import "DLFileModel.h"

@interface DLViewController ()<GCDWebUploaderDelegate, UITableViewDelegate, UITableViewDataSource>

/// datas
@property (nonatomic, strong) NSMutableArray *datas;
/// tab
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation DLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //去除返回文字
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] init];
    
    self.datas = [NSMutableArray array];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"DLFileItemCell" bundle:nil] forCellReuseIdentifier:@"DLFileItemCell"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    if (self.filePath.length == 0) {
        [self initUplaoder];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self checkLocalFiles];
}

- (void)checkLocalFiles {
    NSString *path = self.filePath;
    if (path.length == 0) {
        path = [self getFileHolderPath];
    }
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
    
    [self.datas removeAllObjects];
    for (NSString *fileName in files) {
        DLFileModel *model = [DLFileModel modelWithFileFolder:@"transer" name:fileName];
        [self.datas addObject:model];
    }
    [self.tableView reloadData];
}

#pragma mark - tableView
#pragma mark - tableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DLFileModel *model = self.datas[indexPath.row];
    if (model.fileType == 0) {
        DLViewController *vc = [[DLViewController alloc] init];
        vc.title = model.fileName;
        vc.filePath = model.filePath;
        [self.navigationController pushViewController:vc animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - tableView datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DLFileItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DLFileItemCell"];
    DLFileModel *model = self.datas[indexPath.row];
    if (model.fileType == 1) {
        UIImage *image = [UIImage imageWithContentsOfFile:model.filePath];
        cell.typeImv.image = image;
        cell.typeImvWHRate.constant = image.size.width /image.size.height;
    } else {
        cell.typeImvWHRate.constant = 1;
        cell.typeImv.image = [UIImage imageNamed:model.fileImageName];
    }
    cell.fileLabel.text = model.fileName;
    cell.moreArrow.hidden = model.fileType > 0;

    return cell;
}


- (void)initUplaoder {
    NSString *filePath = [self getFileHolderPath];
    
    NSLog(@"filePath:%@",filePath);
    GCDWebUploader *server = [[GCDWebUploader alloc] initWithUploadDirectory:filePath];
    server.delegate = self;
    server.allowHiddenItems = YES;
    server.allowedFileExtensions = @[@"doc", @"docx", @"xls", @"xlsx", @"txt", @"pdf", @"png", @"jpeg", @"jpg", @"mp3", @"mp4"];
    server.title = @"传输工具";
    server.prologue = @"WIFI管理工具";
    server.epilogue = @"copy right by muyang";
    NSString *address = [IPHelper deviceIPAdress];
    BOOL ret = [server start];
//    NSUInteger port = server.port;
    // 1.确保设备在同一局域网
    // 2.上传时勿关闭该页面
    // 3.请网页中输入该地址 \nhttp://\(address):\(port)/
    if (ret && address.length > 0) {
        self.title = [NSString stringWithFormat:@"http://%@", address];
    } else {
        self.title = @"Not Running!";
    }
}

#pragma mark - delegate
/**
 *  This method is called whenever a file has been downloaded.
 */
- (void)webUploader:(GCDWebUploader*)uploader didDownloadFileAtPath:(NSString*)path {
    [self checkLocalFiles];
}

/**
 *  This method is called whenever a file has been uploaded.
 */
- (void)webUploader:(GCDWebUploader*)uploader didUploadFileAtPath:(NSString*)path {
    [self checkLocalFiles];
}

/**
 *  This method is called whenever a file or directory has been moved.
 */
- (void)webUploader:(GCDWebUploader*)uploader didMoveItemFromPath:(NSString*)fromPath toPath:(NSString*)toPath {
    [self checkLocalFiles];
}

/**
 *  This method is called whenever a file or directory has been deleted.
 */
- (void)webUploader:(GCDWebUploader*)uploader didDeleteItemAtPath:(NSString*)path {
    [self checkLocalFiles];
}

/**
 *  This method is called whenever a directory has been created.
 */
- (void)webUploader:(GCDWebUploader*)uploader didCreateDirectoryAtPath:(NSString*)path {
    [self checkLocalFiles];
}

#pragma mark - 获取路径
- (NSString *)getFileHolderPath {
    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/transer"];
    BOOL isDirectory = NO;
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDirectory];
    if (!(isDirectory && isExist)) {
        [[NSFileManager defaultManager] createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return filePath;
}

@end
