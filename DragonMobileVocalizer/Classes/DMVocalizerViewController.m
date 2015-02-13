//
//  DMVocalizerViewController.m
//  DMVocalizer
//
// Copyright 2010, Nuance Communications Inc. All rights reserved.
//
// Nuance Communications, Inc. provides this document without representation 
// or warranty of any kind. The information in this document is subject to 
// change without notice and does not represent a commitment by Nuance 
// Communications, Inc. The software and/or databases described in this 
// document are furnished under a license agreement and may be used or 
// copied only in accordance with the terms of such license agreement.  
// Without limiting the rights under copyright reserved herein, and except 
// as permitted by such license agreement, no part of this document may be 
// reproduced or transmitted in any form or by any means, including, without 
// limitation, electronic, mechanical, photocopying, recording, or otherwise, 
// or transferred to information storage and retrieval systems, without the 
// prior written permission of Nuance Communications, Inc.
// 
// Nuance, the Nuance logo, Nuance Recognizer, and Nuance Vocalizer are 
// trademarks or registered trademarks of Nuance Communications, Inc. or its 
// affiliates in the United States and/or other countries. All other 
// trademarks referenced herein are the property of their respective owners.
//

#import "DMVocalizerViewController.h"
#import "SpeechKit/SpeechKit.h"

/**
 * The login parameters should be specified in the following manner:
 * 
 * const unsigned char SpeechKitApplicationKey[] =
 * {
 *     0x38, 0x32, 0x0e, 0x46, 0x4e, 0x46, 0x12, 0x5c, 0x50, 0x1d,
 *     0x4a, 0x39, 0x4f, 0x12, 0x48, 0x53, 0x3e, 0x5b, 0x31, 0x22,
 *     0x5d, 0x4b, 0x22, 0x09, 0x13, 0x46, 0x61, 0x19, 0x1f, 0x2d,
 *     0x13, 0x47, 0x3d, 0x58, 0x30, 0x29, 0x56, 0x04, 0x20, 0x33,
 *     0x27, 0x0f, 0x57, 0x45, 0x61, 0x5f, 0x25, 0x0d, 0x48, 0x21,
 *     0x2a, 0x62, 0x46, 0x64, 0x54, 0x4a, 0x10, 0x36, 0x4f, 0x64
 * };
 * 
 * Please note that all the specified values are non-functional
 * and are provided solely as an illustrative example.
 * 
 */
const unsigned char SpeechKitApplicationKey[] = {INSERT_YOUR_APPLICATION_KEY_HERE};

@implementation DMVocalizerViewController
@synthesize textToRead,textReadSoFar,serverBox,portBox,speakButton,vocalizer;


/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];

    /**    
     * The login parameters should be specified in the following manner:
     *
     *  [SpeechKit setupWithID:@"ExampleSpeechKitSampleID"
     *                    host:@"ndev.server.name"
     *                    port:1000
     *                  useSSL:NO
     *                delegate:self];
     *
     * Please note that all the specified values are non-functional
     * and are provided solely as an illustrative example.
     */ 

    [SpeechKit setupWithID:INSERT_YOUR_APPLICATION_ID_HERE
                      host:INSERT_YOUR_HOST_ADDRESS_HERE
                      port:INSERT_YOUR_HOST_PORT_HERE
                    useSSL:NO
                  delegate:self];

    // Debug - Uncomment this code and fill in your server and port below, and set
    // the Main Window nib to MainWindow_Debug (in DMVocalizer-Info.plist)
    // if you need the ability to change servers in DMVocalizer
    //[serverBox setText:@""];
    //[portBox setText:@""];
}



/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

#pragma mark -
#pragma mark Actions

