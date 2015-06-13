//
//  MovieCell.h
//  RottenTomatoes
//
//  Created by Ufohead Tseng on 2015/6/13.
//  Copyright (c) 2015年 Ufohead Tseng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *posterView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *synopsisLabel;

@end
