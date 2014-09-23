//
//  ZoomImage.h
//  FloorPlanDemo
//
//  Created by nikhil on 09/09/14.
//  Copyright (c) 2014 nikhil. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZoomImage : UIScrollView<UIScrollViewDelegate>

//---------Properties---------//

//Image for zoom in/out
@property (nonatomic,strong) UIImage *imageToBeZoomed;      //required

//Scaling Factor for zoom in
@property (nonatomic) CGFloat scalingFactor;

//---------Method---------//

//Setup scroll(self with all required property-value pair), imageView with image to be zoom in/out(along added to self as subview) and tap gesture for zoom in/out(double tap).
- (void)initiateSetup;

@end
