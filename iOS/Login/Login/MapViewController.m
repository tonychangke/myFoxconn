//
//  CarImageViewController.m
//  CarValet

#import "MapViewController.h"
#import "RSSModel.h"
#import "offline.h"
#import "AFNetworking.h"
#import "loginAppDelegate.h"
#import "TTObject.h"

@interface MapViewController()
@property (strong,nonatomic ) NSMutableArray *rssArray; // of string
@property (strong,nonatomic ) NSMutableArray *Rsscache1;//滤波缓存区
@property (strong,nonatomic ) NSMutableArray *Rsscache2;//滤波缓存区
@property (strong,nonatomic ) NSMutableArray *Rsscache3;//滤波缓存区
@property (strong,nonatomic ) NSMutableArray *Rsscache4;//滤波缓存区
@property (strong,nonatomic ) NSMutableArray *Rsscache5;//滤波缓存区
@property (strong,nonatomic ) NSMutableArray *Rsscache6;//滤波缓存区

@end

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
    
    
    double viewX;
    double viewY;
    double startX;//the x coordinate of the start point
    double startY;//the y coordinate of the start point
    double boundaryXmin;
    double boundaryXmax;
    double boundaryYmin;
    double boundaryYmax;
    double initDirection;
    double oldDirection;
    double currentDirection;
    double mapDirection;
    
    NSInteger num;//arguments of ble measuring
    NSInteger bleChange;
    ///////
    //NSInteger i;
    NSInteger j;
    NSInteger k;
    NSInteger l;
    NSInteger m;
    NSInteger n;
    NSInteger sum1;
    NSInteger sum2;
    NSInteger sum3;
    NSInteger sum4;
    NSInteger sum5;
    NSInteger sum6;
    //////
    NSMutableDictionary *rssReceived;
    RSSModel *sample;
    //OffLine *location;
    ///////
    
    double bleRSS[8];//arguments of ble based position determination
    int bleNum;
    int bleTime[8];
    int testTime;
    double bleposx[7];//蓝牙位置
    double bleposy[7];
    int std;
    int RssAvg[7];
    int sum;
    double posx;
    double posy;
    
    NSInteger where;
    TTObject *timer;
}

