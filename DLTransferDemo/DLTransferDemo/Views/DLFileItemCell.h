//
//  DLFileItemCell.h
//  wifiDemo
//
//  Created by jamelee on 2021/3/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DLFileItemCell : UITableViewCell

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *typeImvWHRate;
@property (weak, nonatomic) IBOutlet UIImageView *typeImv;
@property (weak, nonatomic) IBOutlet UILabel *fileLabel;
@property (weak, nonatomic) IBOutlet UIImageView *moreArrow;

@end

NS_ASSUME_NONNULL_END
