//
//  DAZClaimTableViewCell.h
//  Legion
//
//  Created by Дмитрий Жаров on 08.02.2018.
//  Copyright © 2018 SberTech. All rights reserved.
//

#import <UIKit/UIKit.h>


@class ClaimMO;


@interface DAZClaimTableViewCell : UITableViewCell

@property (nonatomic, readonly) ClaimMO *claim;

+ (CGFloat)height;

- (void)setWithClaim:(ClaimMO *)claim isIncome:(BOOL)income;

@end