- (IBAction)speakOrStopAction: (id) sender {
    [serverBox resignFirstResponder];
    [portBox resignFirstResponder];
    [textToRead resignFirstResponder];
    [textReadSoFar resignFirstResponder];
    
    if (isSpeaking) {
        [vocalizer cancel];
        isSpeaking = NO;
    }
    else {
        isSpeaking = YES;
		// Initializes an english voice
        vocalizer = [[SKVocalizer alloc] initWithLanguage:@"en_US" delegate:self];

		// Initializes a french voice
		// vocalizer = [[SKVocalizer alloc] initWithLanguage:@"fr_FR" delegate:self];
		
		// Initializes a SKVocalizer with a specific voice
		// vocalizer = [[SKVocalizer alloc] initWithVoice:@"Samantha" delegate:self];
		
		// Speaks the string text
        [vocalizer speakString:textToRead.text];

        // Speaks the markup text with language For multiple languages, add <s></s> tags to markup string
		// NSString * textToReadString = [[[[NSString alloc] initWithCString:"<?xml version=\"1.0\"?> <speak version=\"1.0\" xmlns=\"http://www.w3.org/2001/10/synthesis\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xsi:schemaLocation=\"http://www.w3.org/2001/10/synthesis http://www.w3.org/TR/speech-synthesis/synthesis.xsd\" xml:lang=\"en-us\"> <s xml:lang=\"fr\"> "] stringByAppendingString:textToRead.text] stringByAppendingString:@"</s></speak>"];
		// [vocalizer speakMarkupString:textToReadString];
        
        // Speaks the markup text with voice, For multiple voices, add <voice></voice> tags to markup string.
		// NSString * textToReadString = [[[[NSString alloc] initWithCString:"<?xml version=\"1.0\"?> <speak version=\"1.0\" xmlns=\"http://www.w3.org/2001/10/synthesis\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xsi:schemaLocation=\"http://www.w3.org/2001/10/synthesis http://www.w3.org/TR/speech-synthesis/synthesis.xsd\" xml:lang=\"en-us\"> <voice name=\"Samantha\">"] stringByAppendingString:textToRead.text] stringByAppendingString:@"</voice></speak>"];
		// [vocalizer speakMarkupString:textToReadString];
        
		textReadSoFar.text = @"";
    }
}

- (IBAction)serverUpdateButtonAction: (id)sender {
    [serverBox resignFirstResponder];
    [portBox resignFirstResponder];
    [textToRead resignFirstResponder];
    [textReadSoFar resignFirstResponder];
    
    if (isSpeaking) [vocalizer cancel];
    
    [SpeechKit destroy];
}

#pragma mark -
#pragma mark SpeechKitDelegate methods

- (void) destroyed {
    // Debug - Uncomment this code and fill in your app ID below, and set
    // the Main Window nib to MainWindow_Debug (in DMVocalizer-Info.plist)
    // if you need the ability to change servers in DMVocalizer
    //
    //[SpeechKit setupWithID:INSERT_YOUR_APPLICATION_ID_HERE
    //                  host:INSERT_YOUR_HOST_ADDRESS_HERE
    //                  port:INSERT_YOUR_HOST_PORT_HERE[[portBox text] intValue]
    //                useSSL:NO
    //              delegate:self];
}

#pragma mark -
#pragma mark SKVocalizerDelegate methods

- (void)vocalizer:(SKVocalizer *)vocalizer willBeginSpeakingString:(NSString *)text {
    isSpeaking = YES;
    [speakButton setTitle:@"Stop" forState:UIControlStateNormal];
	if (text)
		textReadSoFar.text = [[textReadSoFar.text stringByAppendingString:text] stringByAppendingString:@"\n"];
}

- (void)vocalizer:(SKVocalizer *)vocalizer willSpeakTextAtCharacter:(NSUInteger)index ofString:(NSString *)text {
    NSLog(@"Session id [%@].", [SpeechKit sessionID]); // for debugging purpose: printing out the speechkit session id 
    textReadSoFar.text = [text substringToIndex:index];
}

- (void)vocalizer:(SKVocalizer *)vocalizer didFinishSpeakingString:(NSString *)text withError:(NSError *)error {
    NSLog(@"Session id [%@].", [SpeechKit sessionID]); // for debugging purpose: printing out the speechkit session id 
    isSpeaking = NO;
    [speakButton setTitle:@"Read It" forState:UIControlStateNormal];
	if (error !=nil)
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
														message:[error localizedDescription]
													   delegate:nil
											  cancelButtonTitle:@"OK"
											  otherButtonTitles:nil];        
		[alert show];
		[alert release];
	}
}

#pragma mark -
#pragma mark UITextFieldDelegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == serverBox)
    {
        [serverBox resignFirstResponder];
    }
    else if (textField == portBox)
    {
        [portBox resignFirstResponder];
    }
    return YES;
}

@end
