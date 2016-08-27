//
//  AppDelegate.m
//  YiJianBluetooth
//
//  Created by apple on 16/7/26.
//  Copyright © 2016年 LEI. All rights reserved.
//

#import "AppDelegate.h"
#import "MainTabBarController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "NewFeatureViewController.h"
#import "LoginViewController.h"
@interface AppDelegate ()
{
    SystemSoundID soundID;
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    UIUserNotificationType notificationTypes = UIUserNotificationTypeBadge |
    UIUserNotificationTypeSound |
    UIUserNotificationTypeAlert;
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:notificationTypes categories:nil];
    [application registerUserNotificationSettings:settings];
    application.applicationIconBadgeNumber = 0;
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    

//    
//    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"first"]) {
//        
//        
//        NewFeatureViewController *new = [[NewFeatureViewController alloc] init];
//        self.window.rootViewController = new;
//
//    }else{
        MainTabBarController *main = [[MainTabBarController alloc] init];
        //重新制定根控制器
        self.window.rootViewController = main;
        
//    }
    
    [self.window makeKeyAndVisible];
    return YES;
}
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    
    UIApplicationState state = application.applicationState;
    if (state == UIApplicationStateActive) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:notification.alertBody delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        AudioServicesPlaySystemSound(1008);
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:notification.alertBody delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        AudioServicesPlaySystemSound(1008);

        application.applicationIconBadgeNumber = 0;

    }

}

//调用震动
-(void)systemShake
{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

//调用系统铃声
-(void)createSystemSoundWithName:(NSString *)soundName soundType:(NSString *)soundType
{
    NSString *path = [NSString stringWithFormat:@"/System/Library/Audio/UISounds/%@.%@",soundName,soundType];
    if (path) {
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &soundID);
        AudioServicesPlaySystemSound(soundID);
        
    }
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    //当程序还在后天运行
    application.applicationIconBadgeNumber = 0;
   
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
