//
//  NSObject+DetailsTableViewCell.h
//  Obj-C
//
//  Created by Gabriela Zorzo on 22/03/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class Movie;
@interface DetailsTableViewCell: UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *detailImageView;
@property (weak, nonatomic) IBOutlet UILabel *detailTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailGenresLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailRatingsLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailOverviewLabel;

-(void)populateCellWithMovie:(Movie*) movie;

@end

NS_ASSUME_NONNULL_END
