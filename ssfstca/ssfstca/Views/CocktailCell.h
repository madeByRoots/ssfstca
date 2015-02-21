//
//  CocktailCell.h
//  ssfstca
//  Copyright (c) 2015 madeByRoots. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CocktailObject.h"

@interface CocktailCell : UITableViewCell
@property (weak, nonatomic, readonly) UILabel *nameLabel;
@property (weak, nonatomic, readonly) UILabel *identifier;


+ (NSString *)reuseIdentifier;

- (void)configureWithDataObject:(CocktailObject *)dataObject;

@end
