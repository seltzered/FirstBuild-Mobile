//
//  ManualRecipeAdder.m
//  FirstBuild
//
//  Created by Myles Caley on 12/8/15.
//  Copyright © 2015 FirstBuild. All rights reserved.
//

#import "FSTLocalRecipeCreator.h"
#import "FSTRecipe.h"
#import "FSTSavedRecipeManager.h"

@implementation FSTLocalRecipeCreator

+ (id) sharedInstance {
    
    static FSTLocalRecipeCreator *sharedSingletonInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedSingletonInstance = [[self alloc] init];
    });
    return sharedSingletonInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self createRecipes];
    }
    return self;
}

-(void)createRecipes
{
    //
    // caramel
    //
    {
        FSTRecipe* recipe = [FSTRecipe new];
        FSTParagonCookingStage* stage;
        recipe.recipeId = @1001;
        recipe.recipeType = [NSNumber numberWithInt:FSTRecipeTypeFirstBuildMultiStage];
        recipe.note = [NSMutableString stringWithString:@"Love at first bite"];
        recipe.instructions = [NSMutableString stringWithString:@"Before you start cooking, line an 8x8 baking dish with parchment paper. Spray the parchment paper with cooking spray. It is a good idea at this point to make sure all of the ingredients for the caramel are at hand so you can closely monitor the progress of your caramel as it cooks.\n\nCombine the cream, butter and salt in a small sauce pan at low heat until mixed. Set aside. You will add this to the sugar solution later.\n\nIn a 4 quart (or larger) sauce pan, thoroughly mix the sugar, corn syrup, and water until the mixture is a thick, grainy paste.  Next, without stirring, heat the mixture until your candy thermometer indicates it has reached 300F (150C).\n\nOnce the sugar solution has reached 300F (150C), turn off the burner and slowly add the cream/butter mixture while whisking gently. The mixture will bubble and triple in size. Stop whisking once the cream and butter have been mixed in.\n\nReturn the burner to medium high heat. Let the caramel come to a boil without stirring. As the temperature rises, the caramel will change from a light yellow color to a rich brown color. Continue to heat without stirring until the caramel reaches 250F (120C).\n\nTurn the burner off. Quickly whisk vanilla into the caramel mixture.\n\nPour the caramel into the lined baking dish without scraping the bottom of the pan (the pan may have some slightly burnt caramel on the bottom).\n\nLet the caramels cool for 1-2 hours until firm. Sprinkle coarse sea salt on top and cut into bite-sized pieces. Enjoy!"];
        
        recipe.ingredients = [NSMutableString stringWithString:@"Tools and Supplies\n\nWhisk\n8x8 pan lined with parchment paper\nCooking spray\n4 quart sauce pan\n\n\n1 1/4 cup heavy cream\n4 tablespoons unsalted butter\n1/4 tsp salt\n1 1/2 cup sugar\n1/4 cup corn syrup\n1/4 cup water\n1/2 teaspoon vanilla extract\nCoarse ground sea salt to taste"];
        recipe.name = @"Caramel";
        recipe.friendlyName = [NSMutableString stringWithString:@"Caramel"];
        
        // stage 1
        stage = [recipe addStage];
        stage.cookTimeMinimum = @0;
        stage.cookTimeMaximum = @0;
        stage.cookingLabel = @"";
        stage.cookingPrepLabel = @"";
        stage.targetTemperature = @95;
        stage.maxPowerLevel = @10;
        stage.automaticTransition = @0;
        
        // stage 2
        stage = [recipe addStage];
        stage.cookTimeMinimum = @0;
        stage.cookTimeMaximum = @0;
        stage.cookingLabel = @"";
        stage.cookingPrepLabel = @"";
        stage.targetTemperature = @95;
        stage.maxPowerLevel = @10;
        stage.automaticTransition = @0;
        
        // stage 3
        stage = [recipe addStage];
        stage.cookTimeMinimum = @0;
        stage.cookTimeMaximum = @0;
        stage.cookingLabel = @"";
        stage.cookingPrepLabel = @"";
        stage.targetTemperature = @95;
        stage.maxPowerLevel = @10;
        stage.automaticTransition = @0;
        
        [[FSTSavedRecipeManager sharedInstance] saveRecipe:recipe];
    }

}


@end
