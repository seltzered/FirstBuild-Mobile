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
    
    UITextView* childInstructionsTextView;
    
    UITextView* childIngredientsTextView;
    
    
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // set the name if it is in the recipe
    [self.nameField setText:self.activeRecipe.friendlyName];
    FSTSavedRecipeTabBarController* recipeTBC = [self.childViewControllers objectAtIndex:0];
    recipeTBC.delegate = self;
        if ([recipeTBC.viewControllers[0] isKindOfClass:[FSTSavedRecipeIngredientsViewController class]])
        {
            childIngredientsTextView = ((FSTSavedRecipeIngredientsViewController*)recipeTBC.viewControllers[0]).textView;
        } // ingredients view should be the first one in the array (set it before it is visible)
    [childIngredientsTextView setText:self.activeRecipe.ingredients];
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
    [self.navigationController popViewControllerAnimated:YES];
        self.activeRecipe.friendlyName = [NSMutableString stringWithString:self.nameField.text];
        self.activeRecipe.note = [NSMutableString stringWithString:childInstructionsTextView.text];
        self.activeRecipe.ingredients = [NSMutableString stringWithString:childIngredientsTextView.text];
        self.activeRecipe.photo.image = self.imageEditor.image;
        [self.activeRecipe addStage];
        ((FSTParagonCookingStage*)self.activeRecipe.paragonCookingStages[0]).cookTimeMinimum = [childPickerManager minMinutesChosen];
        ((FSTParagonCookingStage*)self.activeRecipe.paragonCookingStages[0]).cookTimeMaximum = [childPickerManager maxMinutesChosen];
        ((FSTParagonCookingStage*)self.activeRecipe.paragonCookingStages[0]).targetTemperature = [childPickerManager temperatureChosen];

        // get all the session variables from the pickers, then save it
        [recipeManager saveRecipe:self.activeRecipe];
}

#pragma mark - UITabBarControllerDelegate

-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    
    // load the pertinent members of each view controller after we select it
    if ([viewController isKindOfClass:[FSTSavedRecipeInstructionsViewController class]])
    {
        childInstructionsTextView = ((FSTSavedRecipeInstructionsViewController*)viewController).textView;
    }
    else if ([viewController isKindOfClass:[FSTSavedRecipeSettingsViewController class]])
    {
        childPickerManager = ((FSTSavedRecipeSettingsViewController*)viewController).pickerManager;
    }
    else if ([viewController isKindOfClass:[FSTSavedRecipeIngredientsViewController class]])
    {
        childIngredientsTextView = ((FSTSavedRecipeIngredientsViewController*)viewController).textView;
    }
    // TODO: set the text of each view once it appears, but only if the text is not set. Im not certain how best to approach this. Perhaps with a sentinel value in the storyboard template; we would reset the text if it is there. 
    
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