- (NSMutableArray *)rssArray {
    if (!_rssArray )
        
        _rssArray = [[NSMutableArray alloc] init];
    return _rssArray;
}
- (NSMutableArray *)Rsscache1 {
    if (!_Rsscache1 )
        
        _Rsscache1 = [[NSMutableArray alloc] init];
    return _Rsscache1;
}
- (NSMutableArray *)Rsscache2 {
    if (!_Rsscache2 )
        
        _Rsscache2 = [[NSMutableArray alloc] init];
    return _Rsscache2;
}
- (NSMutableArray *)Rsscache3 {
    if (!_Rsscache3 )
        
        _Rsscache3 = [[NSMutableArray alloc] init];
    return _Rsscache3;
}
- (NSMutableArray *)Rsscache4 {
    if (!_Rsscache4 )
        
        _Rsscache4 = [[NSMutableArray alloc] init];
    return _Rsscache4;
}
- (NSMutableArray *)Rsscache5 {
    if (!_Rsscache5 )
        
        _Rsscache5 = [[NSMutableArray alloc] init];
    return _Rsscache5;
}
- (NSMutableArray *)Rsscache6 {
    if (!_Rsscache6 )
        
        _Rsscache6 = [[NSMutableArray alloc] init];
    return _Rsscache6;
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
-(void)uploadPosition{
    NSString *url = @"http://202.120.36.137:5000/update_position/";
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    manager.responseSerializer=[AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    loginAppDelegate *delegate=(loginAppDelegate *)[[UIApplication sharedApplication]delegate];
    NSDictionary *parameters = @{@"userid": @"admin",@"position":[NSString stringWithFormat:@"%@,%f,%f",@"0",xx+startX+viewX,yy+startY+viewY]};
    
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"Success");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //NSLog(@“Login error:%@“,error);
    }];
    return;
}
-(void)getBLEs{
    NSString *url = @"http://202.120.36.137:5000/login/";
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    manager.responseSerializer=[AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    NSDictionary *parameters = @{@"mapid": @"1"};
    
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        timer=[[TTObject alloc]init];
        [timer startTimer];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Login error:%@",error);
    }];
    return;
}
-(void)showview{
    
    if (bleChange >0) {
        self.bleChangeLabel.text = [NSString stringWithFormat:@"%lf",bleChange/5.0];
    }
    else self.bleChangeLabel.text = [NSString stringWithFormat:@"ready"];
    
    NSNumber *tmp;
    NSString *sliderValue;
    tmp = [NSNumber numberWithDouble:initDirection];
    sliderValue = [tmp stringValue];
    [self.sliderLabel setText:sliderValue];
    
    CMAccelerometerData *newestAccel = self.motionManager.accelerometerData;
    CMDeviceMotion *deviceMotion = self.motionManager.deviceMotion;
    [self.motionManager startDeviceMotionUpdates];
    initDirection = self.directionSlider.value;
    initDirection = (initDirection-0.5)*3.14159*2;
    
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
    
    currentDirection = initDirection-deviceMotion.attitude.yaw+mapDirection;
    
    
    if (oldDirection - currentDirection >0.2) {
        step = 6;
    }
    else step = 12;
    oldDirection = currentDirection;
    
    if(moving==1){
        if(bleChange>0)bleChange--;
        double tmpxx = xx+step*sin(currentDirection);
        double tmpyy = yy-step*cos(currentDirection);
        //NSLog(@"%i",[self checkObstacle:tmpxx+startX Ycoordinate:tmpyy+startY]);
        if((tmpxx+startX<boundaryXmax)&&(tmpxx+startX>boundaryXmin)&&(yy+startY<boundaryYmax)&&(yy+startY>boundaryYmin)&&[self checkObstacle:tmpxx+startX Ycoordinate:yy+startY])
        {
            //NSLog(@"%d",1);
            xx = tmpxx;
        }
        if((xx+startX<boundaryXmax)&&(xx+startX>boundaryXmin)&&(tmpyy+startY<boundaryYmax)&&(tmpyy+startY>boundaryYmin)&&[self checkObstacle:xx+startX Ycoordinate:tmpyy+startY])
        {
            //NSLog(@"%d",1);
        
            yy = tmpyy;
        }
      
        
        
        checkMove--;
    }
    
    [self uploadPosition];
    
    image1 = [[UIImageView alloc] initWithFrame:CGRectMake(xx+startX+viewX,yy+startY+viewY, 40,40)];
    image1.image=[UIImage imageNamed:@"arrow.png"];
    [carImageContainerView addSubview:image1];
    image1.transform = CGAffineTransformMakeRotation(currentDirection);
    
    [image2 removeFromSuperview];
    image2 = [[UIImageView alloc] initWithFrame:CGRectMake(80,60, 20,20)];
    image2.image=[UIImage imageNamed:@"friend.png"];
    [carImageContainerView addSubview:image2];
    
    
    if(checkMove>0)checkMove=checkMove-1;
    if(checkRotate>0)checkRotate=checkRotate-1;
    
    if(where == 1 && xx+startX>150 && yy+startY>350)
    {
        where = 2;
        startX = 50;
        startY = 320;
        mapDirection = -3.1415/2;
        xx = 0;
        yy = 0;
        carImageNames = @[@"room445.jpg"];
        NSLog(@"to room445");
        [self setupScrollContent];
        boundaryXmax = 340;
        boundaryYmax = 340;
    }
    if(where == 2 && xx+startX<40 && yy+startY > 330)
    {
        where = 1;
        startX = 100;
        startY = 330;
        mapDirection=0;
        NSLog(@"to floor");
        carImageNames = @[ @"floor.png"];
        [self setupScrollContent];
        boundaryXmax = 400;
        boundaryYmax = 400;
        
    }
    
    
}
///************** moving part end ****************



#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.locationManager requestAlwaysAuthorization];
    [self.locationManager startUpdatingHeading];
    [self.motionManager startDeviceMotionUpdates];
    
    bleChange = 15;
    
    bleNum = 6;
    bleposx[0] = 130;
    bleposy[0] = 320;
    bleposx[1] = 270;
    bleposy[1] = 320;
    
    //xx = 0;
    //yy = 0;
    where = 1;
    mapDirection = 0;
    oldDirection = 0;
    
    viewX = 0;
    viewY = 0;
    
    testTime = 5;
    
    startX = 90;
    startY = 60;
    boundaryXmin = 15;
    boundaryYmin = 30;
    boundaryXmax = 400;
    boundaryYmax = 400;
    
    for (int i = 0;i<bleNum;++i)
    {
        bleRSS[i] = 0;
        bleTime[i] = 0;
    }
    
    
    
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
    carImageNames = @[ @"floor.png"];
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

