//
//  DAZPartyCreateViewController.h
//  Legion
//
//  Created by Дмитрий Жаров on 04.02.2018.
//  Copyright © 2018 SberTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DAZSelectionScreenBaseViewController.h"

typedef NS_ENUM(NSInteger, DAZSelectionScreenType) {
    // Результат: (NSDate *)
    DAZSelectionScreenDatePicker = 1,
    // Результат: (NSString *)
    DAZSelectionScreenPickerView,
    // Результат: (NSString *)
    DAZSelectionScreenTextField,
    // Результат: (NSString *)
    DAZSelectionScreenTextView,
    // Результат (NSValue *) @(NSInteger)
    DAZSelectionScreenSlider
};

@protocol DAZSelectionScreenDelegate <NSObject>

- (void)selectionScreenCompletedWorkWithResult:(id)result ofType:(DAZSelectionScreenType)type;

@end

@interface DAZSelectionScreenViewController : DAZSelectionScreenBaseViewController <DAZSelectionScreenBaseViewControllerProtocol>

@property (nonatomic, weak) id<DAZSelectionScreenDelegate> delegate;

@property (nonatomic, readonly) DAZSelectionScreenType type;
@property (nonatomic, readonly) NSString *message;

- (instancetype)initWithType:(DAZSelectionScreenType)type message:(NSString *)message;

@end
