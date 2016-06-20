//
//  CustomTools.h
//  EMeeting
//
//  Created by AppDev on 12-6-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>
#import <sys/utsname.h>
#import <sys/param.h>
#import <sys/mount.h>

#if __has_feature(objc_arc)
#define CT_AUTORELEASE(exp) exp
#define CT_RELEASE(exp) exp
#define CT_SAFERELEASE(exp) if(exp!=nil){exp=nil;}
#define CT_RETAIN(exp) exp
#else
#define CT_AUTORELEASE(exp) [exp autorelease]
#define CT_RELEASE(exp) [exp release]
#define CT_SAFERELEASE(exp) if(exp!=nil){[exp release];exp=nil;}
#define CT_RETAIN(exp) [exp retain]
#endif

#ifdef DEBUG
#define DebugNSLog(id,...) NSLog(id,##__VA_ARGS__)
#else
#define DebugNSLog(id,...)
#endif

@interface CustomTools : NSObject

//返回设备剩余空间
+ (long long) freeDiskSpaceInBytesByMB;

//获取版本型号
+ (NSString*)deviceString;
+ (NSString*)deviceWithNumString;

//消息提示框
+(void)msgbox:(NSString*)title msg:(NSString*)msg;
+(void)msgView:(NSString*)msg bgColor:(UIColor*)bgColor textColor:(UIColor*)textColor frame:(CGRect)frame superView:(UIView *)superView;

//json解析
+(id)jsonUnEncoding:(NSData*)data;

//json序列化
+(NSString*)jsonEncoding:(id)jsonObj;

+(NSData*)jsonEncodingData:(id)jsonObj;

//字符sha1加密
+(NSString*)SHA1encode:(NSString*)value;

//文件sha1加密
+(NSString*)FileSHA1encode:(NSString*)path;

//字符md5加密
+(NSString *)MD5encode:(NSString *)value;

//文件md5加密
+(NSString*)FileMD5Encode:(NSString*)path;


//图片尺寸处理
+(UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size;

//图片旋转
+(UIImage *)rotateImage:(UIImage *)aImage isRotate:(BOOL)isRotate;

//图片叠加
+(UIImage *)addImage:(UIImage *)image1 rect1:(CGRect)rect1 toImage:(UIImage *)image2 rect2:(CGRect)rect2;

+ (UIImage *)addImage:(NSArray *)imageArr;
//经纬度距离
+(double)LantitudeLongitudeDist:(double)lon1 lat1:(double)lat1 lon2:(double)lon2 lat2:(double)lat2;

//隐藏TabBar
+(void)hideTabBar:(UIViewController*)sender;

//显示TabBar
+(void)showTabBar:(UIViewController*)sender;

//得到数组按指定字符分割
+(NSArray *) GetResultArray:(NSString *)String subBySplitString:(NSString *)splitString;

//转换字符串为日期
+(NSDate*)StrToDate:(NSString*)dateStr;

+ (NSString *)StringTimeToDate:(NSDate *)theDate toFormat:(NSString*)toFormat;

//
+ (NSString *)StringTimeToDate:(NSString *)theDate fromFormat:(NSString*)fromFormat toFormat:(NSString*)toFormat;

//日期差值计算
+ (NSString *)intervalSinceNow:(NSString *)theDate date:(NSDate *)data;

+ (NSString *)intervalSinceNowWithUnix:(NSString *)theDate;

+ (NSDate *)StringTimeToDate:(NSString *)theDate fromFormat:(NSString*)fromFormat;

//Unix日期格式化
+ (NSString *)UnixTimeToDate:(NSString *)theDate;

//图文混排
+(UIView *)assembleMessageAtIndex : (NSString *) message vx:(double)vx vy:(double)vy maxWidth:(double)maxWidth font:(UIFont*)font andTextColor:(UIColor *)textColor;
//表情混编
+(UILabel *)assembleFaceMessageAtIndex : (NSString *) message vx:(double)vx vy:(double)vy maxWidth:(double)maxWidth font:(UIFont*)font andTextColor:(UIColor *)textColor;

//获得SecureRandom
+(NSString*)SecureRandom:(int)length;

//图片镜像翻转
+ (UIImage *)flipMirrorImage:(UIImage *)img;

//图片左右返转
+ (UIImage *)image:(UIImage *)image rotation:(UIImageOrientation)orientation;

+(NSString *)HMACSha1:(NSString *)text secret:(NSString *)key;


+(NSString *)getXAPICloudAppKey;

+ (NSString *)getfileImgName;

+ (long long) folderSizeAtPath3:(NSString*) folderPath;

+ (UIImage*)convertViewToImage:(UIView*)orView;


//数组去重
+ (NSMutableArray *)removeMomentDuplicate:(NSMutableArray *)array;



+ (NSString *)getTimeAndUUID;



//网络失败文案
+ (void)showFailurePromptedCopywriter;

+ (void)showFailurePromptedCopywriter:(NSString *)title;


//判断是否开启推送
+ (BOOL)isAllowedNotification;


+ (CGSize)getShearPicturesSize:(UIImage *)image;


//获取原始图片的URL
+ (NSString *)accessOriginalImageUrl:(NSURL *)url;



//判断是否是有效手机号
+ (BOOL)validatePhone:(NSString *)phone;




+ (UIImage *)blurryImage:(UIImage *)orimage level:(CGFloat)level;


//跳转到App Store评分页
+ (void)jumpToAppStoreScore;


+ (UIViewController *)getCurrentUIViewController;



+ (CGRect)getStringSize:(NSString *)messageStr fontNum:(CGFloat)fontNum maxWidth:(CGFloat)maxWidth maxheight:(CGFloat)maxheight;


+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;


+ (NSString *)intervalSinceNow:(NSDate *)fromDate;

//  GMT、UTC转换
+ (NSDate *)tDate:(NSDate *)date;

+ (NSString *)getAddress:(NSString *)address;

+ (UIImage *)fixOrientation:(UIImage *)img;
























@end
