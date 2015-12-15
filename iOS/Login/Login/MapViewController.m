//
//  CarImageViewController.m
//  CarValet

#import "MapViewController.h"
#import "RSSModel.h"
#import "offline.h"

@implementation MapViewController {
    NSArray *carImageNames;//arguments of showing images
    UIImageView *image1;
    UIImageView *image2;
    
    double xx;//arguments of movement
    double yy;
    double zAccel;
    NSInteger deltax;
    NSInteger step;
    NSInteger deltaz;
    NSInteger checkMove;
    NSInteger checkRotate;
    NSInteger moving;
    
    UIView *carImageContainerView;
    NSFileHandle *outFile;
    CMAttitude *initAttitude;
    
    double startX;//the x coordinate of the start point
    double startY;//the y coordinate of the start point
    double boundaryXmin;
    double boundaryXmax;
    double boundaryYmin;
    double boundaryYmax;
    
    NSInteger num;//arguments of ble measuring
    NSInteger bleChange;
    NSMutableDictionary *rssReceived;
    RSSModel *sample;
    //OffLine *location;
    ///////
    
    double bleRSS[7];//arguments of ble based position determination
    int bleTime[7];
    int testTime;
    
}


#pragma mark - Utility Methods
-(double)magnitudeFromAttitude:(CMAttitude *)attitude {
    return sqrt(pow(attitude.roll, 2.0f) + pow(attitude.yaw, 2.0f) + pow(attitude.pitch, 2.0f));
}

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
    
    
    CMAccelerometerData *newestAccel = self.motionManager.accelerometerData;
    CMDeviceMotion *deviceMotion = self.motionManager.deviceMotion;
    [self.motionManager startDeviceMotionUpdates];
    
    
    
    
    
    double x = newestAccel.acceleration.x;
    //NSLog(@"%lf",x);
    NSString *str = [NSString stringWithFormat:@"%lf",x];
    NSData  *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [outFile writeData:data];
    double y = newestAccel.acceleration.y;
    str = [NSString stringWithFormat:@"%lf",y];//NSLog(@"%lf",y);
    data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [outFile writeData:data];
    double z = newestAccel.acceleration.z;
    str = [NSString stringWithFormat:@"%lf",z];//NSLog(@"%lf",z);
    data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [outFile writeData:data];
    
    
    
    
    
    
    
    
    //CMGyroData *newestgyro = self.motionManager.gyroData;
    // CLHeading *heading = self.locationManager.heading;
    
    self.motionManager.accelerometerUpdateInterval = 0.01; // 告诉manager，更新频率是100Hz
    [self.motionManager startAccelerometerUpdates];
    
    
    if (!self.motionManager.gyroAvailable) {
        [self.xlabel setText:[NSString stringWithFormat:@"%@",@"disabled"]];
        [self.ylabel setText:[NSString stringWithFormat:@"%@",@"disabled"]];
        [self.zlabel setText:[NSString stringWithFormat:@"%@",@"disabled"]];     }
    
    else{
        self.motionManager.gyroUpdateInterval = 0.01; // 告诉manager，更新频率是100Hz
        [self.motionManager startGyroUpdates];
        
        
        
        
    }
    
    /* [self.locationManager requestAlwaysAuthorization];
     if(!self.locationManager){[self.xlabel setText:[NSString stringWithFormat:@"%@",@"disabled"]];
     [self.locationManager requestAlwaysAuthorization];
     
     }
     else{
     self.locationManager = [[CLLocationManager alloc] init];
     self.locationManager.delegate = self;
     [self.locationManager startUpdatingHeading];
     
     //self.locationManager.h
     [self.zlabel setText:[NSString stringWithFormat:@"%f",heading.trueHeading]];
     }*/
    
    
    self.results=[[NSMutableDictionary alloc]init];
    
    
    
    [_manager scanForPeripheralsWithServices:nil options:@{CBCentralManagerScanOptionAllowDuplicatesKey : @YES }];
    [image1 removeFromSuperview];
    
    
    //********** moving part**************//
    zAccel = newestAccel.acceleration.z+cos(deviceMotion.attitude.pitch);
    [self.zlabel setText:[NSString stringWithFormat:@"%f",zAccel]];
    
    moving=0;
    if(zAccel<-0.06||zAccel>0.06)moving=1;checkMove=3;
    if(checkMove==0)
    {
        if(zAccel+1>-0.06&&zAccel<0.06)moving=0;
        
    }
    
    step=20;
    
    if(moving==1){
        double tmpxx = xx-step*sin(deviceMotion.attitude.yaw);
        
        
        double tmpyy = yy-step*cos(deviceMotion.attitude.yaw);
        
        if((tmpxx+startX<boundaryXmax)&&(tmpxx+startX>boundaryXmin)&&(tmpyy+startY<boundaryYmax)&&(tmpyy+startY>boundaryYmin))
        {
            //NSLog(@"%d",1);
            xx = tmpxx;
            yy = tmpyy;
        }
        
        
        checkMove--;
    }
    
    
    
    image1 = [[UIImageView alloc] initWithFrame:CGRectMake(xx+startX,yy+startY, 20,20)];
    image1.image=[UIImage imageNamed:@"self.png"];
    [carImageContainerView addSubview:image1];
    [image2 removeFromSuperview];
    image2 = [[UIImageView alloc] initWithFrame:CGRectMake(80,60, 20,20)];
    image2.image=[UIImage imageNamed:@"friend.png"];
    [carImageContainerView addSubview:image2];
    
    
    if(checkMove>0)checkMove=checkMove-1;
    if(checkRotate>0)checkRotate=checkRotate-1;
}
///************** moving part end ****************



