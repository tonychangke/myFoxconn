//  CarImageViewController.h
//  CarValet

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <CoreLocation/CoreLocation.h>

@interface MapViewController : UIViewController
<UIScrollViewDelegate,CBCentralManagerDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UILabel *xlabel;
@property (strong, nonatomic) IBOutlet UILabel *ylabel;
@property (strong, nonatomic) IBOutlet UILabel *zlabel;

@property (weak, nonatomic) IBOutlet UILabel *carNumberLabel;
@property (strong, nonatomic) IBOutlet UILabel *bleLabel;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *resetZoomButton;
@property (strong,nonatomic) CMStepCounter *stepCounter;
@property (strong, nonatomic) IBOutlet UILabel *countLabel;
@property (nonatomic, strong) CBCentralManager *manager;
@property (nonatomic, strong) CMMotionManager *motionManager;

@property (nonatomic, strong) CLLocationManager *locationManager;
@property(readonly, nonatomic) CLLocationDirection trueHeading;

@property (strong,nonatomic) NSMutableArray *nAPs;
@property (strong,nonatomic)NSMutableDictionary *results;
@property (nonatomic,strong) UITextView *textView;
- (IBAction)resetZoom:(id)sender;
@end