- (bool)checkObstacle:(int)tmpx Ycoordinate:(int)tmpy {
    if(where == 2){
        if (tmpx<50&&tmpy<280)
            return false;
        if (tmpx<140&&tmpx>110&&tmpy<260)
            return false;
        if (tmpx<250&&tmpx>190&&tmpy<290)
            return false;
        if (tmpx>320)
            return false;
        if (tmpy<60)
            return false;
        if (tmpy>360)
            return false;
        return true;
    }
    else{
        if(tmpx<45)
            return false;

        if(tmpx>100&&tmpy<320)
            return false;
        return true;
    }


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
    if (moving == 1) {
        return;
    }
    
    [_results setValue:[NSString stringWithFormat:@"%@",RSSI] forKey:[NSString stringWithFormat:@"%@",peripheral.identifier.UUIDString]];
    
    NSString *uuid = [peripheral.identifier.UUIDString substringFromIndex:24];
    //NSLog(@"%@ 's rssi is %@",uuid,RSSI);
   
    
    int tmp;
    tmp = [RSSI intValue];
    std=-70;
    if(tmp<-90||tmp >0)return;
    
    //if ([uuid isEqualToString:@"71D84185E43E"])
    //{
    //    NSLog(@"%@",RSSI);
    //}
    
    bool flag = true;
    
    
    
    for(int i=0;i<bleNum;++i)
    {
        //NSLog(@"%d",bleTime[i]);
        if(bleTime[i]<testTime)flag = false;//NSLog(@"%d",i);
        
    }
    
    if(!flag&&bleChange==0)
    {
        if([uuid isEqualToString:@"71D84185E43E"])
        {
            //NSLog(@"changed1");
            //NSLog(@"uuid 's rssi is %@", RSSI);
            bleRSS[0] += tmp;
            bleTime[0]++;
        }
        if([uuid isEqualToString:@"79004F7CDDBC"])
        {
            //NSLog(@"changed2");
            //NSLog(@"uuid 's rssi is %@", RSSI);
            bleRSS[1] += tmp;
            bleTime[1]++;
        }
        if([uuid isEqualToString:@"DED65D22A19C"])
        {
            //NSLog(@"changed5");
            bleRSS[2] += tmp;
            bleTime[2]++;
            
        }
        if([uuid isEqualToString:@"4FB56F7111CE"])
        {
            //NSLog(@"changed6");
            bleRSS[3] += tmp;
            bleTime[3]++;
            
        }
        if([uuid isEqualToString:@"552001760663"])
        {
            //NSLog(@"changed7");
            bleRSS[4]+= tmp;
            bleTime[4]++;
            
        }
        if([uuid isEqualToString:@"C10BBAD3DE9C"])
        {
            //NSLog(@"changed7");
            bleRSS[5]+= tmp;
            bleTime[5]++;
            
        }
        
        
    }
    else
    {
        if(bleChange == 0)
        {
            int maxID = 0;
            for(int i=0;i<bleNum;++i)
            {
                //NSLog(@"%f",bleRSS[i]/bleTime[i]);
                //NSLog(@"%d",bleTime[i]);
                if(bleRSS[i]/bleTime[i]>bleRSS[maxID]/bleTime[maxID])maxID=i;
            }
            
            if (maxID == 0 && bleRSS[maxID]/bleTime[maxID]>-55) {
                bleChange = 15;
                NSLog(@"AT 0");
                xx = 240;
                yy = 10;
            }
            if (maxID == 1 && bleRSS[maxID]/bleTime[maxID]>-55) {
                bleChange = 15;
                NSLog(@"AT 1");
                xx = 120;
                yy = 20;
            }
            if (maxID == 2 && bleRSS[maxID]/bleTime[maxID]>-1) {
                bleChange = 15;
                NSLog(@"AT 2");
                xx=0;
                yy=0;
            }
            if (maxID == 3 && bleRSS[maxID]/bleTime[maxID]>-48) {
                bleChange = 15;
                NSLog(@"AT 3");
                xx = 0;
                yy = 70-startY;
            }
            if (maxID == 4 && bleRSS[maxID]/bleTime[maxID]>-55) {
                bleChange = 15;
                NSLog(@"AT 4");
                xx = 120;
                yy = 70-startY;
            }
            if (maxID == 5 && bleRSS[maxID]/bleTime[maxID]>-55) {
                bleChange = 15;
                NSLog(@"AT 5");
                xx = 250;
                yy = 70-startY;
            }
            /*if (maxID == 6 && bleRSS[maxID]/bleTime[maxID]>-65) {
                NSLog(@"AT 6");
                xx = 280;
                yy = 20;
            }
            if (maxID == 7 && bleRSS[maxID]/bleTime[maxID]>-65) {
                NSLog(@"AT 7");
                xx = 320;
                yy = -50;
            }
             */
            
            for(int i=0;i<bleNum;++i)
            {
                
                bleRSS[i]=0;
                bleTime[i]=0;
            }
            
            
        
         /*   NSLog(@"&");
            // int maxID = 0;
            for(int i=0;i<7;++i)
            {
                NSLog(@"%f",bleRSS[i]/bleTime[i]);
                NSLog(@"%d",bleTime[i]);
                RssAvg[i]=bleRSS[i]/bleTime[i];
            }
            
            for(int i=0;i<7;i++ )
            {
                if(RssAvg[i]!=0)
                {
                    if (RssAvg[i]>std)
                    {
                        sum+=RssAvg[i]-std;
                    }
                    
                    
                }
                
            }
            for (int i=0;i<7;i++)
            {
                if(RssAvg[i]!=0)
                {
                    if (RssAvg[i]>std)
                    {
                        posx=bleposx[i]*((RssAvg[i]-std)/(double)sum);
                        posy=bleposy[i]*((RssAvg[i]-std)/(double)sum);
                    }
                    
                }
                
            }
            xx = posx - startX;//xx是相对门的位置，posx是实际位置，这里需要写出两者的转换关系,多闻！这里不要忘记改！
            yy = posy - startY;
            
            for(int i=0;i<7;++i)
            {
                //NSLog(@"%f",bleRSS[i]);
                bleRSS[i]=0;
                bleTime[i]=0;
                RssAvg[i]=0;
            }*/
           
        }
        
    }
    
    
    
    //NSLog(@"%@",RSSI);
    // to-do 查询UUID是否在已知设备列表
    //if([peripheral.identifier.UUIDString isEqualToString:@"468B03B5-5702-0794-7B1B-7E5A89760ECD"]){}
    //else return;
    
    
    /*if (!rssReceived)
        rssReceived = [[NSMutableDictionary alloc] init];
    BOOL existed = NO;
    NSString* key;
    key = uuid;
    /*for (key in rssReceived) {
        key = [key substringFromIndex:24];
        if ([key isEqualToString:peripheral.identifier.UUIDString]) {
            existed = YES;
            break;
        }
    }
    if (!existed) {
        [rssReceived setObject:[NSString stringWithFormat:@"%@",RSSI] forKey:peripheral.identifier.UUIDString];
    }
    
    
    [self.rssArray addObject:@"123"];
    [self.rssArray addObject:@"123"];
    [self.rssArray addObject:@"123"];
    [self.rssArray addObject:@"123"];
    [self.rssArray addObject:@"123"];
    [self.rssArray addObject:@"123"];
    //for (id key in rssReceived) {
    
        NSString *value = [rssReceived objectForKey:key];
        float valuenum=[value floatValue];
    
    
        if ([key isEqualToString:@"2311FF526C8C"])
        {
            NSLog(@"1");
            NSLog(key);
            if (i==10)  {[self.Rsscache1 removeObjectAtIndex:0];i=i-1;}
            self.Rsscache1[i]=[NSNumber numberWithFloat:valuenum];
            
            if(i==9)
            {
                for (int a=0;a<=9;a++)
                {sum1 =sum1+[self.Rsscache1[a] floatValue];}
                sum1=sum1/10;//求均值
                self.rssArray[0]=[NSNumber numberWithFloat:sum1];
                sum1=0;
                
            }
            if (i<10) i=i+1;
            xx = 0;
            yy = 0;
        }
    */
        //threshold
        //
        //        if ([key isEqualToString:@"uuid1"])
        //        {   if(i<=9)
        //           {self.Rsscache1[i]=[NSNumber numberWithFloat:valuenum];//*
        //               i=i+1;
        //           }
        //            if(i==10)
        //            {   int length;
        //                length=10;
        //                for (int a=0;a<=9;a++)
        //                  {sum1 =sum1+[self.Rsscache1[a] floatValue];}  //***
        //                   sum1=sum1/10;//求均值   //**
        //                for(int a=0;a<=9;a++)
        //                {
        //                    if([self.Rsscache1[a] floatValue]>sum1*1.1 ) //*
        //                    {
        //                        sum1+=[self.Rsscache1[a] floatValue];//**
        //                        length=length-1;
        //                    }
        //                }
        //
        //                sum1=sum1/length ;//过滤后求均值   //**
        //                self.rssArray[0]=[NSNumber numberWithFloat:sum1];//**
        //                [self.Rsscache1 removeAllObjects];//*
        //                i=0;
        //                sum1=0;//*
        //            }
        //        }
        
        //////////////
        
     /*  if ([key isEqualToString:@"508B41ADB4ED"])
        {NSLog(@"2");
            if (j==10)  {[self.Rsscache2 removeObjectAtIndex:0];j=j-1;}
            self.Rsscache2[j]=[NSNumber numberWithFloat:valuenum];
            
            if(j==9)
            {
                for (int a=0;a<=9;a++)
                {sum2 =sum2+[self.Rsscache2[a] floatValue];}
                sum2=sum2/10;//求均值
                self.rssArray[1]=[NSNumber numberWithFloat:sum2];
                sum2=0;
            }
            if (j<10) j=j+1;
            xx =23;
            yy =220;
        }
        
        if ([key isEqualToString:@"3996EB5E586B"])
        {NSLog(@"3");
            if (k==10)  {[self.Rsscache3 removeObjectAtIndex:0];k=k-1;}
            self.Rsscache3[k]=[NSNumber numberWithFloat:valuenum];
            
            if(k==9)
            {
                for (int a=0;a<=9;a++)
                {sum3 =sum3+[self.Rsscache3[a] floatValue];}
                sum3=sum3/10;//求均值
                self.rssArray[2]=[NSNumber numberWithFloat:sum3];
                sum3=0;
            }
            if (k<10) k=k+1;
            xx =23;
            yy =40;
        }
        
        if ([key isEqualToString:@"E57FB07C0991"])
        {
            
            if (l==10)  {[self.Rsscache4 removeObjectAtIndex:0];l=l-1;}
            self.Rsscache4[l]=[NSNumber numberWithFloat:valuenum];
            if(l==9)
            {
                for (int a=0;a<=9;a++)
                {sum4 =sum4+[self.Rsscache4[a] floatValue];}
                sum4=sum4/10;//求均值
                self.rssArray[3]=[NSNumber numberWithFloat:sum4];
                sum4=0;
            }
            if (l<10) l=l+1;
            xx =103;
            yy =243;
        }
        
        
        if ([key isEqualToString:@"E23E35A0F0A1"])
        {NSLog(@"here");
            if (m==10)  {[self.Rsscache5 removeObjectAtIndex:0];m=m-1;}
            self.Rsscache5[m]=[NSNumber numberWithFloat:valuenum];
            if(m==9)
            {
                for (int a=0;a<=9;a++)
                {sum5 =sum5+[self.Rsscache5[a] floatValue];}
                sum5=sum5/10;//求均值
                self.rssArray[4]=[NSNumber numberWithFloat:sum5];
                sum5=0;
            }
            if (m<10) m=m+1;
            xx =103;
            yy =100;
        }
        
        if ([key isEqualToString:@"uuid6"])
        {
            if (n==10)  {[self.Rsscache6 removeObjectAtIndex:0];n=n-1;}
            self.Rsscache5[n]=[NSNumber numberWithFloat:valuenum];
            if(n==9)
            {
                for (int a=0;a<=9;a++)
                {sum6 =sum6+[self.Rsscache6[a] floatValue];}
                sum6=sum6/10;//求均值
                self.rssArray[5]=[NSNumber numberWithFloat:sum6];
                sum6=0;
            }
            if (n<10) n=n+1;
            xx =23;
            yy =243;
        }
        
        
    
    if ([self.rssArray count]==5)//6这里写ap的数量,表示只有收到所有ap的uuid后开始后续计算
[sample rssInput:self.rssArray];
    
    */
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


