//
//  ViewController.m
//  DictionarySearch
//
//  Created by Tà Truhoada on 8/21/15.
//  Copyright (c) 2015 Hoang Dang Trung. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, copy) NSDictionary *names;
@property (nonatomic, copy) NSArray *keys;
@property (nonatomic, copy) NSMutableArray *filteredNames;

@end

@implementation ViewController
@synthesize names, keys, filteredNames;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    filteredNames = [[NSMutableArray alloc] init];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Dictionary" ofType:@"plist"];
    names = [NSDictionary dictionaryWithContentsOfFile:path];
    keys = [[names allKeys]sortedArrayUsingSelector:@selector(compare:)];


}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (filteredNames.count > 0) {
        return 1;
    } else
    return [keys count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (filteredNames.count > 0) {
        return [filteredNames count];
    } else {
        NSString *key = keys[section];
        NSArray *keyValues = names[key];
        return [keyValues count];
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    if (filteredNames.count > 0) {
        cell.textLabel.text = [filteredNames objectAtIndex:indexPath.row];
        return cell;
    }
    else {
        NSString *key = keys[indexPath.section];
        NSArray *keyValues = names[key];
        cell.textLabel.text = keyValues[indexPath.row];
        cell.textLabel.textColor = [UIColor blueColor];
    }
    return cell;
}

- (void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [filteredNames removeAllObjects];
    if (searchText.length > 0) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self beginswith [c] %@",self.searchBar.text];
        for (NSString *key in keys) {
            NSArray *matches = [names[key]filteredArrayUsingPredicate:predicate];
            [filteredNames addObjectsFromArray:matches];
        }
    }

    [self.tableView reloadData];
    
}

- (void) searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    searchBar.text = nil;
    [filteredNames removeAllObjects];
    [self.tableView reloadData];
}

@end























