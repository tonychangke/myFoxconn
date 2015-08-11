#import "DemoViewController.h"

@implementation DemoViewController

@synthesize mapView;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	[mapView displayMap:[UIImage imageNamed:@"123.png"]];
	
	NAAnnotation * place1 = [NAAnnotation annotationWithPoint:CGPointMake(543, 489)];
	place1.title = @"place1";
	place1.subtitle = @"subtitle";
	[mapView addAnnotation:place1 animated:NO];
	
	NAAnnotation * place2 = [NAAnnotation annotationWithPoint:CGPointMake(63, 379)];
	place2.title = @"place2";
	
	place2.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
	
	[mapView addAnnotation:place2 animated:YES];
	
	NAAnnotation * place3 = [NAAnnotation annotationWithPoint:CGPointMake(679, 302)];
	place3.title = @"place3";
	[mapView addAnnotation:place3 animated:NO];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)dealloc {
    [super dealloc];
}

@end
