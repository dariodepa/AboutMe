//
//  CZAuthenticationDC.h
//  AboutMe
//
//  Created by Dario De pascalis on 11/04/15.
//  Copyright (c) 2015 Dario De Pascalis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

extern NSString *NAME_IMAGE_PROFILE;
extern NSString *KEY_IMAGE_PROFILE;
extern CGFloat MIN_CHARS_USERNAME;
extern CGFloat MIN_CHARS_PASSWORD;
extern CGFloat MIN_CHARS_NAMECOMPLETE;

@interface CZAuthenticationDC : NSObject

-(void)saveImageWithoutDelegate:(UIImage *)image nameImage:(NSString *)nameImage key:(NSString *)key;


@end
