//
//  FSTSavedRecipeManager.m
//  FirstBuild
//
//  Created by John Nolan on 8/17/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTSavedRecipeManager.h"

@implementation FSTSavedRecipeManager

+ (id) sharedInstance {
    
    static FSTSavedRecipeManager *sharedSingletonInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedSingletonInstance = [[self alloc] init];
    });
    return sharedSingletonInstance;
}

-(void)saveRecipe:(FSTRecipe *)recipe {
    if (recipe.friendlyName.length > 0) {
        NSMutableDictionary* recipeDictionary = [NSMutableDictionary dictionaryWithDictionary:[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"Recipes"]]]; // a mutable dictionary built from the unarchived data keyed as recipes in standardDefaults
        if (!recipeDictionary) {
            recipeDictionary = [[NSMutableDictionary alloc] init];
        }
        
        //first check if this is a new recipe we are saving
        if (!recipe.recipeId)
        {
            //new recipe, so we need an id, lets see what the last recipe id is that we used
            recipe.recipeId = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastRecipeId"];
            if (!recipe.recipeId)
            {
                //first time we have ever saved a recipe
                recipe.recipeId = [NSNumber numberWithInt:1001];
            }
            else
            {
                //increment the old value
                recipe.recipeId = [NSNumber numberWithInt:[recipe.recipeId intValue]+1];
            }
            
            [[NSUserDefaults standardUserDefaults] setObject:recipe.recipeId forKey:@"lastRecipeId"];
        }
        
        [recipeDictionary setObject:recipe forKey:recipe.recipeId];
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
