//
//  FSTRecipeManager.m
//  FirstBuild
//
//  Created by John Nolan on 8/17/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTRecipeManager.h"

@implementation FSTRecipeManager


-(void)saveRecipe:(FSTRecipe *)recipe {
    if (recipe.name.length > 0) {
        NSMutableDictionary* recipeDictionary = [NSMutableDictionary dictionaryWithDictionary:[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"Recipes"]]]; // a mutable dictionary built from the unarchived data keyed as recipes in standardDefaults
        if (!recipeDictionary) {
            recipeDictionary = [[NSMutableDictionary alloc] init];
        }
        [recipeDictionary setObject:recipe forKey:recipe.name]; // will need to make sure names are unique, probably when setting the recipe
        [self saveItemsToDefaults:[NSDictionary dictionaryWithDictionary:recipeDictionary] key:@"Recipes"];
    }
}
-(void)saveItemsToDefaults:(NSDictionary*)object key:(NSString*)key {
    NSData* encodedObject = [NSKeyedArchiver archivedDataWithRootObject:object];
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:encodedObject forKey:key];
    [defaults synchronize];
}

-(NSDictionary*)loadItemsFromDefaultsWithKey:(NSString*)key {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSData* encodedObject = [defaults objectForKey:key];
    NSDictionary* items = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    return items;
}

-(void)removeItemFromDefaults:(NSString*)key { // remove the current recipe name
    NSMutableDictionary* recipeDictionary = [NSMutableDictionary dictionaryWithDictionary:[self loadItemsFromDefaultsWithKey:@"Recipes"]];
    [recipeDictionary removeObjectForKey:key]; // remove specificied object
    [self saveItemsToDefaults:recipeDictionary key:@"Recipes"]; // then replace the dictionary
}

-(NSDictionary*)getSavedRecipes {
    return [self loadItemsFromDefaultsWithKey: @"Recipes"];
} // need some way to check a new item against all the keys
@end
