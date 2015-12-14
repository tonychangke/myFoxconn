//
//  TTObject.m


#import "TTObject.h"


@interface TTObject()

//@property (nonatomic, strong) NSTimer* timer;
@property (nonatomic, weak) NSTimer* timer;

@end

@implementation TTObject


-(void)dealloc {
	[self.timer invalidate];
	self.timer = nil;
	NSLog(@"%s", __func__);
}

- (void)startTimer {
	if (self.timer.isValid) return;
	
	else
		self.timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(onTimeFire ) userInfo:nil repeats:YES];
//				__weak TTObject* wkself = self;
//		self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:wkself selector:@selector(onTimeFire) userInfo:nil repeats:YES];
	
}

- (void)stopTimer {
	if (self.timer) [self.timer invalidate];
}

- (void)onTimeFire {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showView" object:nil];
}


@end
