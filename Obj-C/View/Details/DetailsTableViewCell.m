//
//  NSObject+DetailsTableViewCell.m
//  Obj-C
//
//  Created by Gabriela Zorzo on 22/03/22.
//

#import "DetailsTableViewCell.h"
#import "Movie.h"

@implementation DetailsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.detailImageView.layer setCornerRadius:10];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setMovie:(Movie *)movie {
    [self.detailTitleLabel setText:movie.title];
    [self.detailOverviewLabel setText:movie.overview];
    [self.detailGenresLabel setText:movie.genres];
    
    NSMutableAttributedString* rating = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.1f",[movie.voteAverage doubleValue]]];
    
    [self.detailRatingsLabel setAttributedText:rating];
    
    if (movie.poster != nil) {
        [self.detailImageView setImage:[UIImage imageWithData:movie.poster]];
    } else if ([movie.posterPath.absoluteString isEqualToString:@""]) {
        [self.detailImageView setImage:[UIImage systemImageNamed:@"camera.fill"]];
    } else {
        NSURLSessionDownloadTask* poster_download = [[NSURLSession sharedSession] downloadTaskWithURL:movie.posterPath completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            [movie setPoster:[NSData dataWithContentsOfURL:location]];
            UIImage* poster = [UIImage imageWithData:movie.poster];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.detailImageView setImage:poster];
            });
        }];
        
        [poster_download resume];
    }
}

@end
