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

- (void)populateCellWithMovie:(Movie *)movie {
    [self.movieTitleLabel setText:movie.title];
    [self.movieOverviewLabel setText:movie.overview];
    
    NSMutableAttributedString* rating = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.1f",[movie.voteAverage doubleValue]]];
    
    NSTextAttachment* rating_symbol = [NSTextAttachment textAttachmentWithImage:[UIImage systemImageNamed:@"star"]];
    NSAttributedString* rating_symbol_str = [NSAttributedString attributedStringWithAttachment:rating_symbol];
    [rating replaceCharactersInRange:NSMakeRange(0, 0) withAttributedString:rating_symbol_str];
    
    [self.movieRatingLabel setAttributedText:rating];
    
    if (movie.poster != nil) {
        [self.movieImageView setImage:[UIImage imageWithData:movie.poster]];
    } else if ([movie.posterPath.absoluteString isEqualToString:@""]) {
        [self.movieImageView setImage:[UIImage systemImageNamed:@"camera.fill"]];
    } else {
        NSURLSessionDownloadTask* poster_download = [[NSURLSession sharedSession] downloadTaskWithURL:movie.posterPath completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
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

