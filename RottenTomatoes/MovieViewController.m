//
//  MovieViewController.m
//  RottenTomatoes
//
//  Created by Ufohead Tseng on 2015/6/13.
//  Copyright (c) 2015年 Ufohead Tseng. All rights reserved.
//

#import "MovieViewController.h"
#import "MovieCell.h"
#import "ViewController.h"
#import <UIImageView+AFNetworking.h>

@interface MovieViewController () < UITableViewDataSource, UITableViewDelegate >

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *movies;


@end

@implementation MovieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    //[self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"MyMovieCell"];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    
    NSString *url = @"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?apikey=dagqdghwaq3e3mxyrp7kmmj5&limit=20&country=us";
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        self.movies = dict[@"movies"];
        [self.tableView reloadData];
        //NSArray * movies = dict[@"movies"];
        //NSDictionary * firstMovie = movies[0];
        //NSLog(@"%@", firstMovie);
        //NSLog(@"%@", object);
    }];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.movies.count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    
    //tableView dequeueReusableCellWithIdentifier:@"MyMovieCell" forIndexPath:indexPath;
//    cell.tableView.text = [NSString stringWithFormat:@"Raw %ld", (long)indexPath.row];
    
    
    MovieCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MyMovieCell" forIndexPath:indexPath];
    
    NSDictionary * movie = self.movies[indexPath.row];
    cell.titleLabel.text = movie[@"title"];
    cell.synopsisLabel.text = movie[@"synopsis"];
    NSString *posterURLString = [movie valueForKeyPath:@"posters.thumbnail"];
    //posterURLString = [self convertPosterUrlStringToHighRes:posterURLString];
    [cell.posterView setImageWithURL:[NSURL URLWithString:posterURLString]];
    //NSLog(@"%@",posterURLString);
    
    //NSString * title = movie[@"title"];
    //cell.textLabel.text = title;

    //UITableViewCell * cell = [[UITableViewCell alloc] init];
    //cell.textLabel.text = [NSString stringWithFormat:@"Raw %ld", (long)indexPath.row];
    //NSLog(@"Raw %ld",(long)indexPath.row);
    return cell;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    MovieCell * cell = sender;
    NSIndexPath *indexPath =  [self.tableView indexPathForCell:cell];
    NSDictionary * movie = self.movies[indexPath.row];

    
    
    ViewController *destinationVC = segue.destinationViewController;
    destinationVC.movie = movie;
    


}


- (NSString *) convertPosterUrlStringToHighRes:(NSString *)urlString {
    NSRange range = [urlString rangeOfString:@".*cloudfront.net/" options:NSRegularExpressionSearch];
    NSString *returnValue = urlString;
    if (range.length > 0) {
        returnValue = [urlString stringByReplacingCharactersInRange:range withString:@"https://content6.flixster.com/"];
    }
    return returnValue;
}


@end
