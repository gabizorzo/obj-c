//
//  NSObject+MoviesTableViewCell.h
//  Obj-C
//
//  Created by Gabriela Zorzo on 22/03/22.
//

#import <UIKit/UIKit.h>
#import "Movie.h"

NS_ASSUME_NONNULL_BEGIN

@interface MoviesTableViewCell: UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *movieImageView;
@property (weak, nonatomic) IBOutlet UILabel *movieTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *movieOverviewLabel;
@property (weak, nonatomic) IBOutlet UILabel *movieRatingLabel;

-(void)populateCellWithMovie:(Movie*) movie;

@end

NS_ASSUME_NONNULL_END
