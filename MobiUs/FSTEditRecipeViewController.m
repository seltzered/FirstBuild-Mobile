//
//  FSTEditRecipeViewController.m
//  FirstBuild
//
//  Created by John Nolan on 8/13/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTEditRecipeViewController.h"

@interface FSTEditRecipeViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageEditor;

@property (weak, nonatomic) IBOutlet UITextField *nameField;

@property (weak, nonatomic) IBOutlet UITextField *noteField;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation FSTEditRecipeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    if (self.activeRecipe) {
        self.imageEditor.image = self.activeRecipe.photo;
    }
    [self.nameField setDelegate:self];
    [self.noteField setDelegate:self];
    // will probably save the recipes in a dictionary in NSUserDefaults
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidLayoutSubviews {
    self.scrollView.contentSize = CGSizeMake(600, 1000);
}

#pragma mark - image editing
- (IBAction)imageEditorTapped:(id)sender {
    UIImagePickerController* mealImagePicker = [[UIImagePickerController alloc] init];
    mealImagePicker.delegate = self;
    mealImagePicker.allowsEditing = YES;
    mealImagePicker.sourceType = UIImagePickerControllerCameraCaptureModePhoto; // change this mode to let users select an image from the library
    
    [self presentViewController:mealImagePicker animated:YES completion:NULL];
    
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage* imageTaken = info[UIImagePickerControllerEditedImage];
    self.imageEditor.image = imageTaken;
    self.activeRecipe.photo = imageTaken;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - text field delegates

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES; // might want to scroll to different positions depending on the delegate
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
