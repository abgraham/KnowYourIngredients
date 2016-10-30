//
//  KnowYourIngredientsAPI.m
//  KnowYourIngredients
//
//  Created by Annie Graham on 10/30/16.
//  Copyright © 2016 Annie Graham. All rights reserved.
//

#import "KnowYourIngredientsAPI.h"

@implementation KnowYourIngredientsAPI

+ (KnowYourIngredientsAPI *)sharedInstance {

    static KnowYourIngredientsAPI *sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        sharedInstance = [KnowYourIngredientsAPI new];
    });

    return sharedInstance;
}

- (NSArray *)getEasyGlutenIngredients {
    return [NSArray arrayWithObjects: @"wheat", @"oats", @"barley", @"rye", NULL];
}

- (NSArray *)getEasyAllIngredients {
    return [NSArray arrayWithObjects: @"wheat", @"oats", @"barley", @"rye", @"rice", @"potatoes", @"corn", @"buckwheat", NULL];
}

- (NSArray *)getHardGlutenIngredients {
    return [NSArray arrayWithObjects: @"wheat", @"oats", @"barley", @"rye",
            @"yeast", @"Bulgur", @"Durum", @"Farro/faro", @"Spelt", @"dinkel", @"Graham flour", @"Hydrolyzed wheat protein", @"Kamut", @"Malt, malt extract, malt syrup, malt flavoring", @"Malt vinegar", @"Malted milk", @"Matzo", @"Modified wheat starch", @"Oatmeal", @"Seitan", @"Semolina", @"Triticale", @"Wheat bran", @"Wheat flour", @"Wheat germ", @"Wheat starch", @"Atta", @"Chapati flour", @"Einkorn", @"Emmer", @"Farina", @"Fu", NULL];
}

- (NSArray *)getAllHardIngredients {
    return [NSArray arrayWithObjects: @"corn starch", @"grits", @"hominy", @"polenta", @"maltodextrin", @"arrowroot", @"tapioca", @"manioc flour", @"guar gum", @"hydrolyzed soy protein", @"lethicin", @"millet", @"mono and diglycerides", @"montina", @"MSG", @"Oat gum", @"Quinoa", @"Sorghum", @"Soy", @"Starch", @"Teff", @"Vinegar", @"Whey", @"Xanthan gum", @"Yeast", @"Brewer's yeast", @"Bulgur", @"Durum", @"Farro/faro", @"Spelt", @"dinkel", @"Graham flour", @"Hydrolyzed wheat protein", @"Kamut", @"Malt, malt extract, malt syrup, malt flavoring", @"Malt vinegar", @"Malted milk", @"Matzo", @"Modified wheat starch", @"Oatmeal", @"Seitan", @"Semolina", @"Triticale", @"Wheat bran", @"Wheat flour", @"Wheat germ", @"Wheat starch", @"Atta", @"Chapati flour", @"Einkorn", @"Emmer", @"Farina", @"Fu", NULL];
}


@end
