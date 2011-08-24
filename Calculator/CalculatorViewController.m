//
//  CalculatorViewController.m
//  Calculator
//
//  Created by David Oliver Barreto Rodríguez on 08/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CalculatorViewController.h"

@interface CalculatorViewController() 
@property (readonly) CalculatorBrain *brain;    //Private & ReadOnly Model
@end

@implementation CalculatorViewController

@synthesize display, displayMem, displayOperation, displayTypeOfAngleMetrics;
@synthesize stateForTypeOfAngleMetricsButton;



- (CalculatorBrain *)brain {
    // Revisar si es bueno hacer esto aquí, o dejarlo para  viewDidLoad ???
    //Lazy instanciation of my Model
    if (!brain) {
        brain = [[CalculatorBrain alloc] init];
    }

    return brain;    
}

- (BOOL)isDecimalPointValid {
    NSString *myDisplayString = self.display.text;
    NSRange myRange = [myDisplayString rangeOfString:@"."];
    
    if (myRange.length == 0) return YES;
    else return NO;
}

- (void)showAlert {
    UIAlertView *myAlert = [[UIAlertView alloc] initWithTitle:@"Invalid Operation" 
                                                      message:self.brain.errorMessage 
                                                     delegate:self 
                                            cancelButtonTitle:@"OK" 
                                            otherButtonTitles:nil];

    [myAlert autorelease];
    [myAlert show];

    self.brain.errorMessage = @"";
}


- (void)updateUIDisplays:(UIButton *)mySender {
    //Creates the right setup for Displaying content on all displays on screen
    
    //NSString *operation = mySender.titleLabel.text;
    NSString *myOperationDisplayMSG = @"Op: ";
    NSString static *myTypeOfAngleMetricsMSG = @"Rdn";

    if (![self.brain.errorMessage isEqual:@""]) {
        myOperationDisplayMSG = self.brain.errorMessage;
        //[self showAlert];
        self.brain.errorMessage = @"";
    
    } else {
        if ([mySender.titleLabel.text isEqual:@"C"]) {
            myOperationDisplayMSG = @"Op: ";
            
            //Test of Error Conditions of Model calling AlertView
        } else if ([mySender.titleLabel.text isEqual:@"f"]) {
            [self showAlert];
            
        } else if ([mySender.titleLabel.text isEqual:@"Deg"] || [mySender.titleLabel.text isEqual:@"Rdn"] ) {
            
            //Change image & text of Deg/Rdn Button & Display Text;  
            if (stateForTypeOfAngleMetrics) {                       //Radians
                myTypeOfAngleMetricsMSG = [NSString stringWithFormat:@"Rdn"];
                stateForTypeOfAngleMetrics = NO;
                
                [stateForTypeOfAngleMetricsButton setTitle:@"Deg" forState:UIControlStateNormal];
                UIImage *myButtonImage = [UIImage imageNamed:@"LightGreyR.png"];
                [stateForTypeOfAngleMetricsButton setBackgroundImage:myButtonImage forState:UIControlStateNormal];
                
            } else {                                                //Degrees
                myTypeOfAngleMetricsMSG = [NSString stringWithFormat:@"Deg"];
                stateForTypeOfAngleMetrics = YES;                
                
                [stateForTypeOfAngleMetricsButton setTitle:@"Rdn" forState:UIControlStateNormal];
                UIImage *myButtonImage = [UIImage imageNamed:@"DarkGreyR.png"];
                [stateForTypeOfAngleMetricsButton setBackgroundImage:myButtonImage forState:UIControlStateNormal];
            }   
        } else {
            if (self.brain.waitingOperand) {
                myOperationDisplayMSG = [self.brain pendingOperation];
            } else {
                myOperationDisplayMSG = [NSString stringWithFormat:@"Op: "];
            }            
        }
    }

    
    //Dsisplays updated content for all the Diplays
    self.display.text = [NSString stringWithFormat:@"%g", self.brain.operand];
    self.displayMem.text = [NSString stringWithFormat:@"Mem: %g", self.brain.myMem];
    self.displayTypeOfAngleMetrics.text = myTypeOfAngleMetricsMSG;
    self.displayOperation.text = myOperationDisplayMSG;

}

- (IBAction)digitPressed:(UIButton *)sender {
    //Performs actions when a Digit (number) is pressed
    NSString *digit = sender.titleLabel.text;
    
    if (userIsInTheMiddleOfTyingANumber) {
        if ([digit isEqual:@"."]) {
            if ([self isDecimalPointValid]) {
                self.display.text = [self.display.text stringByAppendingString:digit];
            }
        } else {   
            self.display.text = [self.display.text stringByAppendingString:digit];
        }
    } else {      
        self.display.text = digit;
        userIsInTheMiddleOfTyingANumber = YES;
    }
}


- (IBAction)operationPressed:(UIButton *)sender {
    //Performs actions when an Operation is pressed    
    //checks if the user is in the middle of typing some number or its an final result from an operations or equals is pressed

    if (userIsInTheMiddleOfTyingANumber) {
        self.brain.operand = [self.display.text doubleValue];
        userIsInTheMiddleOfTyingANumber = NO;
    }
    
    self.brain.operand = [self.brain performOperation:sender.titleLabel.text];
        
    //Update Displays in UI
    [self updateUIDisplays:sender];
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


//Utility methods for cleaning up  memory when finished
-(void)releaseNilsOfOutlets {
    self.display = nil;
    self.displayMem = nil;
    self.displayOperation = nil;
    self.stateForTypeOfAngleMetricsButton = nil;
}

-(void)releaseMemOfOutlets {
    [display release];
    [displayMem release];
    [displayOperation release];
    [stateForTypeOfAngleMetricsButton release];
}

- (void)viewDidUnload {
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [self releaseNilsOfOutlets];
    
    [super viewDidUnload];
}

- (void)dealloc {
    // Releasing my own created objects
    [brain release];  
    
    // Releasing my own created IBOutlet objects
    [self releaseMemOfOutlets];
    
    [super dealloc];
}
@end
