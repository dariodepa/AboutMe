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
extern int MIN_CHARS_USERNAME;
extern int MIN_CHARS_PASSWORD;
extern int MIN_CHARS_NAMECOMPLETE;

@protocol CZAuthenticationDelegate
//- (void)appImageDidLoad:(NSIndexPath *)indexPath;
- (void)setProgressBar:(NSIndexPath *)indexPath progress:(float)progress;
- (void)refreshImage:(NSData *)fileData name:(NSString*)name;
@end


@interface CZAuthenticationDC : NSObject

@property (nonatomic, assign) id <CZAuthenticationDelegate> delegate;

-(void)loadImage:(PFFile *)imageFile;
-(void)saveImage:(NSData *)imageData classParse:(PFObject *)classe;
-(void)saveImageWithoutDelegate:(UIImage *)image nameImage:(NSString *)nameImage key:(NSString *)key;
-(void)animationAlpha:(UIView *)viewAnimated;

+(void)arroundImage:(float)borderRadius borderWidth:(float)borderWidth layer:(CALayer *)layer;
+(UIColor *)colorWithHexString:(NSString *)colorString;


@end