#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.locationManager requestAlwaysAuthorization];
    [self.locationManager startUpdatingHeading];
    [self.motionManager startDeviceMotionUpdates];
    
    //xx = 0;
    //yy = 0;
    testTime = 30;
    
    startX = 20;
    startY = 285;
    boundaryXmin = 15;
    boundaryYmin = 30;
    boundaryXmax = 290;
    boundaryYmax = 290;
    
    
   // CMAttitude * initAttitude = self.motionManager.deviceMotion.attitude;
    
    [[NSFileManager defaultManager]createFileAtPath:@"/Users/localization/Desktop/Login-2/Login/test.txt" contents:nil attributes:nil];
    
    outFile = [NSFileHandle fileHandleForWritingAtPath:@"/Users/localization/Desktop/Login-2/Login/test.txt"];
    
    if (outFile==nil) {
        NSLog(@"File open error");
        
    }
    
    
    _manager=[[CBCentralManager alloc]initWithDelegate:self queue:nil];
    _nAPs=[[NSMutableArray alloc]init];
    //_textView = [[UITextView alloc]initWithFrame:CGRectMake(10, 250, 300, 200)];
    //[self.view addSubview:_textView];
    self.results=[[NSMutableDictionary alloc]init];
    
    
    self.resetZoomButton.enabled = NO;
    carImageNames = @[ @"room445.jpg",@"p3.jpg",@"p4.jpg"];
    [self setupScrollContent];
    ///////
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showview) name:@"showView" object:nil];
    ///////
    self.motionManager = [[CMMotionManager alloc] init];
    
    moving=0;
    
    sample = [[RSSModel alloc] init];
    
    
    
    
    
    
    
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self updateCarNumberLabel];
}



#pragma mark - Rotation

