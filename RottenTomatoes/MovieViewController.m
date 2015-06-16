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
#import <MRProgress/MRProgress.h>


@interface MovieViewController () < UITableViewDataSource, UITableViewDelegate >

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *movies;
@property (strong, nonatomic) UILabel *errorLabel;
@end

@implementation MovieViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    //[self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"MyMovieCell"];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    //api for search
    //http://api.rottentomatoes.com/api/public/v1.0/movies.json?apikey=dagqdghwaq3e3mxyrp7kmmj5&q=Spy&page_limit=1
    
    //NSString *url = @"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?apikey=dagqdghwaq3e3mxyrp7kmmj5&limit=50&country=tw";
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];

    if (self.errorLabel == nil) {
        self.errorLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
        self.errorLabel.backgroundColor=[UIColor grayColor];
        self.errorLabel.text = @" Network Error!";
        self.errorLabel.textAlignment = NSTextAlignmentCenter;
    }
    [self.tableView addSubview:self.errorLabel];

    
    self.queryApi;
    NSLog(@"Init Query...");

}


-(void) queryApi {
    
    NSString *url = @"http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/top_rentals.json?apikey=dagqdghwaq3e3mxyrp7kmmj5&limit=50&country=tw";
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    [MRProgressOverlayView showOverlayAddedTo:self.tableView animated:YES];

    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
        int code = [httpResponse statusCode];
        if (code!=200){
            NSLog(@"Connection Error");
            self.errorLabel.hidden = NO;
        }
        else {
            NSLog(@"Connection Well");
            self.errorLabel.hidden = YES;
            
            NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            self.movies = dict[@"movies"];
            [self.tableView reloadData];
        }
        [MRProgressOverlayView dismissOverlayForView:self.tableView animated:YES];

        //[self.tableView insertSubview:refreshControl atIndex:0];
        
    }];
}



- (void)refresh:(UIRefreshControl *)refreshControl {
    //- no use [refreshControl beginRefreshing];

    self.queryApi;
    NSLog(@"more Query...");
    [refreshControl endRefreshing];
    //refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Loading..."];
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
