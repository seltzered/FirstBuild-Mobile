//
//  ManualRecipeAdder.m
//  FirstBuild
//
//  Created by Myles Caley on 12/8/15.
//  Copyright © 2015 FirstBuild. All rights reserved.
//

#import "FSTLocalRecipeCreator.h"
#import "FSTMultiStageRecipe.h"
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
        FSTMultiStageRecipe* recipe = [FSTMultiStageRecipe new];
        FSTParagonCookingStage* stage1;
        FSTParagonCookingStage* stage2;
        FSTParagonCookingStage* stage3;
        
        recipe.recipeId = @1001;
        recipe.recipeType = [NSNumber numberWithInt:FSTRecipeTypeFirstBuildMultiStage];
        recipe.note = [NSMutableString stringWithString:@"Love at first bite"];
        recipe.instructions = [NSMutableString stringWithString:@"PREPARATIONS\n\nBefore you start cooking, line an 8x8 baking dish with parchment paper. Spray the parchment paper with cooking spray.\n\nAttach the Paragon Probe to the sauce pan you will use for melting the butter and place the pan on the Paragon. The tip of the probe should be touching the bottom of the pan.\n\nIn another pan, 4 quart (or larger) sauce pan, thoroughly mix the 1 1/2 cups of sugar, 1/3 cup of corn syrup, and 1/4 cup of water until the mixture is a thick, grainy paste.\n\nIt is a good idea at this point to make sure all of the ingredients for the caramel are at hand so you can closely monitor the progress of your caramel as it cooks.\n\nWITH THE PARAGON - HEAT CREAM AND BUTTER\n\nCombine the cream, butter and salt in a small sauce pan at low heat until mixed.\n\nWITH THE PARAGON - HEAT SUGAR SOLUTION\n\nNext, without stirring, heat the sugar solution mixture in the 4 quart sauce pan.\n\nMANUAL - ADD THE BUTTER MIXTURE\n\nRemove the sugar solution pan from the Paragon and slowly add the cream/butter mixture while whisking gently. The mixture will bubble and triple in size. Stop whisking once the cream and butter have been mixed in.\n\nWITH THE PARAGON - HEAT COMBINED MIXTURE\n\nReturn the combined mixture to the Paragon and allow mixture to boil. As the temperature rises, the caramel will change from a light yellow color to a rich brown color.\n\nMANUAL - ADD VANILLA\n\nRemove the pan from the Paragon and quickly whisk vanilla into the caramel mixture.\n\nMANUAL - POUR THE CARAMEL INTO THE MOLD\n\nPour the caramel into the lined baking dish without scraping the bottom of the pan (the pan may have some slightly burnt caramel on the bottom).\n\nMANUAL -COOL AND CUT INTO BITE-SIZE PIECES\n\nLet the caramels cool for 1-2 hours until firm. Sprinkle coarse sea salt on top and cut into bite-sized pieces. Enjoy!"];
        
        recipe.ingredients = [NSMutableString stringWithString:@"TOOLS AND SUPPLIES\n\nWhisk\n8x8 pan lined with parchment paper\nCooking spray\n4 quart sauce pan for sugar water solution\nSmall Sauce Pan for melting butter\n\nINGREDIENTS\n\n1 1/4 cup heavy cream\n4 tablespoons unsalted butter\n1/4 tsp salt\n1 1/2 cup sugar\n1/4 cup corn syrup\n1/4 cup water\n1/2 teaspoon vanilla extract\nCoarse ground sea salt to taste"];
        recipe.name = @"Caramel";
        recipe.friendlyName = [NSMutableString stringWithString:@"Caramel"];
        
        // stage 1
        stage1 = [recipe addStage];
        stage1.cookTimeMinimum = @0;
        stage1.cookTimeMaximum = @0;
        stage1.cookingLabel = @"Melting the cream and butter";
        stage1.cookingPrepLabel = @"";
        stage1.targetTemperature = @85;
        stage1.maxPowerLevel = @8;
        stage1.automaticTransition = @0;
        
        // stage 2
        stage2 = [recipe addStage];
        stage2.cookTimeMinimum = @0;
        stage2.cookTimeMaximum = @0;
        stage2.cookingLabel = @"Heating sugar solution";
        stage2.cookingPrepLabel = @"Remove butter mixture sauce pan from Paragon and set aside. You will use this in a future step. Move the Paragon Probe from the butter mixture pan to the 4-quart sauce pan with the mixture created during the preparations on to Paragon. Select 'Next Stage' to continue.";
        stage2.targetTemperature = @2;
        stage2.maxPowerLevel = @1;
        stage2.automaticTransition = @0;
        
        // stage 3
        stage3 = [recipe addStage];
        stage3.cookTimeMinimum = @0;
        stage3.cookTimeMaximum = @0;
        stage3.cookingLabel = @"Heating combined mixture no stirring";
        stage3.cookingPrepLabel = @"Remove the 4 quart pan from Paragon and slowly add the cream/butter mixture while whisking gently. The mixture will bubble and triple in size. Stop whisking once the cream and butter have been mixed in. Return the pan to the Paragon. Select 'Next Stage' to continue.";
        stage3.targetTemperature = @240;
        stage3.maxPowerLevel = @10;
        stage3.automaticTransition = @0;
        
        [[FSTSavedRecipeManager sharedInstance] saveRecipe:recipe];
    }

}


@end