- (void)willAnimateRotationToInterfaceOrientation:
(UIInterfaceOrientation)toInterfaceOrientation
                                         duration:(NSTimeInterval)duration{
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
                        atScale:(CGFloat)scale {
    
    self.resetZoomButton.enabled = scale != 1.0;
}


- (void) updateCarNumberLabel {
    //NSInteger carIndex = [self carIndexForPoint:self.scrollView.contentOffset];
    
    //  NSString *newText = [NSString stringWithFormat:@"Car Number: %ld",
    //                       carIndex + 1];
    
    //  self.carNumberLabel.text = newText;
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

-(void)updateLog:(NSString *)s
{
    static unsigned int count = 0;
    // [_textView setText:[NSString stringWithFormat:@"[ %d ]  %@\r\n%@",count,s,_textView.text]];
    count++;
}

-(void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    switch (central.state) {
        case CBCentralManagerStatePoweredOn:
            [self updateLog:@"蓝牙已打开,请扫描外设"];
            break;
        default:
            break;
    }
}

-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    //NSLog(@"%@ 's rssi is %@",peripheral.identifier.UUIDString,RSSI);
    [_results setValue:[NSString stringWithFormat:@"%@",RSSI] forKey:[NSString stringWithFormat:@"%@",peripheral.identifier.UUIDString]];
    
    NSString *uuid = [peripheral.identifier.UUIDString substringFromIndex:24];
    
    //NSLog(uuid);
    
    int tmp;
    tmp = [RSSI intValue];
    bool flag = true;
    
    for(int i=0;i<7;++i)
    {
        //NSLog(@"%d",bleTime[i]);
        if(bleTime[i]<testTime)flag = false;//NSLog(@"%d",i);
        
    }
    
    if(!flag)
    {
        //NSLog(@"*");
        if([uuid isEqualToString:@"2311FF526C8C"])
        {
            //NSLog(@"changed1");
            bleRSS[0] += tmp;
            bleTime[0]++;
        }
        if([uuid isEqualToString:@"E57FB07C0991"])
        {
            //NSLog(@"changed2");
            bleRSS[1] += tmp;
            bleTime[1]++;
        }
        if([uuid isEqualToString:@"B088AB1A62A3"])
        {
            //NSLog(@"changed3");
            bleRSS[2] += tmp;
            bleTime[2]++;
            
        }
        if([uuid isEqualToString:@"E23E35A0F0A1"])
        {
            //NSLog(@"changed4");
            bleRSS[3] += tmp;
            bleTime[3]++;
            
        }
        if([uuid isEqualToString:@"FF5F466294F1"])
        {
            //NSLog(@"changed5");
            bleRSS[4] += tmp;
            bleTime[4]++;
            
        }
        if([uuid isEqualToString:@"3996EB5E586B"])
        {
            //NSLog(@"changed6");
            bleRSS[5] += tmp;
            bleTime[5]++;
            
        }
        if([uuid isEqualToString:@"508B41ADB4ED"])
        {
            //NSLog(@"changed7");
            bleRSS[6]+= tmp;
            bleTime[6]++;
            
        }
        
        
    }
    else
    {
        NSLog(@"&");
        int maxID = 0;
        for(int i=0;i<7;++i)
        {
            NSLog(@"%f",bleRSS[i]/bleTime[i]);
            NSLog(@"%d",bleTime[i]);
            if(bleRSS[i]/bleTime[i]>bleRSS[maxID]/bleTime[maxID])maxID=i;
        }
        NSLog(@"%d",maxID);
        
        
        if (maxID == 0 && bleRSS[maxID]/bleTime[maxID]>-100) {
            xx = 30;
            yy = -80;
        }
        if (maxID == 1 && bleRSS[maxID]/bleTime[maxID]>-100) {
            xx = 30;
            yy = -160;
        }
        if (maxID == 2 && bleRSS[maxID]/bleTime[maxID]>-100) {
            xx=100;
            yy=-10;
        }
        if (maxID == 3 && bleRSS[maxID]/bleTime[maxID]>-100) {
            xx = 200;
            yy = -10;
        }
        if (maxID == 4 && bleRSS[maxID]/bleTime[maxID]>-100) {
            xx = 270;
            yy = -50;
        }
        if (maxID == 5 && bleRSS[maxID]/bleTime[maxID]>-100) {
            xx = 270;
            yy = -100;
        }
        if (maxID == 6 && bleRSS[maxID]/bleTime[maxID]>-100) {
            xx = 270;
            yy = -180;
        }
        
        for(int i=0;i<7;++i)
        {
            //NSLog(@"%f",bleRSS[i]);
            bleRSS[i]=0;
            bleTime[i]=0;
        }
        
        
    }
    
    
    
    
    /*
     if(tmp>-50&&bleChange==0)
     {
     
     
     
     if([uuid isEqualToString:@"2311FF526C8C"])
     {
     NSLog(@"changed1");
     bleChange = 10;
     xx = 30;
     yy = -80;
     }
     if([uuid isEqualToString:@"E5FB07C0991"])
     {
     NSLog(@"changed2");
     bleChange = 10;
     xx = 30;
     yy = -160;
     }
     if([uuid isEqualToString:@"B088AB1A62A3"])
     {
     NSLog(@"changed3");
     bleChange = 10;
     xx=100;
     yy=-10;
     }
     if([uuid isEqualToString:@"E23E35A0F0A1"])
     {
     NSLog(@"changed4");
     bleChange = 10;
     xx = 200;
     yy = -10;
     }
     if([uuid isEqualToString:@"FF5F466294F1"])
     {
     NSLog(@"changed5");
     bleChange = 10;
     xx = 270;
     yy = -50;
     }
     if([uuid isEqualToString:@"3996EB5E586B"])
     {
     NSLog(@"changed6");
     bleChange = 10;
     xx = 270;
     yy = -100;
     }
     if([uuid isEqualToString:@"508B41ADB4ED"])
     {
     NSLog(@"changed7");
     bleChange = 10;
     xx = 270;
     yy = -180;
     }
     
     }
     
     if(bleChange>0)bleChange--;
     */
    
    
    
    
    // to-do 查询UUID是否在已知设备列表
    //if([peripheral.identifier.UUIDString isEqualToString:@"468B03B5-5702-0794-7B1B-7E5A89760ECD"]){}
    //else return;
    
    
    if (!rssReceived)
        rssReceived = [[NSMutableDictionary alloc] init];
    BOOL existed = NO;
    for (NSString* key in rssReceived) {
        if ([key isEqualToString:peripheral.identifier.UUIDString]) {
            existed = YES;
            break;
        }
    }
    if (!existed) {
        [rssReceived setObject:[NSString stringWithFormat:@"%@",RSSI] forKey:peripheral.identifier.UUIDString];
    }
    NSMutableArray *rssArray = [[NSMutableArray alloc] init]; // of string
    for (id key in rssReceived) {
        NSString *value = [rssReceived objectForKey:key];
        [rssArray addObject:value];
    }
    
    [sample rssInput:rssArray];
    
    //
    //    NSMutableDictionary *test=[[NSMutableDictionary alloc]init];
    //    [test setValue:@"TEST" forKey:@"fd"];
    //    NSLog(@"333");
    //    [self updateLog:[NSString stringWithFormat:@"已发现 peripheral: %@ rssi: %@, UUID: %@ advertisementData: %@ ", peripheral, RSSI, peripheral.UUID, advertisementData]];
    //    [self.manager stopScan];
    //    //[UIActivity stopAnimating];
    //    BOOL replace = NO;
    //     //Match if we have this device from before
    //    for (int i=0; i < _nDevices.count; i++) {
    //        CBPeripheral *p = [_nDevices objectAtIndex:i];
    //        if ([p isEqual:peripheral]) {
    //            [_nDevices replaceObjectAtIndex:i withObject:peripheral];
    //            replace = YES;
    //        }
    //    }
    //    if (!replace) {
    //        [_nDevices addObject:peripheral];
    //        [_deviceTable reloadData];
    //    }
    //
    //    //added by xd
    //    int tem=[RSSI intValue];
    //
    //    NSNumber *x1 =[NSNumber numberWithInt:1];
    //    NSNumber *x2 =[NSNumber numberWithInt:-1];
    //    NSNumber *x3 =[NSNumber numberWithInt:1];
    //    NSNumber *x4 =[NSNumber numberWithInt:-1];
    //    NSMutableArray *array1 = [[NSArray alloc] initWithObjects:x1,x2,x3,x4,nil];
    //    NSNumber *y1 =[NSNumber numberWithInt:1];
    //    NSNumber *y2 =[NSNumber numberWithInt:-1];
    //    NSNumber *y3 =[NSNumber numberWithInt:-1];
    //    NSNumber *y4 =[NSNumber numberWithInt:1];
    //    NSMutableArray *array2 = [[NSArray alloc] initWithObjects:y1,y2,y3,y4,nil];
    //    NSNumber *noise1 =[NSNumber numberWithInt:10];
    //    NSNumber *sigma1 =[NSNumber numberWithInt:5];
    //    NSMutableArray *res;
    //    NSMutableArray *gra;
    //    NSLog(@"222");
    //    [sample.RSS_receive addObject:RSSI];
    //    num=num+1;
    //    //if (num==sample.numOfAP) {
    //    [sample initwithAPx:array1 APy:array2 num:4 posX:y4 posY:y2 noise:noise1 sigma:sigma1];
    //        //location.distance=sample.distance;
    //    [location initWithAPNumber:4 x:array1 y:array2 distance:sample.distance theta:res grad:gra];
    //        [location gradient];
    //        num=0;
    //   // NSLog(@"%@",location.theta);
    //    [location.theta addObject:@"test"];
    //    //NSLog(@"%@",location.theta);
    //    [self.bleLabel setText:[NSString stringWithFormat:@"%@",location.theta]];
    //    }
}

@end


