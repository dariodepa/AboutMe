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
int MIN_CHARS_USERNAME = 6;
int MIN_CHARS_PASSWORD = 6;
int MIN_CHARS_NAMECOMPLETE = 2;

@implementation CZAuthenticationDC


-(void)loadImage:(PFFile *)imageFile
{
    NSLog(@"loadImage: %@", imageFile.name);
    [imageFile getDataInBackgroundWithBlock:^(NSData *fileData, NSError *error) {
        if (!error) {
            //PFFile *image = [PFFile fileWithName:@"image Profile" data:fileData];
            [self.delegate refreshImage:fileData name:imageFile.name];
        }
        else{
            NSLog(@"error: %@", error);
        }
    } progressBlock:^(int percentDone) {
        float progress=percentDone/100;
        NSLog(@"progress %f", progress);
        [self.delegate setProgressBar:nil progress:progress];
    }];
}


-(void)saveImage:(NSData *)imageData classParse:(PFObject *)classe
{
    PFFile *image = [PFFile fileWithName:@"imageProfile" data:imageData];
    [[PFUser currentUser] setObject:image forKey:@"imageProfile"];
    [[PFUser currentUser] saveInBackground];
}


-(void)saveImageWithoutDelegate:(UIImage *)image nameImage:(NSString *)nameImage key:(NSString *)key{
    NSLog(@"saveImageWithoutDelegate %@ - %@", nameImage, key);
    NSData *imageData = UIImagePNGRepresentation(image);
    PFFile *imageFile = [PFFile fileWithName:nameImage data:imageData];
    [[PFUser currentUser] setObject:imageFile forKey:key];
    [[PFUser currentUser] saveInBackground];
}


-(void)animationAlpha:(UIView *)viewAnimated{
    viewAnimated.alpha = 0.0;
    [UIView animateWithDuration:0.5
                     animations:^{
                         viewAnimated.alpha = 0.9;
                     }
                     completion:^(BOOL finished){
                         [UIView animateWithDuration:3.0
                                          animations:^{
                                              viewAnimated.alpha = 1.0;
                        }];
    }];
}


+(void)arroundImage:(float)borderRadius borderWidth:(float)borderWidth layer:(CALayer *)layer
{
    CALayer * l = layer;
    [l setMasksToBounds:YES];
    [l setBorderColor:[UIColor lightGrayColor].CGColor];
    [l setBorderWidth:borderWidth];
    [l setCornerRadius:borderRadius];
}

+ (UIColor *)colorWithHexString:(NSString *)colorString
{
    colorString = [colorString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    if (colorString.length == 3)
        colorString = [NSString stringWithFormat:@"%c%c%c%c%c%c",
                       [colorString characterAtIndex:0], [colorString characterAtIndex:0],
                       [colorString characterAtIndex:1], [colorString characterAtIndex:1],
                       [colorString characterAtIndex:2], [colorString characterAtIndex:2]];
    
    if (colorString.length == 6)
    {
        int r, g, b;
        sscanf([colorString UTF8String], "%2x%2x%2x", &r, &g, &b);
        return [UIColor colorWithRed:(r/255.0) green:(g/255.0) blue:(b/255.0) alpha:1.0];
    }
    return nil;
}

@end
