//
//  ZoomImage.m
//
//  Created by nikhil on 09/09/14.
//  Copyright (c) 2014 nikhil. All rights reserved.
//

#import "ZoomImage.h"

#define DEFAULT_SCALING_FACTOR 2
#define DEFAULT_MINIMUM_SCALE 1
#define DEFAULT_MAXIMUM_SCALE 5

UIImageView *_imageView;
UITapGestureRecognizer *_tap;
BOOL isZoomed;

@implementation ZoomImage

- (void)initiateSetup{
    
    NSLog(@"%@",NSStringFromCGRect(self.frame));
    //Method to initialise scroll view(self) with properties.
    [self setupScrollView];
    
    //Method to initialise Image view and add as subview in scroll view.
    [self setupImageView];
    
    //Method to add gesture for tap zoom in/out.
    [self setupTapGesture];
}

- (void)setupScrollView{
    
    //Conditional check for min/max scale value if provided then will take that value else will take default value.
    self.maximumZoomScale = (self.maximumZoomScale == 0) ? DEFAULT_MAXIMUM_SCALE : self.maximumZoomScale;
    self.minimumZoomScale = (self.minimumZoomScale == 0) ? DEFAULT_MINIMUM_SCALE: self.minimumZoomScale;
    
    //Conditional check for scaling factor for zoom-in if provided then will take that value else will take default value.
    _scalingFactor = (_scalingFactor == 0) ? DEFAULT_SCALING_FACTOR : _scalingFactor;
    
    self.zoomScale = self.minimumZoomScale;
    self.delegate =self;
    self.clipsToBounds = YES;
    [self setContentMode:UIViewContentModeScaleAspectFit];
}

- (void)setupImageView{
    
    //Initiate a imageView with frame of self(scrollView) and added to self as subview. Also add image provided for zoom effect.
#warning Provide Image to be zoom in/out.
    if(!_imageView)
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    if(!_imageToBeZoomed)
        _imageToBeZoomed = [self imageWithColor];
    
    _imageView.image = _imageToBeZoomed;
    [self addSubview:_imageView];
}

#pragma mark - Create a image for placeholder in case when no image is passed in parameter.
- (UIImage *)imageWithColor {
    CGRect rect = _imageView.frame;     //Passing imageView frame to draw image of that size.
    
    //Alert Label to let developer know if image was provided or not.
    UILabel *alertLabel = [[UILabel alloc] initWithFrame:CGRectMake(_imageView.center.x/4, _imageView.center.y/4, rect.size.width, rect.size.height)];
    alertLabel.text = @"!!! No Image provided !!!";
    [alertLabel setTextColor:[UIColor grayColor]];
    [_imageView addSubview:alertLabel];

    UIColor *color = [UIColor whiteColor];
    
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [color setFill];
    UIRectFill(rect);   // Fill it with your color
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)setupTapGesture{
    _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ImageTapped:)];
    _tap.numberOfTapsRequired = 2;
    [self addGestureRecognizer:_tap];
}

#pragma mark - Detect zoom in/out method for ImageView

//This method is called when double tap gesture is detected on scrollView(in-directly on image as scrollView is parent)
-(void)ImageTapped:(UITapGestureRecognizer*)recognizer
{
    //Below we have a isZoomed flag to check whether that image is zoomed to maximum scale or not.
    //If not zoomed to max scale then we perform the zoom in operation onto the image.
    if(!isZoomed){
        float newScale = [self zoomScale] * _scalingFactor;        //zooming
        
        NSString *scaleStr = [NSString stringWithFormat:@"newScale : %f",newScale];
        [self log:scaleStr];

        CGPoint location = [recognizer locationInView:_imageView];
        
        //In below line, we call a method with arguments that are newScale(zooming scale factor) and tap of location on the image.
        CGRect zoomRect = [self zoomRectForScale:newScale withCenter:location];
        
        NSString *ImageTapStr = [NSString stringWithFormat:@"location of tap: x - %f and y - %f",location.x,location.y];
        [self log:ImageTapStr];
        //In return from above [self zoomRectForScale: withCenter:] method we get zoomRect(frame) value for zoom-in which we pass onto the scrollView method ,that is, [self zoomToRect: animated:] method.
        [self zoomToRect:zoomRect animated:YES];
        isZoomed = true;
    }
    //Else case we perform the zoom out operation onto the image.
    else{
        
        //In this we pass the original frame of scrollView to [self zoomToRect: animated:] method to perform a zoom-out effect and show a full scale image(as original image was at first)
        [self zoomToRect:self.frame animated:YES];
        
        isZoomed = false;
    }
    [_imageView setNeedsDisplay];
}

#pragma mark - Calculate zoom in/out scale value
- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center{
    CGRect zoomRect;
    NSString *scaleStr = [NSString stringWithFormat:@"scale %f : maxi %f",scale,self.maximumZoomScale];
    [self log:scaleStr];
    
    if(scale <= self.maximumZoomScale){
        NSString *scaleStr = [NSString stringWithFormat:@"if-> Scale %f : maxi %f",scale,self.maximumZoomScale];
        [self log:scaleStr];
        
        zoomRect.size.height = [self frame].size.height / scale;
        zoomRect.size.width  = [self frame].size.width  / scale;
        
        NSString *zoomStr1 = [NSString stringWithFormat:@"ZoomRect-ForScale : H - %f, W - %f", zoomRect.size.height, zoomRect.size.width];
        [self log:zoomStr1];
        
        // choose an origin so as to get the right center.
        zoomRect.origin.x    = center.x - (zoomRect.size.width  / 2);
        zoomRect.origin.y    = center.y - (zoomRect.size.height / 2);
        
        NSString *zoomStr2 = [NSString stringWithFormat:@"zoomRect position: x - %f and y - %f",zoomRect.origin.x,zoomRect.origin.y];
        [self log:zoomStr2];
        
    }else{
        NSString *scaleStr = [NSString stringWithFormat:@"Else-> scale %f : maxi %f",scale,self.maximumZoomScale];
        [self log:scaleStr];
        zoomRect = self.frame;
    }
    return zoomRect;
}

#pragma mark - UIScrollView Delegate Method
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return _imageView;
}

- (void)log:(NSString *)logStr{
//    NSLog(@"%@",logStr);
}
@end
