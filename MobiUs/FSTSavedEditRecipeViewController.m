//
//  FSTEditRecipeViewController.m
//  FirstBuild
//
//  Created by John Nolan on 8/13/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTSavedEditRecipeViewController.h"
#import "FSTSavedRecipeTabBarController.h"
#import "FSTSavedRecipeIngredientsViewController.h"
#import "FSTSavedRecipeInstructionsViewController.h"
#import "FSTSavedRecipeSettingsViewController.h"
#import "FSTSavedRecipeTabBarController.h"

@interface FSTSavedEditRecipeViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageEditor;

@property (weak, nonatomic) IBOutlet UITextField *nameField;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIView *stageView;

@end

@implementation FSTSavedEditRecipeViewController
{
    FSTSavedRecipeManager* recipeManager;
    
    // some crucial data objects in the children
    FSTStagePickerManager* childPickerManager;
    
}

typedef enum variableSelections {
    MIN_TIME,
    MAX_TIME,
    TEMPERATURE,
    NONE
} VariableSelection;
// keeps track of the open picker views

VariableSelection _selection;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    recipeManager = [FSTSavedRecipeManager sharedInstance];
    [self.nameField setDelegate:self];
    
    if (!self.activeRecipe) {
        self.activeRecipe = [[FSTRecipe alloc] init]; // need a strong property since this could be the unique pointer
        self.imageEditor.image = [UIImage imageNamed:@"sad-robot"];
    } else {
        self.imageEditor.image = self.activeRecipe.photo.image;
    }
    
    
}

- (void)viewWillAppear:(BOOL)animated { // perhaps view did load? I want view did load in the child to have called. Could just have an ingredients setter if it does not work
    [super viewWillAppear:animated];
    // set the name if it is in the recipe
    [self.nameField setText:self.activeRecipe.friendlyName];
    FSTSavedRecipeTabBarController* recipeTBC = [self.childViewControllers objectAtIndex:0];
    recipeTBC.delegate = self;
    
    for (UIViewController* vc in recipeTBC.viewControllers) {
        if ([vc isKindOfClass:[FSTSavedRecipeIngredientsViewController class]])
        {
            ((FSTSavedRecipeIngredientsViewController*)vc).ingredients = self.activeRecipe.ingredients; // set the ingredients property for when it loads
            // ingredients view should be the first one in the array (set it before it is visible)
        } else if ([vc isKindOfClass:[FSTSavedRecipeInstructionsViewController class]]) {
            ((FSTSavedRecipeInstructionsViewController*)vc).instructions = self.activeRecipe.note; // this can be set later in view did load
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



#pragma mark - image editing
- (IBAction)imageEditorTapped:(id)sender {
    UIImagePickerController* mealImagePicker = [[UIImagePickerController alloc] init];
    mealImagePicker.delegate = self;
    mealImagePicker.allowsEditing = YES;
    mealImagePicker.sourceType = UIImagePickerControllerCameraDeviceFront; // change this mode to let users select an image from the library
    
    [self presentViewController:mealImagePicker animated:YES completion:NULL];
    
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage* imageTaken = info[UIImagePickerControllerEditedImage];
    //self.imageEditor.image = imageTaken;
    self.activeRecipe.photo.image = imageTaken;
    self.imageEditor.image = imageTaken;
    [picker dismissViewControllerAnimated:YES completion:NULL];
    [self.view layoutIfNeeded]; // constraints seem to be off
   // self.scrollView.contentSize = CGSizeMake(self.stageView.frame.size.width, self.scrollView.contentSize.height);
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - text field and view delegates

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    self.activeRecipe.friendlyName = [NSMutableString stringWithString:textField.text];
    return YES; // might want to scroll to different positions depending on the delegate
}

#pragma mark - save button

- (IBAction)saveButtonTapped:(id)sender {
    //[self.navigationController popViewControllerAnimated:YES];
        self.activeRecipe.friendlyName = [NSMutableString stringWithString:self.nameField.text];
    FSTSavedRecipeTabBarController* recipeTBC = (FSTSavedRecipeTabBarController*)self.childViewControllers[0];
    self.activeRecipe.ingredients = ((FSTSavedRecipeIngredientsViewController*)recipeTBC.viewControllers[0]).ingredients;
    self.activeRecipe.note = ((FSTSavedRecipeInstructionsViewController*)recipeTBC.viewControllers[1]).instructions;
    self.activeRecipe.photo.image = self.imageEditor.image;
    // will probably for loop through all the picker manager to support multiStages
    if (childPickerManager) { // child PickerManager was set, so the setting might have changed
        [self.activeRecipe addStage];
        ((FSTParagonCookingStage*)self.activeRecipe.paragonCookingStages[0]).cookTimeMinimum = [childPickerManager minMinutesChosen];
        ((FSTParagonCookingStage*)self.activeRecipe.paragonCookingStages[0]).cookTimeMaximum = [childPickerManager maxMinutesChosen];
        ((FSTParagonCookingStage*)self.activeRecipe.paragonCookingStages[0]).targetTemperature = [childPickerManager temperatureChosen];
    }
    // TODO: work out the session / recipe issue
    // get all the session variables from the pickers, then save it
    [recipeManager saveRecipe:self.activeRecipe];
    [self.navigationController popViewControllerAnimated:YES]; // perhaps the other views will dealloc later
}

#pragma mark - UITabBarControllerDelegate

-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    
   if ([viewController isKindOfClass:[FSTSavedRecipeSettingsViewController class]])
    {
        childPickerManager = ((FSTSavedRecipeSettingsViewController*)viewController).pickerManager;
    } // get the picker manager for quick access from the
    
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
