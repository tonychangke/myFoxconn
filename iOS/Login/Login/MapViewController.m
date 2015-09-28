//
//  CarImageViewController.m
//  CarValet

#import "MapViewController.h"


@implementation MapViewController {
    NSArray *carImageNames;
    UIImageView *image1;
    UIImageView *image2;
    NSInteger xx;

    UIView *carImageContainerView;
}


#pragma mark - Utility Methods

- (void)setupScrollContent {
    if (carImageContainerView != nil) {
        [carImageContainerView removeFromSuperview];
    }
    
    CGFloat scrollWidth = self.view.bounds.size.width;
    CGFloat totalWidth = scrollWidth * [carImageNames count];
    
    carImageContainerView = [[UIView alloc] initWithFrame:
                             CGRectMake(0.0, 0.0,
                                        totalWidth,
                                        self.scrollView.frame.size.height)];
    
    CGFloat atX = 0.0;
    CGFloat maxHeight = 0.0;
    UIImage *carImage;
    
    for (NSString *atCarImageName in carImageNames) {
        carImage = [UIImage imageNamed:atCarImageName];
        
        CGFloat scale = scrollWidth / carImage.size.width;
        
        UIImageView *atImageView = [[UIImageView alloc]
                                    initWithImage:carImage];
        
        CGFloat newHeight = atImageView.bounds.size.height * scale;
        
        atImageView.frame = CGRectMake(atX, 0.0, scrollWidth, newHeight);
        
        if (newHeight > maxHeight) {
            maxHeight = newHeight;
        }
        
        atX += scrollWidth;
        
        [carImageContainerView addSubview:atImageView];
    }
    
    CGRect newFrame = carImageContainerView.frame;
    newFrame.size.height = maxHeight;
    carImageContainerView.frame = newFrame;
    
    [self.scrollView addSubview:carImageContainerView];
    self.scrollView.contentSize = carImageContainerView.bounds.size;
    
    //CGRect CGfour = CGRectMake(250, 260, 320, 200);//
    //UIView *v_four = [[UIView alloc]initWithFrame:CGfour];//
    //v_four.backgroundColor = [UIColor orangeColor];//
    //[carImageContainerView addSubview:v_four];//
}
////////////
-(void)showview{
    [image1 removeFromSuperview];
    xx=xx+10;
    image1 = [[UIImageView alloc] initWithFrame:CGRectMake(xx,55, 20,20)];
    image1.image=[UIImage imageNamed:@"self.png"];
    [carImageContainerView addSubview:image1];
    [image2 removeFromSuperview];
    image2 = [[UIImageView alloc] initWithFrame:CGRectMake(80,60, 20,20)];
    image2.image=[UIImage imageNamed:@"friend.png"];
    [carImageContainerView addSubview:image2];
    
}
////////////



#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.resetZoomButton.enabled = NO;
    
    carImageNames = @[ @"p2.jpg",@"p3.jpg",@"p4.jpg"];
    
    [self setupScrollContent];
    ///////
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showview) name:@"showView" object:nil];
    ///////
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self updateCarNumberLabel];
}



#pragma mark - Rotation

- (void)willAnimateRotationToInterfaceOrientation:
(UIInterfaceOrientation)toInterfaceOrientation
                                         duration:(NSTimeInterval)duration {
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation
                                            duration:duration];
    
    [self setupScrollContent];
}



#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return carImageContainerView;
}


- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView
                       withView:(UIView *)view
                        atScale:(float)scale {
    
    self.resetZoomButton.enabled = scale != 1.0;
}


- (void) updateCarNumberLabel {
    NSInteger carIndex = [self carIndexForPoint:self.scrollView.contentOffset];
    
    NSString *newText = [NSString stringWithFormat:@"Car Number: %d",
                         carIndex + 1];
    
    self.carNumberLabel.text = newText;
}


- (NSInteger)carIndexForPoint:(CGPoint)thePoint {
    CGFloat pageWidth = self.scrollView.frame.size.width;
    
    pageWidth *= self.scrollView.zoomScale;
    
    return (NSInteger)(thePoint.x / pageWidth);
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self updateCarNumberLabel];
}



#pragma mark - Actions

- (IBAction)resetZoom:(id)sender
{
    [self.scrollView setZoomScale:1.0 animated:YES];
}
@end
