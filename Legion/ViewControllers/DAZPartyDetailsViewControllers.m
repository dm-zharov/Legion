//
//  DAZPartyDetailsViewControllers.m
//  Legion
//
//  Created by Дмитрий Жаров on 03.02.2018.
//  Copyright © 2018 SberTech. All rights reserved.
//

#import "DAZPartyDetailsViewControllers.h"
#import "CAGradientLayer+Gradients.h"

@interface DAZPartyDetailsViewControllers ()

@end

@implementation DAZPartyDetailsViewControllers

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupBackgroundLayer];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupBackgroundLayer
{
    self.view.backgroundColor = [UIColor whiteColor];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
