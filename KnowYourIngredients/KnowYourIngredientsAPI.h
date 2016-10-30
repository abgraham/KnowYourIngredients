//
//  KnowYourIngredientsAPI.h
//  KnowYourIngredients
//
//  Created by Annie Graham on 10/30/16.
//  Copyright © 2016 Annie Graham. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KnowYourIngredientsAPI : NSObject

+ (KnowYourIngredientsAPI *)sharedInstance;
- (NSArray *)getEasyGlutenIngredients;
- (NSArray *)getEasyAllIngredients;
- (NSArray *)getHardGlutenIngredients;
- (NSArray *)getAllHardIngredients;

@end
