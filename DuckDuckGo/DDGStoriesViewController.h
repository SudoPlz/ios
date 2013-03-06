//
//  DDGStoriesViewController.h
//  DuckDuckGo
//
//  Created by Johnnie Walker on 06/03/2013.
//
//

#import <UIKit/UIKit.h>

#import "DDGSearchHandler.h"
#import "DDGSearchController.h"
#import "EGORefreshTableHeaderView.h"

@interface DDGStoriesViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, DDGSearchHandler, EGORefreshTableHeaderDelegate, UIScrollViewDelegate>
@property (nonatomic, strong) DDGSearchController *searchController;
@end
