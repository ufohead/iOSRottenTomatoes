//
//  ViewController.h
//  RottenTomatoes
//
//  Created by Ufohead Tseng on 2015/6/13.
//  Copyright (c) 2015年 Ufohead Tseng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *posterView;
@property (weak, nonatomic) IBOutlet UILabel *titleView;
@property (weak, nonatomic) IBOutlet UILabel *synopsisView;


@property (strong,nonatomic) NSDictionary *movie;

@end

