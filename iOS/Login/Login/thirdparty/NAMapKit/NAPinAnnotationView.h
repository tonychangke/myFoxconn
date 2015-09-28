#import <UIKit/UIKit.h>
#import "NAAnnotation.h"
#import "NACallOutView.h"
#import "NAMapView.h"

@interface NAPinAnnotationView : UIButton {
	@private
	NAAnnotation *_annotation;
}

- (CGRect)frameForPoint:(CGPoint)point;

- (id)initWithAnnotation:(NAAnnotation *)annotation onView:(NAMapView *)mapView animated:(BOOL)animate;

@property (nonatomic, retain) NAAnnotation *annotation;

@end
