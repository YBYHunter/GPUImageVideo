//
//  CustomTools.m
//  EMeeting
//
//  Created by AppDev on 12-6-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CustomTools.h"
#include <sys/stat.h>
#include <dirent.h>

@implementation CustomTools

static NSDateFormatter *dateFormatter;

+(void)destroy{
    CT_SAFERELEASE(dateFormatter);
}

//返回设备剩余空间
+ (long long) freeDiskSpaceInBytesByMB{
    struct statfs buf;
    long long freespace = -1;
    if(statfs("/var", &buf) >= 0){
        freespace = (long long)(buf.f_bsize * buf.f_bfree);
    }
    return freespace/1024/1024;
}

//获取版本型号
+ (NSString*)deviceString
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    if ([deviceString isEqualToString:@"iPhone1,1"])    return @"iPhone 1 (GSM)";
    if ([deviceString isEqualToString:@"iPhone1,2"])    return @"iPhone 3G (GSM)";
    if ([deviceString isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS (GSM)";
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4 (GSM)";
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"iPhone 4 (Rev A)";
    if ([deviceString isEqualToString:@"iPhone3,3"])    return @"iPhone 4 (CDMA)";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,1"])    return @"iPhone 5 (GSM+WCDMA)";
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5 (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPhone5,3"])    return @"iPhone 5C (GSM)";
    if ([deviceString isEqualToString:@"iPhone5,4"])    return @"iPhone 5C (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPhone6,1"])    return @"iPhone 5S (GSM)";
    if ([deviceString isEqualToString:@"iPhone6,2"])    return @"iPhone 5S (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPhone7,1"])    return @"iPhone 6";
    if ([deviceString isEqualToString:@"iPhone7,2"])    return @"iPhone 6 plus";
    if ([deviceString isEqualToString:@"iPhone8,1"])    return @"iPhone 6S";
    if ([deviceString isEqualToString:@"iPhone8,2"])    return @"iPhone 6S plus";
    
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"Verizon iPhone 4";
    if ([deviceString isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([deviceString isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([deviceString isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([deviceString isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([deviceString isEqualToString:@"iPod5,1"])      return @"iPod Touch 5G";
    if ([deviceString isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([deviceString isEqualToString:@"iPad1,2"])      return @"iPad 3G";
    if ([deviceString isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([deviceString isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([deviceString isEqualToString:@"iPad2,4"])      return @"iPad 2";
    if ([deviceString isEqualToString:@"iPad2,5"])      return @"iPad Mini (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,6"])      return @"iPad Mini (GSM)";
    if ([deviceString isEqualToString:@"iPad2,7"])      return @"iPad Mini (CDMA)";
    if ([deviceString isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
    if ([deviceString isEqualToString:@"iPad3,2"])      return @"iPad 3 (GSM)";
    if ([deviceString isEqualToString:@"iPad3,3"])      return @"iPad 3 (CDMA)";
    if ([deviceString isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([deviceString isEqualToString:@"iPad3,5"])      return @"iPad 4 (GSM)";
    if ([deviceString isEqualToString:@"iPad3,6"])      return @"iPad 4 (CDMA)";
    if ([deviceString isEqualToString:@"iPad4,1"])      return @"iPad Air (WiFi)";
    if ([deviceString isEqualToString:@"iPad4,2"])      return @"iPad Air (GSM)";
    if ([deviceString isEqualToString:@"iPad4,4"])      return @"iPad Mini 2 (WiFi)";
    if ([deviceString isEqualToString:@"iPad4,5"])      return @"iPad Mini 2 (GSM+LTE)";
    if ([deviceString isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceString isEqualToString:@"x86_64"])       return @"Simulator";
    DebugNSLog(@"NOTE: Unknown device type: %@", deviceString);
    return deviceString;
}

+ (NSString*)deviceWithNumString{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    @try {
        return [deviceString stringByReplacingOccurrencesOfString:@"," withString:@""];
    }
    @catch (NSException *exception) {
        return deviceString;
    }
    @finally {
    }
}

//消息提示框
+(void)msgbox:(NSString*)title msg:(NSString*)msg{
    UIAlertView *altV=[[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [altV show];
    CT_RELEASE(altV);
}

+(void)msgView:(NSString*)msg bgColor:(UIColor*)bgColor textColor:(UIColor*)textColor frame:(CGRect)frame superView:(UIView *)superView{
    UILabel *msgV=[[UILabel alloc] initWithFrame:frame];
    msgV.text=msg;
    msgV.backgroundColor=bgColor;
    msgV.textColor=textColor;
    msgV.layer.masksToBounds=YES;
    msgV.layer.cornerRadius=10;
    [superView addSubview:msgV];
    msgV.alpha=0;
    [UIView animateWithDuration:0.3 animations:^{
        msgV.alpha=1;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            msgV.alpha=0;
        } completion:^(BOOL finished) {
            [msgV removeFromSuperview];
        }];
    }];
}

//json解析
+(id)jsonUnEncoding:(NSData*)data{
    if (data==nil) {
        return nil;
    }
    NSError *error=nil;
    id jsonObj=[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (jsonObj!=nil&&error==nil) {
        return jsonObj;
    }
    else{
        return nil;
    }
}

//json序列化
+(NSString*)jsonEncoding:(id)jsonObj{
    NSError *error=nil;
    NSData  *jsonData=[NSJSONSerialization dataWithJSONObject:jsonObj options:kNilOptions error:&error];
    if (jsonData!=nil&&error==nil) {
        return CT_AUTORELEASE([[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]);
    }
    else{
        return nil;
    }
}

//json序列化
+(NSData*)jsonEncodingData:(id)jsonObj{
    NSError *error=nil;
    NSData  *jsonData=[NSJSONSerialization dataWithJSONObject:jsonObj options:kNilOptions error:&error];
    return jsonData;
}

//字符sha1加密
+(NSString*)SHA1encode:(NSString*)value
{
    const char *cstr = [value cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:value.length];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(data.bytes, data.length, digest);
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    return output;  
}

//文件sha1加密
+(NSString*)FileSHA1encode:(NSString*)path{
    NSFileHandle *handle = [NSFileHandle fileHandleForReadingAtPath:path];
    if( handle== nil ) {
        return nil;
    }
    CC_SHA1_CTX sha1;
    CC_SHA1_Init(&sha1);
    BOOL done = NO;
    while(!done)
    {
        NSData* fileData = [handle readDataOfLength: 256 ];
        CC_SHA1_Update(&sha1, [fileData bytes], [fileData length]);
        if( [fileData length] == 0 ) done = YES;
    }
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1_Final(digest, &sha1);
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    return output;
}

//字符md5加密
+(NSString *)MD5encode:(NSString *)value{
    const char *cstr = [value cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:value.length];
    uint8_t digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(data.bytes, data.length, digest);
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    return output;
}

//文件md5加密
+(NSString*)FileMD5Encode:(NSString*)path{
    
    NSFileHandle *handle = [NSFileHandle fileHandleForReadingAtPath:path];
    if( handle== nil ) {
        return nil;
    }
    CC_MD5_CTX md5;
    CC_MD5_Init(&md5);
    BOOL done = NO;
    while(!done)
    {
        NSData* fileData = [handle readDataOfLength: 256 ];
        CC_MD5_Update(&md5, [fileData bytes], [fileData length]);
        if( [fileData length] == 0 ) done = YES;
    }
    uint8_t digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(digest, &md5);
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    return output;
}

//图片尺寸处理
+(UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}


+ (CGSize)getShearPicturesSize:(UIImage *)image {
    CGSize imgSize;
    if (image.size.width > 828) {
        NSInteger height = image.size.height * 828 / image.size.width;
        imgSize = CGSizeMake(828, height);
    }
    else if (image.size.height > 1472)
    {
        NSInteger width = image.size.width * 1472 / image.size.height;
        imgSize = CGSizeMake(width, 1472);
    }
    else
    {
        imgSize = image.size;
    }
    return imgSize;
}

//图片叠加
+(UIImage *)addImage:(UIImage *)image1 rect1:(CGRect)rect1 toImage:(UIImage *)image2 rect2:(CGRect)rect2

{
    
    UIGraphicsBeginImageContext(image2.size);
    
    
    
    //Draw image2
    
    [image2 drawInRect:rect1];
    
    
    
    //Draw image1
    
    [image1 drawInRect:rect1];
    
    
    
    UIImage *resultImage=UIGraphicsGetImageFromCurrentImageContext();
    
    
    
    UIGraphicsEndImageContext();
    
    
    
    return resultImage;
    
}

//图片竖直方向拼接
+ (UIImage *)addImage:(NSArray *)imageArr{
    float y = 0.0f;
    NSMutableArray *scaleImageArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < imageArr.count; i++) {
        @autoreleasepool {
            UIImage *image = [imageArr objectAtIndex:i];
            float scale = 640.0f/image.size.width;
            UIImage *scaledImage = [CustomTools scaleToSize:image size:CGSizeMake(640.0f, image.size.height*scale)];
            [scaleImageArr addObject:scaledImage];
            y += scaledImage.size.height + 1;
        }
    }
    
    CGSize size = CGSizeMake(640, y);
	
	UIGraphicsBeginImageContext(size);
    
    y = 0;
    for (int i = 0; i < imageArr.count; i++) {
        @autoreleasepool {
            UIImage *image = [scaleImageArr objectAtIndex:i];
            [image drawInRect:CGRectMake(0, y, 640, image.size.height)];
            y += image.size.height + 1;
        }
    }
    [scaleImageArr removeAllObjects];
    CT_RELEASE(scaleImageArr);
    
	UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    
	UIGraphicsEndImageContext();
	return resultingImage;
}

+ (UIImage *)image:(UIImage *)image rotation:(UIImageOrientation)orientation
{
    long double rotate = 0.0;
    CGRect rect;
    float translateX = 0;
    float translateY = 0;
    float scaleX = 1.0;
    float scaleY = 1.0;
    
    switch (orientation) {
        case UIImageOrientationLeft:
            rotate = M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = 0;
            translateY = -rect.size.width;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationRight:
            rotate = 3 * M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = -rect.size.height;
            translateY = 0;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationDown:
            rotate = M_PI;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = -rect.size.width;
            translateY = -rect.size.height;
            break;
        default:
            rotate = 0.0;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = 0;
            translateY = 0;
            break;
    }
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //做CTM变换
    CGContextTranslateCTM(context, 0.0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextRotateCTM(context, rotate);
    CGContextTranslateCTM(context, translateX, translateY);
    
    CGContextScaleCTM(context, scaleX, scaleY);
    //绘制图片
    CGContextDrawImage(context, CGRectMake(0, 0, rect.size.width, rect.size.height), image.CGImage);
    
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    
    return newPic;
}


//相机图片旋转
+(UIImage *)rotateImage:(UIImage *)aImage isRotate:(BOOL)isRotate

{
    
    CGImageRef imgRef = aImage.CGImage;
    
    CGFloat width = CGImageGetWidth(imgRef);
    
    CGFloat height = CGImageGetHeight(imgRef);
    
    
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    CGRect bounds = CGRectMake(0, 0, width, height);
    
    
    
    CGFloat scaleRatio = 1;
    
    
    
    CGFloat boundHeight;
    
    UIImageOrientation orient = aImage.imageOrientation;
    
    if (isRotate == YES) {
        boundHeight = bounds.size.height;
        
        bounds.size.height = bounds.size.width;
        
        bounds.size.width = boundHeight;
        
        transform = CGAffineTransformMakeScale(-1.0, 1.0);
        
        transform = CGAffineTransformRotate(transform, M_PI / 2.0);
    }
    else
    {
        boundHeight = bounds.size.height;
        
        bounds.size.height = bounds.size.width;
        
        bounds.size.width = boundHeight;
        
        transform = CGAffineTransformMakeTranslation(height, 0.0);
        
        transform = CGAffineTransformRotate(transform, M_PI / 2.0);
    }
    
    
    
    UIGraphicsBeginImageContext(bounds.size);
    
    
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    
    
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        
        CGContextTranslateCTM(context, -height, 0);
        
    }
    
    else {
        
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        
        CGContextTranslateCTM(context, 0, -height);
        
    }
    
    
    
    CGContextConcatCTM(context, transform);
    
    
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    
    
    return imageCopy;
    
}


#define PI 3.1415926
//经纬度距离
+(double)LantitudeLongitudeDist:(double)lon1 lat1:(double)lat1 lon2:(double)lon2 lat2:(double)lat2{
    double er = 6378137; // 6378700.0f;
    //ave. radius = 6371.315 (someone said more accurate is 6366.707)
    //equatorial radius = 6378.388
    //nautical mile = 1.15078
    double radlat1 = PI*lat1/180.0f;
    double radlat2 = PI*lat2/180.0f;
    //now long.
    double radlong1 = PI*lon1/180.0f;
    double radlong2 = PI*lon2/180.0f;
    if( radlat1 < 0 ) radlat1 = PI/2 + fabs(radlat1);// south
    if( radlat1 > 0 ) radlat1 = PI/2 - fabs(radlat1);// north
    if( radlong1 < 0 ) radlong1 = PI*2 - fabs(radlong1);//west
    if( radlat2 < 0 ) radlat2 = PI/2 + fabs(radlat2);// south
    if( radlat2 > 0 ) radlat2 = PI/2 - fabs(radlat2);// north
    if( radlong2 < 0 ) radlong2 = PI*2 - fabs(radlong2);// west
    //spherical coordinates x=r*cos(ag)sin(at), y=r*sin(ag)*sin(at), z=r*cos(at)
    //zero ag is up so reverse lat
    double x1 = er * cos(radlong1) * sin(radlat1);
    double y1 = er * sin(radlong1) * sin(radlat1);
    double z1 = er * cos(radlat1);
    double x2 = er * cos(radlong2) * sin(radlat2);
    double y2 = er * sin(radlong2) * sin(radlat2);
    double z2 = er * cos(radlat2);
    double d = sqrt((x1-x2)*(x1-x2)+(y1-y2)*(y1-y2)+(z1-z2)*(z1-z2));
    //side, side, side, law of cosines and arccos
    double theta = acos((er*er+er*er-d*d)/(2*er*er));
    double dist  = theta*er;
    return dist;
}

//隐藏TabBar
+(void)hideTabBar:(UIViewController*)sender{
    if (sender.tabBarController.tabBar.hidden == YES) {
        return;
    }
    UIView *contentView;
    if ( [[sender.tabBarController.view.subviews objectAtIndex:0] isKindOfClass:[UITabBar class]] )
        contentView = [sender.tabBarController.view.subviews objectAtIndex:1];
    else
        contentView = [sender.tabBarController.view.subviews objectAtIndex:0];
    contentView.frame = CGRectMake(contentView.bounds.origin.x,
                                   contentView.bounds.origin.y,
                                   contentView.bounds.size.width,
                                   contentView.bounds.size.height + sender.tabBarController.tabBar.frame.size.height);
    sender.tabBarController.tabBar.hidden = YES;
}

//显示TabBar
+(void)showTabBar:(UIViewController*)sender{
    if (sender.tabBarController.tabBar.hidden == NO)
    {
        return;
    }
    UIView *contentView;
    if ([[sender.tabBarController.view.subviews objectAtIndex:0] isKindOfClass:[UITabBar class]])
        contentView = [sender.tabBarController.view.subviews objectAtIndex:1];
    else
        contentView = [sender.tabBarController.view.subviews objectAtIndex:0];
    contentView.frame = CGRectMake(contentView.bounds.origin.x,
                                   contentView.bounds.origin.y,
                                   contentView.bounds.size.width,
                                   contentView.bounds.size.height - sender.tabBarController.tabBar.frame.size.height);
    sender.tabBarController.tabBar.hidden = NO;
}

//得到数组按指定字符分割
+(NSArray *) GetResultArray:(NSString *)String subBySplitString:(NSString *)splitString{
	if (![String length] || ![splitString length]) {
		return nil;
	}
	else {
		if (![String rangeOfString:splitString].length) {
			return nil;
		}
		return [String componentsSeparatedByString:splitString];
	}
}

//转换字符串为日期
+(NSDate*)StrToDate:(NSString*)dateStr{
    if (dateFormatter==nil) {
        dateFormatter=[[NSDateFormatter alloc] init];
    }
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    return [dateFormatter dateFromString:[NSString stringWithFormat:@"%@ +0000",dateStr]];
}

+ (NSString *)StringTimeToDate:(NSDate *)theDate toFormat:(NSString*)toFormat{
    if (dateFormatter==nil) {
        dateFormatter=[[NSDateFormatter alloc] init];
    }
    
    [dateFormatter setDateFormat:toFormat];
    NSString * timeString = [dateFormatter stringFromDate:theDate];
    return timeString;
}

+ (NSString *)StringTimeToDate:(NSString *)theDate fromFormat:(NSString*)fromFormat toFormat:(NSString*)toFormat{
    if (dateFormatter==nil) {
        dateFormatter=[[NSDateFormatter alloc] init];
    }
    [dateFormatter setDateFormat:fromFormat];
    NSDate *d=[dateFormatter dateFromString:theDate];
    
    [dateFormatter setDateFormat:toFormat];
    NSString * timeString = [dateFormatter stringFromDate:d];

    return timeString;
}

+ (NSDate *)StringTimeToDate:(NSString *)theDate fromFormat:(NSString*)fromFormat{
    if (dateFormatter==nil) {
        dateFormatter=[[NSDateFormatter alloc] init];
    }
    [dateFormatter setDateFormat:fromFormat];
    return [dateFormatter dateFromString:theDate];
}
//Unix日期格式化

+ (NSString *)UnixTimeToDate:(NSString *)theDate{
    if (dateFormatter==nil) {
        dateFormatter=[[NSDateFormatter alloc] init];
    }
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss Z"];
    NSDate * d = [NSDate dateWithTimeIntervalSince1970:[theDate floatValue]];
    NSString * timeString = [dateFormatter stringFromDate:d];
    return timeString;
}

//日期差值计算
+ (NSString *)intervalSinceNow:(NSString *)theDate date:(NSDate *)data
{
    if (dateFormatter==nil) {
        dateFormatter=[[NSDateFormatter alloc] init];
    }
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:sszzz"];
    NSDate *d=[dateFormatter dateFromString:theDate];
    if (data != nil) {
        d = data;
    }
    NSTimeInterval late=[d timeIntervalSince1970]*1;
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now=[dat timeIntervalSince1970]*1;
    NSString *timeString=@"";
    
    NSTimeInterval cha=now-late;
    if (cha/60 < 0)
    {
        timeString = [NSString stringWithFormat:@"1秒前"];
    }
    if (cha/60 > 0&&cha/60 < 1)
    {
        timeString = [NSString stringWithFormat:@"%f",fabs(cha / 60)];
        timeString = [timeString substringToIndex:timeString.length - 7];
        float theTime = [timeString floatValue] * 10 + 1;
        timeString = [NSString stringWithFormat:@"%.f秒前",theTime];
    }
    
    if(cha / 3600 < 1 && cha / 60 > 1){
        timeString = [NSString stringWithFormat:@"%f", cha/60];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"%@分钟前", timeString];
    }
    if(cha / 3600 > 1 && cha / 86400 < 1){
        timeString = [NSString stringWithFormat:@"%f", cha/3600];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"%@小时前", timeString];
    }
    if(cha / 86400 >1 && cha/ (86400 * 31) < 1){
        timeString = [NSString stringWithFormat:@"%f", cha/86400];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"%@天前", timeString];
    }
    if(cha / (86400 * 31) >1 && cha / (86400 * 31 * 12) < 1){
        timeString = [NSString stringWithFormat:@"%f", cha/(86400 * 31)];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"%@月前", timeString];
    }
    
    if(cha / (86400 * 31 * 12) >1){
        timeString = [NSString stringWithFormat:@"%f", cha/(86400 * 31 * 12)];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"%@年前", timeString];
    }
    return timeString;
}

+ (NSString *)intervalSinceNowWithUnix:(NSString *)theDate
{
    NSTimeInterval late=[theDate floatValue];
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now=[dat timeIntervalSince1970]*1;
    NSString *timeString=@"";
    
    NSTimeInterval cha=now-late;
    if (cha/60 < 0)
    {
        timeString = [NSString stringWithFormat:@"1秒前"];
    }
    if (cha/60 > 0&&cha/60 < 1)
    {
        timeString = [NSString stringWithFormat:@"%f",fabs(cha / 60)];
        timeString = [timeString substringToIndex:timeString.length - 7];
        float theTime = [timeString floatValue] * 10 + 1;
        timeString = [NSString stringWithFormat:@"%.f秒前",theTime];
    }
    
    if(cha / 3600 < 1 && cha / 60 > 1){
        timeString = [NSString stringWithFormat:@"%f", cha/60];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"%@分钟前", timeString];
    }
    if(cha / 3600 > 1 && cha / 86400 < 1){
        timeString = [NSString stringWithFormat:@"%f", cha/3600];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"%@小时前", timeString];
    }
    if(cha / 86400 >1 && cha/ (86400 * 31) < 1){
        timeString = [NSString stringWithFormat:@"%f", cha/86400];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"%@天前", timeString];
    }
    if(cha / (86400 * 31) >1 && cha / (86400 * 31 * 12) < 1){
        timeString = [NSString stringWithFormat:@"%f", cha/(86400 * 31)];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"%@月前", timeString];
    }
    
    if(cha / (86400 * 31 * 12) >1){
        timeString = [NSString stringWithFormat:@"%f", cha/(86400 * 31 * 12)];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"%@年前", timeString];
    }
    return timeString;
}

//图文混排
#define BEGIN_FLAG @"["
#define END_FLAG @"]"
+(void)getImageRange:(NSString*)message : (NSMutableArray*)array {
    NSRange range=[message rangeOfString: BEGIN_FLAG];
    NSRange range1=[message rangeOfString: END_FLAG];
    //判断当前字符串是否还有表情的标志。
    if (range.length>0 && range1.length>0) {
        if (range.location > 0) {
            [array addObject:[message substringToIndex:range.location]];
            [array addObject:[message substringWithRange:NSMakeRange(range.location, range1.location+1-range.location)]];
            NSString *str=[message substringFromIndex:range1.location+1];
            [self getImageRange:str :array];
        }else {
            NSString *nextstr=[message substringWithRange:NSMakeRange(range.location, range1.location+1-range.location)];
            //排除文字是“”的
            if (![nextstr isEqualToString:@""]) {
                [array addObject:nextstr];
                NSString *str=[message substringFromIndex:range1.location+1];
                [self getImageRange:str :array];
            }else {
                return;
            }
        }
        
    } else if (message != nil) {
        [array addObject:message];
    }
}

+(UIView *)assembleMessageAtIndex : (NSString *) message vx:(double)vx vy:(double)vy maxWidth:(double)maxWidth font:(UIFont*)font andTextColor:(UIColor *)textColor
{
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [self getImageRange:message :array];
    UIView *returnView = [[UIView alloc] initWithFrame:CGRectZero];
    NSArray *data = array;
    UIFont *fon = font;
    CGSize size = CGSizeMake(maxWidth,2000);
    CGSize labelsize = [@"您好！" sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    
    CGFloat upX = 0;
    CGFloat upY = 0;
    CGFloat X = 0;
    CGFloat Y = 0;
    if (data) {
        for (int i=0;i < [data count];i++) {
            NSString *str=[data objectAtIndex:i];
            if ([str hasPrefix: BEGIN_FLAG] && [str hasSuffix: END_FLAG])
            {
                if (upX >= maxWidth)
                {
                    upY = upY + labelsize.height;
                    upX = 0;
                    X = 150;
                    Y = upY;
                }
                NSString *imageName=[str substringWithRange:NSMakeRange(1, str.length - 2)];
                UIImageView *img=[[UIImageView alloc]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"f%@",imageName]]];
                img.frame = CGRectMake(upX, upY, labelsize.height, labelsize.height);
                [returnView addSubview:img];
                CT_RELEASE(img);
                upX=labelsize.height+upX;
                if (X<150) X = upX;
                
                
            } else {
                for (int j = 0; j < [str length]; j++) {
                    NSString *temp = [str substringWithRange:NSMakeRange(j, 1)];
                    if (upX >= maxWidth)
                    {
                        upY = upY + labelsize.height;
                        upX = 0;
                        X = 150;
                        Y =upY;
                    }
                    CGSize size=[temp sizeWithFont:fon constrainedToSize:CGSizeMake(150, 40)];
                    UILabel *la = [[UILabel alloc] initWithFrame:CGRectMake(upX,upY,size.width,size.height)];
                    la.font = fon;
                    la.text = temp;
                    la.textColor=textColor;
                    la.backgroundColor = [UIColor clearColor];
                    [returnView addSubview:la];
                    CT_RELEASE(la);
                    upX=upX+size.width;
                    if (X<150) {
                        X = upX;
                    }
                }
            }
        }
    }
    returnView.frame = CGRectMake(vx,vy, X, Y+labelsize.height); //@ 需要将该view的尺寸记下，方便以后使用
    
    CT_RELEASE(array);
    return returnView;
}
+(UILabel *)assembleFaceMessageAtIndex : (NSString *) message vx:(double)vx vy:(double)vy maxWidth:(double)maxWidth font:(UIFont*)font andTextColor:(UIColor *)textColor
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [self getImageRange:message :array];
    UILabel *returnView = [[UILabel alloc] initWithFrame:CGRectZero];
    NSArray *data = array;

    UIFont *fon = font;
    CGSize size = CGSizeMake(maxWidth,2000);
    CGSize labelsize = [@"您好！" sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByClipping];
    
    CGFloat upX = 0;
    CGFloat upY = 0;
    CGFloat X = 0;
    CGFloat Y = 0;
    if (data) {
        for (int i=0;i < [data count];i++) {
            NSString *str=[data objectAtIndex:i];
            if ([str hasPrefix: BEGIN_FLAG] && [str hasSuffix: END_FLAG])
            {
                if (upX >= maxWidth)
                {
                    upY = upY + labelsize.height;
                    upX = 0;
                    X = 150;
                    Y = upY;
                }
//                NSString *imageName=[str substringWithRange:NSMakeRange(1, str.length - 2)];
                
                UIImageView *img=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"send_flower"]];
                img.frame = CGRectMake(upX, upY, labelsize.height, labelsize.height);
                [returnView addSubview:img];
                CT_RELEASE(img);
                upX=labelsize.height+upX;
                if (X<150) X = upX;
                
                
            } else {
                for (int j = 0; j < [str length]; j++) {
                    NSString *temp = [str substringWithRange:NSMakeRange(j, 1)];
                    if (upX >= maxWidth)
                    {
                        upY = upY + labelsize.height;
                        upX = 0;
                        X = 150;
                        Y =upY;
                    }
                    CGSize size=[temp sizeWithFont:fon constrainedToSize:CGSizeMake(150, 40)];
                    UILabel *la = [[UILabel alloc] initWithFrame:CGRectMake(upX,upY,size.width,size.height)];
                    la.font = fon;
                    la.text = temp;
                    la.textColor=textColor;
                    la.backgroundColor = [UIColor clearColor];
                    [returnView addSubview:la];
                    CT_RELEASE(la);
                    upX=upX+size.width;
                    if (X<150) {
                        X = upX;
                    }
                }
            }
        }
    }
    returnView.frame = CGRectMake(vx,vy, X, Y+labelsize.height); //@ 需要将该view的尺寸记下，方便以后使用
    
    CT_RELEASE(array);
    return returnView;
}

+(NSString*)SecureRandom:(int)length{
    char data[length];
    for (int x=0;x<length;x++){
        switch (arc4random_uniform(3)) {
            case 0:
                data[x] = (char)('A' + (arc4random_uniform(26)));
                break;
            case 1:
                data[x] = (char)('a' + (arc4random_uniform(26)));
                break;
            case 2:
                data[x] = (char)('0' + (arc4random_uniform(10)));
                break;
            default:
                break;
        }
    };
    return CT_AUTORELEASE([[NSString alloc] initWithBytes:data length:length encoding:NSUTF8StringEncoding]);
}

+(NSString *)HMACSha1:(NSString *)text secret:(NSString *)key{
    const char *cKey  = [key cStringUsingEncoding:NSUTF8StringEncoding];
    const char *cData = [text cStringUsingEncoding:NSUTF8StringEncoding];
    
    uint8_t cHMAC[CC_SHA1_DIGEST_LENGTH];
    
    CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    
    //NSData *HMAC = [[NSData alloc] initWithBytes:cHMAC length:CC_SHA1_DIGEST_LENGTH];
    NSString *hash;
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", cHMAC[i]];
    hash = output;
    
    return hash;
}

//your app key = SHA1（你的应用ID + 'UZ' + 你的应用KEY +'UZ' + 当前时间毫秒数）.当前时间毫秒数
+(NSString *)getXAPICloudAppKey
{
    NSString * xappkey = @"";
    
//    NSString * ID = appAPiCloudID;
//    NSString * appKey = appAPiCloudKEY;
//    NSDate * date = [[NSDate alloc]init];
//    NSString * time = [NSString stringWithFormat:@"%ld",(NSInteger)([date timeIntervalSince1970]*1000)];
//    xappkey = [NSString stringWithFormat:@"%@.%@",[self SHA1encode:[NSString stringWithFormat:@"%@UZ%@UZ%@",ID,appKey,time]],time];
    
    return xappkey;
}




+ (NSString *)getfileImgName
{
    NSString * uuid =[[NSUUID UUID] UUIDString];
    NSDate * date = [[NSDate alloc]init];
    NSString * timeDate = [NSString stringWithFormat:@"%ld",(long)[date timeIntervalSince1970]];
    
    
    return [self MD5encode:[NSString stringWithFormat:@"%@%@",uuid,timeDate]];
}


//图片镜像翻转
+ (UIImage *)flipMirrorImage:(UIImage *)img  {
    NSInteger xxx = img.size.width;
    NSInteger yyy = img.size.height;
    
//    if (xxx < yyy) {
//        xxx = img.size.height;
//        yyy = img.size.width;
//    }
    
    CGRect rect = CGRectMake(0, 0, xxx, yyy);//创建矩形框
    UIGraphicsBeginImageContext(rect.size);//根据size大小创建一个基于位图的图形上下文
    CGContextRef currentContext = UIGraphicsGetCurrentContext();//获取当前quartz 2d绘图环境
    CGContextClipToRect(currentContext, rect);//设置当前绘图环境到矩形框
    
    
    CGContextRotateCTM(currentContext, M_PI);
    CGContextTranslateCTM(currentContext, -rect.size.width, -rect.size.height);
    
    CGContextDrawImage(currentContext, rect, img.CGImage);//绘图
    
    //[image drawInRect:rect];
    
    UIImage *cropped = UIGraphicsGetImageFromCurrentImageContext();//获得图片
    UIGraphicsEndImageContext();//从当前堆栈中删除quartz 2d绘图环境
    
    
    UIImageView *contentView = [[UIImageView alloc] initWithFrame:rect];
    contentView.image=cropped;
    
    contentView.transform = CGAffineTransformIdentity;
    contentView.transform = CGAffineTransformMakeScale(-1.0, 1.0);


    
    
    return contentView.image;
}



+ (long long) folderSizeAtPath3:(NSString*) folderPath{
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    float size =0;
    NSArray* array = [fileManager contentsOfDirectoryAtPath:folderPath error:nil];
    for(int i = 0; i<[array count]; i++)
    {
        NSString *fullPath = [folderPath stringByAppendingPathComponent:[array objectAtIndex:i]];
        
        BOOL isDir;
        if ( !([fileManager fileExistsAtPath:fullPath isDirectory:&isDir] && isDir) )
        {
            NSDictionary *fileAttributeDic=[fileManager attributesOfItemAtPath:fullPath error:nil];
            size+= fileAttributeDic.fileSize/ 1024.0/1024.0;
        }
        else
        {
            [self folderSizeAtPath3:fullPath];
        }
    }
    return size;
}
//Private
+ (long long) _folderSizeAtPath: (const char*)folderPath{
    long long folderSize = 0;
    DIR* dir = opendir(folderPath);
    if (dir == NULL) return 0;
    struct dirent* child;
    while ((child = readdir(dir))!=NULL) {
        if (child->d_type == DT_DIR && (
                                        (child->d_name[0] == '.' && child->d_name[1] == 0) || // 忽略目录 .
                                        (child->d_name[0] == '.' && child->d_name[1] == '.' && child->d_name[2] == 0) // 忽略目录 ..
                                        )) continue;
        
        int folderPathLength = (int)strlen(folderPath);
        char childPath[1024]; // 子文件的路径地址
        stpcpy(childPath, folderPath);
        if (folderPath[folderPathLength-1] != '/'){
            childPath[folderPathLength] = '/';
            folderPathLength++;
        }
        stpcpy(childPath+folderPathLength, child->d_name);
        childPath[folderPathLength + child->d_namlen] = 0;
        if (child->d_type == DT_DIR){ // directory
            folderSize += [self _folderSizeAtPath:childPath]; // 递归调用子目录
            // 把目录本身所占的空间也加上
            struct stat st;
            if(lstat(childPath, &st) == 0) folderSize += st.st_size;
        }else if (child->d_type == DT_REG || child->d_type == DT_LNK){ // file or link
            struct stat st;
            if(lstat(childPath, &st) == 0) folderSize += st.st_size;
        }
    }
    return folderSize;
}


//UIView转化成UIImage
+ (UIImage*)convertViewToImage:(UIView*)orView{
    
    
    
    UIGraphicsBeginImageContext(orView.bounds.size);
    
    [orView.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
    
}







+ (NSMutableArray *)removeMomentDuplicate:(NSMutableArray *)array
{
    NSMutableArray *categoryArray = [[NSMutableArray alloc] init];
    for (unsigned i = 0; i < [array count]; i++){
        if ([categoryArray containsObject:[array objectAtIndex:i]] == NO){ //如果不存在 重复
            [categoryArray addObject:[array objectAtIndex:i]];
        }
    }
    return categoryArray;
}





/*
 规则（当前时间＋0～999随机数）转md5 ＋ uuid
 */
+ (NSString *)getTimeAndUUID {
    
    NSString * resultStr;
    NSString * arcStr = [NSString stringWithFormat:@"%u",arc4random()%999];
    
    NSDate * nowDate = [NSDate dateWithTimeIntervalSinceNow:0];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
    NSString *destDateString = [[dateFormatter stringFromDate:nowDate] stringByAppendingString:arcStr];
    
    resultStr = [NSString stringWithFormat:@"%@%@",[CustomTools MD5encode:destDateString],[self uuid]];
    
    return resultStr;
}



+ (NSString*) uuid {
    CFUUIDRef puuid = CFUUIDCreate( nil );
    CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
    NSString * result = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
    CFRelease(puuid);
    CFRelease(uuidString);
    return result;
}





+ (void)showFailurePromptedCopywriter
{
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [SVProgressHUD showInfoWithStatus:@"网络不稳定" maskType:SVProgressHUDMaskTypeBlack];
//    });
}



+ (void)showFailurePromptedCopywriter:(NSString *)title
{
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [SVProgressHUD showInfoWithStatus:title maskType:SVProgressHUDMaskTypeBlack];
//    });
}



+ (BOOL)isAllowedNotification
{
    
    //iOS8 check if user allow notification
    
//    if(CURRENT_SYSTEM_VERSION >= 8) {// system is iOS8
//        UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
//        
//        if
//            (UIUserNotificationTypeNone != setting.types) {
//                
//                return
//                YES;
//            }
//    }
//    else
//    {//iOS7
//        UIRemoteNotificationType type = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
//        
//        if(UIRemoteNotificationTypeNone != type)
//            
//            return
//            YES;
//    }
//    
//    return
    NO;
}



+ (NSString *)accessOriginalImageUrl:(NSURL *)url {
    if (url) {
        
        NSString * originalUrlStr;
        NSRange rangeJpg = [[NSString stringWithFormat:@"%@",url] rangeOfString:@".jpg?"];
        if (rangeJpg.length > 0) {
            originalUrlStr = [[NSString stringWithFormat:@"%@",url] substringToIndex:rangeJpg.location + 5];
        }
        
        NSRange rangePng = [[NSString stringWithFormat:@"%@",url] rangeOfString:@".png?"];
        if (rangePng.length > 0) {
            originalUrlStr = [[NSString stringWithFormat:@"%@",url] substringToIndex:rangePng.location + 5];
        }
        
        
        return originalUrlStr;
    }
    else
    {
        return nil;
    }

}


+ (BOOL)validatePhone:(NSString *)phone {
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    BOOL res1 = [regextestmobile evaluateWithObject:phone];
    BOOL res2 = [regextestcm evaluateWithObject:phone];
    BOOL res3 = [regextestcu evaluateWithObject:phone];
    BOOL res4 = [regextestct evaluateWithObject:phone];
    if (res1 || res2 || res3 || res4 )
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

+ (UIImage *)blurryImage:(UIImage *)orimage level:(CGFloat)level {
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [[CIImage alloc] initWithImage:orimage];
    // create gaussian blur filter
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    [filter setValue:[NSNumber numberWithFloat:level] forKey:@"inputRadius"];
    // blur image
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    CGImageRef cgImage = [context createCGImage:result fromRect:[result extent]];
    UIImage *image = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    return image;
}


+ (void)jumpToAppStoreScore {
//    NSString * appIDstr = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&onlyLatestVersion=true&pageNumber=0&sortOrdering=1&id=%@",AppID];
//    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:appIDstr]];
}





+ (UIViewController *)getCurrentUIViewController {
    
//    AppDelegate* delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    if ([delegate.window.rootViewController isKindOfClass:[RDVTabBarController class]]) {
//        RDVTabBarController * skipTabBarController = (RDVTabBarController *)delegate.window.rootViewController;
//        
//        UINavigationController * navigationController = (UINavigationController *)skipTabBarController.selectedViewController;
//        
//        
//        UIViewController * VC = [navigationController.viewControllers objectAtIndex:(navigationController.viewControllers.count - 1)];
//        return VC;
//    }
    
    return nil;
}




+ (CGRect)getStringSize:(NSString *)messageStr fontNum:(CGFloat)fontNum maxWidth:(CGFloat)maxWidth maxheight:(CGFloat)maxheight {
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:fontNum]};
    CGRect rectlabMessage = [messageStr boundingRectWithSize:CGSizeMake(maxWidth, maxheight) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil];
    
    return rectlabMessage;
}




/*!
 * @brief 把格式化的JSON格式的字符串转换成字典
 * @param jsonString JSON格式的字符串
 * @return 返回字典
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

//+ (NSDictionary *)dictionaryWithJsonArray:(NSArray *)array {
//    if (array == nil) {
//        return nil;
//    }
//    
//    NSData *jsonData = [array dataUsingEncoding:NSUTF8StringEncoding];
//    NSError *err;
//    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
//                                                        options:NSJSONReadingMutableContainers
//                                                          error:&err];
//    if(err) {
//        NSLog(@"json解析失败：%@",err);
//        return nil;
//    }
//    return dic;
//}



+ (NSString *)intervalSinceNow:(NSDate *)fromDate
{
    NSString *timeString=@"";
    //获取当前时间
    NSDate *adate = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: adate];
    NSDate *localeDate = [adate  dateByAddingTimeInterval: interval];
    
    double intervalTime = [fromDate timeIntervalSinceReferenceDate] - [localeDate timeIntervalSinceReferenceDate];
    long lTime = labs((long)intervalTime);
    NSInteger iSeconds =  lTime % 60;
    NSInteger iMinutes = (lTime / 60) % 60;
    NSInteger iHours = labs(lTime/3600);
    
    
    NSString * strHours = [NSString stringWithFormat:@"%ld",(long)iHours];
    NSString * strMinutes = [NSString stringWithFormat:@"%ld",(long)iMinutes];
    NSString * strSeconds = [NSString stringWithFormat:@"%ld",(long)iSeconds];
    
    return [NSString stringWithFormat:@"%@:%@:%@",[self oneLenghtStrChangeTwoLenght:strHours],[self oneLenghtStrChangeTwoLenght:strMinutes],[self oneLenghtStrChangeTwoLenght:strSeconds]];
}

+ (NSString *)oneLenghtStrChangeTwoLenght:(NSString *)str {
    NSString * result = @"";
    result = str;
    if (str.length == 1) {
        result = [NSString stringWithFormat:@"0%@",str];
    }
    return result;
}


+ (NSDate *)tDate:(NSDate *)date

{
    
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    
    NSInteger interval = [zone secondsFromGMTForDate: date];
    
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];

    return localeDate;
    
}




//获取域名
+ (NSString *)getAddress:(NSString *)address {
    //提取出域名
    NSMutableString *string = [NSMutableString stringWithString:address];
    NSRange r1 = [string rangeOfString:@"rtmp://"];
    [string deleteCharactersInRange:r1];
    NSRange r2 = [string rangeOfString:@"/"];
    
    return [string substringToIndex:r2.location];
}






+ (UIImage *)fixOrientation:(UIImage *)img {
    
    // No-op if the orientation is already correct
    if (img.imageOrientation == UIImageOrientationUp) return img;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (img.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, img.size.width, img.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, img.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, img.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (img.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, img.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, img.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, img.size.width, img.size.height,
                                             CGImageGetBitsPerComponent(img.CGImage), 0,
                                             CGImageGetColorSpace(img.CGImage),
                                             CGImageGetBitmapInfo(img.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (img.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,img.size.height,img.size.width), img.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,img.size.width,img.size.height), img.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *resultImg = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return resultImg;
}







































@end
