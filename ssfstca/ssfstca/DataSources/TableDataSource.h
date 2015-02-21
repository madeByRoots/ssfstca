//
//  DataSource.h
//  ssfstca
//  Copyright (c) 2015 madeByRoots. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^TableViewCellConfigureBlock)(id cell, id item);

@interface TableDataSource : NSObject <UITableViewDataSource>
@property (weak, nonatomic, readonly) UITableView *tableView;

- (instancetype)initWithTableView:(UITableView *)tableView
                             cellIdentifier:(NSString *)cellIdentifier
                    configureCellBlock:(TableViewCellConfigureBlock)configureCellBlock;


- (void)loadContent;

@end
