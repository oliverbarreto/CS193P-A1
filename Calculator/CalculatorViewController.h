//
//  CalculatorViewController.h
//  Calculator
//
//  Created by David Oliver Barreto Rodríguez on 08/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalculatorBrain.h"

@interface CalculatorViewController : UIViewController {
@private
    UILabel *display;                           //calculator main display
    UILabel *displayMem;                        //displays Current Memory Value
    UILabel *displayOperation;                  //displays Current Operation Array
    UILabel *displayTypeOfAngleMetrics;         //displays Deg. vs Rdns state 

    BOOL userIsInTheMiddleOfTyingANumber;       //To know if still typing numbers

    BOOL      stateForTypeOfAngleMetrics;       //To Set Deg vs Rads
    UIButton *stateForTypeOfAngleMetricsButton; 
    
    CalculatorBrain *brain;                     //My Model 

}

//@property BOOL userIsInTheMiddleOfTyingANumber, stateForTypeOfAngleMetrics;

@property (nonatomic, retain) IBOutlet UILabel *display, *displayMem,*displayOperation;
@property (nonatomic, retain) IBOutlet UILabel *displayTypeOfAngleMetrics;
@property (nonatomic, retain) IBOutlet UIButton *stateForTypeOfAngleMetricsButton;


- (IBAction)digitPressed:(id)sender;
- (IBAction)operationPressed:(id)sender;

@end
