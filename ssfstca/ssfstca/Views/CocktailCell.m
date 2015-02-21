//
//  CocktailCell.m
//  ssfstca
//  Copyright (c) 2015 madeByRoots. All rights reserved.
//

#import "CocktailCell.h"

@interface CocktailCell()
@property (weak, nonatomic, readwrite) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic, readwrite) IBOutlet UILabel *identifier;
@end

@implementation CocktailCell

+ (NSString *)reuseIdentifier
{
    return @"CocktailCellIdentifier";
}


- (void)configureWithDataObject:(CocktailObject *)dataObject
{
    self.nameLabel.text = dataObject.name;
    self.identifier.text = [NSString stringWithFormat:@"%@", dataObject.identifier];
}

@end
