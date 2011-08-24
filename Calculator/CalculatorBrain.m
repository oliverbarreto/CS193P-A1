//
//  CalculatorBrain.m
//  Calculator
//
//  Created by David Oliver Barreto Rodríguez on 08/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CalculatorBrain.h"
#define VARIABLE_PREFIX @"%"


@implementation CalculatorBrain

//* *****************************************************************************
//Basic Model Properties & iVars

@synthesize operand, waitingOperand,waitingOperation;   
@synthesize myMem;                                      
@synthesize typeOfAngleMetrics;                         
@synthesize errorMessage;


//* *****************************************************************************
//Basic Model Methods

-(void)performWaitingOperation{
    //realiza la operación pendiente por realizar...
    
    if ([@"+" isEqual:waitingOperation]) {
        operand = waitingOperand + operand; 
    } else if ([@"-" isEqual:waitingOperation]) {
        operand = waitingOperand - operand; 
    } else if ([@"*" isEqual:waitingOperation]) {
        operand = waitingOperand * operand; 
    } else if ([@"/" isEqual:waitingOperation]) {
        if (operand){
            operand = waitingOperand / operand; 
        } else {
            self.errorMessage = [NSString stringWithFormat:@"Error: Div by 0"];
        }
    }
}

-(double)performOperation:(NSString *)operation{

    //checks for operations of 1 or two operands    
    if ([operation isEqual:@"sqrt"]) {
        if (self.operand >= 0 ) {
            self.operand = sqrt(self.operand);
        } else {
            self.errorMessage = [NSString stringWithFormat:@"Error: Sqrt of Negative Numbers is not implemented"];
      }
    } else if ([operation isEqual:@"1/x"]) {
        if (self.operand) {
            self.operand = 1 / self.operand;
        } else {
            self.errorMessage = [NSString stringWithFormat:@"Error: Div by 0"];
      }
    } else if ([operation isEqual:@"π"]) {
        self.operand = M_PI;
        
    } else if ([operation isEqual:@"M"]) {
        self.myMem = self.operand;

    } else if ([operation isEqual:@"MR"]) {
        self.operand = self.myMem;
        
    } else if ([operation isEqual:@"M+"]) {
        self.operand = self.operand + self.myMem;
        
    } else if ([operation isEqual:@"M-"]) {
        self.operand = self.operand - self.myMem;
        
    } else if ([operation isEqual:@"Sin"]) {
        if (!typeOfAngleMetrics) {
            self.operand = sin((self.operand * M_PI)/180);  //Using Degrees as argument
        } else { 
            self.operand = sin(self.operand);               //Using Radians as argument
        }
        
    } else if ([operation isEqual:@"Cos"]) {
        if (!typeOfAngleMetrics) {
            self.operand = cos((self.operand * M_PI)/180);  //Using Degrees as argument
        } else { 
            self.operand = cos(self.operand);               //Using Radians as argument
        }
        
    } else if ([operation isEqual:@"+/-"]) {
        self.operand =  - self.operand;

    } else if ([operation isEqual:@"Del"]) {
        self.operand = 0;
        
    } else if ([operation isEqual:@"C"]) {  //Clears everything in brain
        self.operand = 0.0;
        self.waitingOperation = @"";
        self.waitingOperand = 0.0;
        self.errorMessage = @"";
    
    } else {    
        [self performWaitingOperation];         //execute regular math operation
        self.waitingOperation = operation;      //prepare for next operation
        self.waitingOperand = self.operand;
    }            

    return operand;    
}


- (NSString *)pendingOperation {
    if (waitingOperation == nil) {
        return @"Op: ";
    } else {
        if ([self.waitingOperation isEqual:@"="]) {
            return [NSString stringWithFormat:@"Op: = %g",waitingOperand];
        } else    {
            return [NSString stringWithFormat:@"Op: %g %@", waitingOperand, waitingOperation];
        }
    }
}

//* *****************************************************************************
// Standard initialization of model

- (id)init {    // Custom initializator for CalculatorBrain
    if (self = [super init]) {
        self.errorMessage = [NSString stringWithFormat:@""];
    }
    return  self;
}

// Standard dealloc method
-(void)dealloc
{
    [waitingOperation release]; //release of all my self self-created objetcs
    [errorMessage release];
    
    [super dealloc];
}

@end
