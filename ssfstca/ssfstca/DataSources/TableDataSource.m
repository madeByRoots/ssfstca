//
//  DataSource.m
//  ssfstca
//  Copyright (c) 2015 madeByRoots. All rights reserved.
//

#import "TableDataSource.h"

@interface TableDataSource()
@property (copy, nonatomic) NSString *cellIdentifier;
@property (copy, nonatomic) RSMTableViewCellConfigureBlock configureCellBlock;
@property (weak, nonatomic) UITableView *tableView;
@end

@implementation TableDataSource

#pragma mark - init

- (instancetype)initWithTableView:(UITableView *)tableView
                   cellIdentifier:(NSString *)cellIdentifier
               configureCellBlock:(RSMTableViewCellConfigureBlock)configureCellBlock
{
    NSParameterAssert(cellIdentifier);
    
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _tableView = tableView;
    _tableView.dataSource = self;
    _cellIdentifier = [cellIdentifier copy];
    _configureCellBlock = [configureCellBlock copy];
        
    return self;
}


#pragma mark - 

- (id)itemAtIndexPath:(NSIndexPath *)indexPath
{
    NSAssert(NO, @"Should be implemented by subclasses");
    return nil;
}


#pragma mark - public methods

- (void)loadContent
{
    NSAssert(NO, @"Should be implemented by subclasses");

}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier
                                                            forIndexPath:indexPath];
    
    id item = [self itemAtIndexPath:indexPath];
    self.configureCellBlock(cell, item);
    
    return cell;
}

@end
