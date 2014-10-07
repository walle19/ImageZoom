ImageZoom
=========

A library file(.h and .m) for image zoom in/out in iPhone and iPad. ImageZoom library is based on UIScrollView along with UIImageView (added programmatically) so it extend's UIScrollView and UIImageView properties. Provide a ease for pinch in/out in image along with a double tap to zoom in/out to and from a particular area of Image.

Example
=======

You need to add scrollView into your ViewController and assign it "ZoomImage" class. Moreover, you need to create a IBOutlet property of ZoomImage class and connect it with that scrollView that you have added in your ViewController.

    IBOutlet ZoomImage *zoomImageObj;   //Property of ZoomImage class

Later, in your ViewController's viewDidLoad you could add below lines to use this library. Before that don't forget to,

    #import "ZoomImage.h"

Place image that you want to perform zoom in/out and if not provided then a placeHolder image will be shown with alert "No ImageProvided"

    zoomImageObj.imageToBeZoomed = [UIImage imageNamed:@"YOUR_IMAGE"];        
    
You could provide detail to following and all that properties which are present in scrollView as they will be present as default.In case if you don't provide below value's then default value's are taken.

    zoomImageObj.maximumZoomScale = 10;
    zoomImageObj.minimumZoomScale = 5;
    zoomImageObj.zoomScale = 3;

Initiate setup that include adding imageView along with image that you have provided.

    [zoomImageObj initiateSetup];         

Notes
=====
Developed for iOS 8 and lesser. 

Tested on iPhone 4, 4S, 5, 5S, 6 and 6 Plus.

Tested on iPad Air ,Retina and 2.
