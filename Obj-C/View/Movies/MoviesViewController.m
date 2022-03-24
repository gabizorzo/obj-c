//
//  ViewController.m
//  Obj-C
//
//  Created by Gabriela Zorzo on 21/03/22.
//

#import "MoviesViewController.h"
#import "MovieAPI.h"
#import "MovieAPIDelegate.h"
#import "Parser.h"
#import "Movie.h"
#import "MoviesTableViewCell.h"
#import "DetailsViewController.h"

@interface MoviesViewController ()
<MovieAPIDelegate, UITableViewDelegate, UITableViewDataSource>

@property MovieAPI* movieAPI;
@property NSArray* popularMoviesList;
@property NSArray* nowPlayingMoviesList;

@property (weak, nonatomic) IBOutlet UITableView *moviesTableView;

@end

@implementation MoviesViewController

// MARK: - View did load
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.movieAPI = [[MovieAPI alloc] init];
    self.movieAPI.delegate = self;
    [self.movieAPI fetchMovieList:FetchPopular];
    [self.movieAPI fetchMovieList:FetchNowPlaying];
    
    self.moviesTableView.delegate = self;
    self.moviesTableView.dataSource = self;
}

// MARK: - Prepare for Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    DetailsViewController* detailsVC = [segue destinationViewController];
    
    if (detailsVC != nil && [sender isKindOfClass:[Movie class]]) {
        [detailsVC loadViewIfNeeded];
        detailsVC.movie = sender;
    }
}

// MARK: - Fetched Failed with Error
/* From MovieAPIDelegate */
- (void)fetchedFailedWithError:(nonnull NSError *)error {
    NSLog(@"-XXX- FETCH FAILED");
    NSLog(@"%@", error.localizedDescription);
}

// MARK: - Received Movie List
/* From MovieAPIDelegate */
- (void)receivedMovieList:(nonnull NSData *)json from:(FetchOption) option {
    NSLog(@"%@", json.description);
    
    NSError* error = nil;
    NSArray* movies = [Parser movieListFromJSON:json error:&error];
    
    if (error) {
        NSLog(@"-XXX- PARSE ERROR");
        NSLog(@"%@", error.localizedDescription);
        return;
    }
    
    switch (option) {
        case FetchPopular:
            NSLog(@"-VVV- FETCH POPULAR SUCCESS");
            self.popularMoviesList = movies;
            break;
            
        case FetchNowPlaying:
            NSLog(@"-VVV- FETCH NOW PLAYING SUCCESS");
            self.nowPlayingMoviesList = movies;
            break;
            
        default:
            NSLog(@"-!!!- UNSUPPORTED FETCH OPTION");
            break;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.moviesTableView reloadData];
    });
}

// MARK: - Received Movie Details
/* From MovieAPIDelegate */
- (void)receivedMovieDetails:(nonnull NSData *)json for:(nonnull Movie *)movie {
    NSError* error = nil;
    
    [Parser detailsForMovie:movie from:json error:&error];
    
    if (error != nil) {
        NSLog(@"-XXX- FETCH DETAILS ERROR");
        NSLog(@"%@", error.localizedDescription);
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self performSegueWithIdentifier:@"DetailNavigation" sender:movie];
    });
}

// MARK: - Cell for row at
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    MoviesTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell"];
    
    if (cell == nil) {
        return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"default"];
    }
    
    Movie* movie;
    
    switch (indexPath.section) {
        case 0:
            movie = self.popularMoviesList[indexPath.row];
            break;
            
        default:
            movie = self.nowPlayingMoviesList[indexPath.row];
            break;
    }
    
    if (movie != nil) {
        [cell populateCellWithMovie:movie];
    }
    
    return cell;
}

// MARK: -  Height for row at
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 148;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            NSLog(@"-!!!- SECTION: POPULAR --- COUNT: %d", (int)self.popularMoviesList.count);
            return 2;
            break;
            
        default:
            NSLog(@"-!!!- SECTION: NOW PLAYING --- COUNT: %d", (int)self.nowPlayingMoviesList.count);
            return self.nowPlayingMoviesList.count;
            break;
    }
}

// MARK: - Did select row at
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Movie* movie;
    
    switch (indexPath.section) {
        case 0:
            movie = self.popularMoviesList[indexPath.row];
            break;
            
        default:
            movie = self.nowPlayingMoviesList[indexPath.row];
            break;
    }
    
    if (movie != nil) {
        if (movie.genres == nil) {
            [self.movieAPI fetchMovieDetails:movie];
        } else {
            [self performSegueWithIdentifier:@"DetailNavigation" sender:movie];
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

// MARK: - Number os sections
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

// MARK: - Height for header
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 22;
}

// MARK: - View for header
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView* header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 22)];
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, tableView.frame.size.width, 22)];
    
    [label setFont:[UIFont systemFontOfSize:17 weight:UIFontWeightSemibold]];
    
    switch (section) {
        case 0:
            NSLog(@"-!!!- SECTION: POPULAR");
            [label setText:@"Popular movies"];
            break;
            
        default:
            NSLog(@"-!!!- SECTION: NOW PLAYING");
            [label setText:@"Now playing"];
            break;
    }
    
    [header addSubview:label];
    
    return header;
}

@end
