#import "SimpleVideoFilterViewController.h"
#import <AssetsLibrary/ALAssetsLibrary.h>
#import "CustomTools.h"
#import "LeafButton.h"

@interface SimpleVideoFilterViewController ()
{
    NSURL * currentMovieURL;
    BOOL currentVideoType;
}
@property (nonatomic, retain) LeafButton * cameraPlayButton;

@end

@implementation SimpleVideoFilterViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPresetHigh cameraPosition:AVCaptureDevicePositionBack];

    videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    videoCamera.horizontallyMirrorFrontFacingCamera = NO;
    videoCamera.horizontallyMirrorRearFacingCamera = NO;
    filter = [[GPUImageSepiaFilter alloc] init];
    [videoCamera addTarget:filter];
    GPUImageView *filterView = (GPUImageView *)self.view;
    [filter addTarget:filterView];
    [videoCamera startCameraCapture];
    
    [self.view addSubview:self.cameraPlayButton];
    currentVideoType = NO;
}



- (void)videoAtPathToSavedPhotos:(UIButton *)sender {
    if (currentVideoType == NO) {
         NSLog(@"Movie start");
        currentVideoType = YES;
        NSString *pathToMovie = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/Movie_%@.m4v",[CustomTools getTimeAndUUID]]];
        unlink([pathToMovie UTF8String]); // If a file already exists, AVAssetWriter won't let you record new frames, so delete the old movie
        NSURL * movieURL = [NSURL fileURLWithPath:pathToMovie];
        currentMovieURL = movieURL;
        
        movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:movieURL size:CGSizeMake(480.0, 640.0)];
        movieWriter.encodingLiveVideo = YES;
        [filter addTarget:movieWriter];
        
        
        double delayToStartRecording = 0.1;
        dispatch_time_t startTime = dispatch_time(DISPATCH_TIME_NOW, delayToStartRecording * NSEC_PER_SEC);
        dispatch_after(startTime, dispatch_get_main_queue(), ^(void){
            
            videoCamera.audioEncodingTarget = movieWriter;
            [movieWriter startRecording];
            
        });
    }
    else {
        currentVideoType = NO;
        [self stopVideoCamera:currentMovieURL];
    }


}

- (void)stopVideoCamera:(NSURL *)movieURL {
    
    [filter removeTarget:movieWriter];
    videoCamera.audioEncodingTarget = nil;
    [movieWriter finishRecording];
    NSLog(@"Movie completed -- 文件大小%lld",[self fileSizeAtPath:[movieURL path]]);
}

- (long long) fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}


- (LeafButton *)cameraPlayButton
{
    if (_cameraPlayButton == nil) {
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        _cameraPlayButton = [[LeafButton alloc] initWithFrame:CGRectMake((screenSize.width - 80)/2, screenSize.height - 80 - 80, 80, 80)];
        [_cameraPlayButton setType:LeafButtonTypeVideo];
        [_cameraPlayButton setClickedBlock:^(LeafButton *button) {
            [self videoAtPathToSavedPhotos:nil];
        }];
    }
    return _cameraPlayButton;
}



- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (IBAction)updateSliderValue:(id)sender
{
    [(GPUImageSepiaFilter *)filter setIntensity:[(UISlider *)sender value]];
}

@end
