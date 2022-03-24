//
//  NSObject+MoviesTableViewCell.m
//  Obj-C
//
//  Created by Gabriela Zorzo on 22/03/22.
//

#import "MoviesTableViewCell.h"
#import "Movie.h"

@implementation MoviesTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.movieImageView.layer setCornerRadius:10];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)populateCellWithMovie:(Movie *) movie {
    [self.movieTitleLabel setText:movie.title];
    [self.movieOverviewLabel setText:movie.overview];
    
    NSMutableAttributedString* rating = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.1f",[movie.vote_average doubleValue]]];
    
    [self.movieRatingLabel setAttributedText:rating];
    
    if (movie.poster != nil) {
        [self.movieImageView setImage:[UIImage imageWithData:movie.poster]];
    } else if ([movie.poster_path.absoluteString isEqualToString:@""]) {
        [self.movieImageView setImage:[UIImage systemImageNamed:@"camera.fill"]];
    } else {
        NSURLSessionDownloadTask* poster_download = [[NSURLSession sharedSession] downloadTaskWithURL:movie.poster_path completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            [movie setPoster:[NSData dataWithContentsOfURL:location]];
            UIImage* poster = [UIImage imageWithData:movie.poster];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.movieImageView setImage:poster];
            });
        }];
        
        [poster_download resume];
    }
}

@end

