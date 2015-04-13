//
//  CZAuthenticationDC.m
//  AboutMe
//
//  Created by Dario De pascalis on 11/04/15.
//  Copyright (c) 2015 Dario De Pascalis. All rights reserved.
//

#import "CZAuthenticationDC.h"

NSString *NAME_IMAGE_PROFILE = @"imageProfile.png";
NSString *KEY_IMAGE_PROFILE = @"image";
CGFloat MIN_CHARS_USERNAME = 6.0;
CGFloat MIN_CHARS_PASSWORD = 6.0;
CGFloat MIN_CHARS_NAMECOMPLETE = 2.0;

@implementation CZAuthenticationDC

-(void)saveImageWithoutDelegate:(UIImage *)image nameImage:(NSString *)nameImage key:(NSString *)key{
    NSLog(@"saveImageWithoutDelegate %@ - %@", nameImage, key);
    NSData *imageData = UIImagePNGRepresentation(image);
    PFFile *imageFile = [PFFile fileWithName:nameImage data:imageData];
    [[PFUser currentUser] setObject:imageFile forKey:key];
    [[PFUser currentUser] saveInBackground];
}

@end
