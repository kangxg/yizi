//
//  YZLocationManager.m
//  YiziTV
//
//  Created by 梁飞 on 16/7/11.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import "YZLocationManager.h"
#import <MapKit/MapKit.h>

@interface YZLocationManager ()<CLLocationManagerDelegate,UIAlertViewDelegate>
{
    
    CLLocationManager  * locationManager;
    
    NSString * locationCity;
    
}

@end

@implementation YZLocationManager
+(instancetype)shareManagerInstance
{
    static id _s;
    if (_s==nil) {
        _s=[[[self class]alloc]init];
    }
    return _s;
}
-(void)startLocation
{
    
        //定位服务是否可用
    BOOL enable=[CLLocationManager locationServicesEnabled];
    if (enable) {
        
    
    
    locationManager=[[CLLocationManager alloc]init];
    locationManager.desiredAccuracy=kCLLocationAccuracyBest;
    locationManager.distanceFilter=100.f;
     
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        {
            //请求权限,ios8以后需手动开启授权
            [locationManager requestWhenInUseAuthorization];
            
        }
    
        //定位权限状态
        int authorizationstatus=[CLLocationManager authorizationStatus];
        //用户未作选择
        if (authorizationstatus==kCLAuthorizationStatusNotDetermined) {
            
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
            {
                //请求权限,ios8以后需手动开启授权
                [locationManager requestWhenInUseAuthorization];
                
            }


            
        }else if (authorizationstatus==kCLAuthorizationStatusDenied)
        {
        
             [self locationManagerError];
        
        }
        

        locationManager.delegate=self;
        [locationManager startUpdatingLocation];
        
        
    }else
    {
        
        [self locationManagerError];
            
       

    
    }

}
#pragma mark locationManagerdelegate
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    
    CLLocation * currrLocation = [locations lastObject];
    //经纬度
//    CLLocationCoordinate2D adjustLoc  = currrLocation.coordinate;
    CLGeocoder * geocoder = [[CLGeocoder alloc]init];
    [geocoder reverseGeocodeLocation:currrLocation completionHandler:^(NSArray * placemarkrs,NSError * error){
        if ([placemarkrs count]>0)
        {
            CLPlacemark * placemark = placemarkrs[0];
            NSDictionary * addressDictionary = placemark.addressDictionary;
            
            
          NSString *   locationAdress = [NSString stringWithFormat:@"%@%@%@",[addressDictionary objectForKey:@"City"],[addressDictionary objectForKey:@"SubLocality"],[addressDictionary objectForKey:@"Street"]];
        locationCity  = [addressDictionary objectForKey:@"City"];
            
        NSLog(@"locationAdress+++++%@/nlocationCity%@",locationAdress,locationCity);
            
            
        }
        
    }];


}
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    
    NSLog(@"定位出错++%@",error.description);

}
-(void)locationManagerError
{
    //无法定位，因为您的设备没有开启定位服务，请到设置中启用

    dispatch_async(dispatch_get_main_queue(), ^{
        
        UIAlertView * aler=[[UIAlertView alloc]initWithTitle:@"无法定位" message:@"因为您的设备没有开启定位服务，请到设置中启用" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
        [aler show];
        
        
        
    });
    


}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{

    if (buttonIndex==1) {
        
    
    UIApplication *app = [UIApplication sharedApplication];
    NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if ([app canOpenURL:settingsURL]) {
        [app openURL:settingsURL];
    }
        
    }

}

-(NSString*)getLocationCityName
{
    return locationCity;
}
@end
