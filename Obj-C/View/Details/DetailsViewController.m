//
//  DetailsViewController.m
//  Obj-C
//
//  Created by Gabriela Zorzo on 22/03/22.
//

#import "DetailsViewController.h"
#import "DetailsTableViewCell.h"

@interface DetailsViewController ()
<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *detailsTableView;

@end

@implementation DetailsViewController

// MARK: - View did load
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.detailsTableView.delegate = self;
    self.detailsTableView.dataSource = self;
}

// MARK: - Cell for row at
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DetailsTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"DetailCell" forIndexPath:indexPath];

    if (cell == nil) {
        return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"default"];
    }
    
    [cell setMovie: self.movie];

    return cell;
}

// MARK: - Number of sections
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

@end
