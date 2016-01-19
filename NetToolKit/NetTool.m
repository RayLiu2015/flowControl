//
//  NetTool.m
//  流量监测
//
//  Created by 刘瑞龙 on 15/12/4.
//  Copyright © 2015年 刘瑞龙. All rights reserved.
//

#import "NetTool.h"

#include <net/if.h>
#include <ifaddrs.h>
#include <net/if_dl.h>
#include <arpa/inet.h>

#define ThisUseFlow     @"thisUseFlow"
#define AllUseFlow      @"allUseFlow"
#define MonthChangeUse  @"monthChangeUseFlow"
#define AllFlow         @"allFlow"
#define Month           @"month"


@implementation NetTool


+ (NSArray *)getDataCounters{
    
    BOOL success;
    struct ifaddrs *addrs;
    const struct ifaddrs *cursor;
    const struct if_data *networkStatisc;
    
    long long WiFiSent = 0;
    long long WiFiReceived = 0;
    long long WWANSent = 0;
    long long WWANReceived = 0;
    
    NSString *name=[NSString string];
    
    success = getifaddrs(&addrs) == 0;
    
    if (success){
        cursor = addrs;
        while (cursor != NULL){
            name=[NSString stringWithFormat:@"%s",cursor->ifa_name];
            NSLog(@"ifa_name %s == %@\n", cursor->ifa_name,name);
            // names of interfaces: en0 is WiFi ,pdp_ip0 is WWAN
            if (cursor->ifa_addr->sa_family == AF_LINK){
                if ([name hasPrefix:@"en"]){
                    networkStatisc = (const struct if_data *) cursor->ifa_data;
                    WiFiSent += networkStatisc->ifi_obytes;
                    WiFiReceived += networkStatisc->ifi_ibytes;
                    
                    NSLog(@"WiFiSent %lld == %d",WiFiSent,networkStatisc->ifi_obytes);
                    NSLog(@"WiFiReceived %lld ==%d",WiFiReceived,networkStatisc->ifi_ibytes);
                }else if ([name hasPrefix:@"pdp_ip"]){
                    networkStatisc = (const struct if_data *) cursor->ifa_data;
                    WWANSent += networkStatisc->ifi_obytes;
                    WWANReceived += networkStatisc->ifi_ibytes;
                    
                    NSLog(@"WWANSent %lld ==%d",WWANSent,networkStatisc->ifi_obytes);
                    NSLog(@"WWANReceived %lld ==%d",WWANReceived,networkStatisc->ifi_ibytes);
                }
            }
            cursor = cursor->ifa_next;
        }
        freeifaddrs(addrs);
    }
    return [NSArray arrayWithObjects:[NSNumber numberWithLongLong:WiFiSent], [NSNumber numberWithLongLong:WiFiReceived],[NSNumber numberWithLongLong:WWANSent],[NSNumber numberWithLongLong:WWANReceived], nil];
}

+(NSString *)getDataStringWithB:(long long)dataCount{
    double mData = dataCount/1024.0/1024.0;
    if (mData > 0) {
        return [NSString stringWithFormat:@"%.2lfM", mData];
    }else{
        return @"0M";
    }

}
+(double)getDataWithB:(long long)data{
    double mData = data/1024.0/1024.0;
    if (mData > 0) {
        return [[NSString stringWithFormat:@"%.2lfM", mData] doubleValue];
    }else{
        return 0.0;
    }
}
+(void)updateUseFlow{
    
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.lrl"];
    //获取本次开机使用流量的本地记录
    double theUse = [userDefaults doubleForKey:ThisUseFlow];
    
    NSArray *arr = [NetTool getDataCounters];
    //获取本次开机使用的流量
    double thisUse = [NetTool getDataWithB:[arr[2] longLongValue] + [arr[3] longLongValue]];
    
    //获取所有使用量
    double allUse = [userDefaults doubleForKey:AllUseFlow];
    
    double monthChangeUse = [userDefaults doubleForKey:MonthChangeUse];
    
    if (monthChangeUse > 0) {
        if (thisUse > monthChangeUse) {
            //更新全部使用流量
            double nowAllUse = allUse + thisUse - monthChangeUse;
            [userDefaults setDouble:nowAllUse forKey:AllUseFlow];
        }else if(thisUse < monthChangeUse){
            [userDefaults setDouble:0.0 forKey:MonthChangeUse];
            [userDefaults setDouble:thisUse forKey:ThisUseFlow];
            
            //更新全部使用的流量
            double nowAllUse = allUse + thisUse;
            [userDefaults setDouble:nowAllUse forKey:AllUseFlow];
        }
    }else{
        if (thisUse > theUse) {
            //更新本地存储的本次开机流量
            [userDefaults setDouble:thisUse forKey:ThisUseFlow];
            
            //更新全部使用流量
            double nowAllUse = allUse + thisUse - theUse;
            [userDefaults setDouble:nowAllUse forKey:AllUseFlow];
        }else if (thisUse < theUse){  //当统计出本次开机使用的流量小于本地本次流量时, 说明开机重新启动
            
            //将本次开机流量同步到本地
            [userDefaults setDouble:thisUse forKey:ThisUseFlow];
            
            //更新全部使用的流量
            double nowAllUse = allUse + thisUse;
            [userDefaults setDouble:nowAllUse forKey:AllUseFlow];
        }
    }
}

+(void)setHasUsedFlow:(double)useFlow{
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.lrl"];
    [userDefaults setDouble:useFlow forKey:AllUseFlow];
}

+(void)setAllFlow:(double)allFlow{
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.lrl"];
    [userDefaults setDouble:allFlow forKey:AllFlow];
}

+(double)getHasUsedFlow{
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.lrl"];
    return [userDefaults doubleForKey:AllUseFlow];
}

+(double)getAllFlow{
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.lrl"];
    return [userDefaults doubleForKey:AllFlow];
}
+(NSInteger)getMonth{
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.lrl"];
    return [userDefaults integerForKey:Month];
}

#pragma mark - 获取到下个月1号的时间
+(double)getLeftTime{
    NSDate *now = [NSDate date];
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *comps = [cal components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:now];
    comps.day = 1;
    
    //当发现月份变化时, 所有已用数据清空
    if (comps.month > [self.class getMonth]) {
        NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.lrl"];
        [userDefaults setInteger:comps.month forKey:Month];
        [userDefaults setDouble:0.0 forKey:AllUseFlow];
        [userDefaults setDouble:0.0 forKey:ThisUseFlow];
        NSArray *arr = [NetTool getDataCounters];
        //获取本次开机使用的流量
        double thisUse = [NetTool getDataWithB:[arr[2] longLongValue] + [arr[3] longLongValue]];
        [userDefaults setDouble:thisUse forKey:MonthChangeUse];
    }
    
    comps.month = comps.month + 1;
    NSLog(@"%ld -- %ld",comps.month, [self.class getMonth]);
    NSDate *firstDay = [cal dateFromComponents:comps];
    
    NSTimeInterval time = [firstDay timeIntervalSinceDate:now];
    return time/60/60/24;
}



#pragma mark - 获得到下个月1号的天数
+(NSString *)getLeftTimeStr{
    return [NSString stringWithFormat:@"%d天", (int)ceilf([self getLeftTime])];
}

+(NSString *)getLeftFlowStr{
    double leftTime = [self getLeftTime];
    int leftDay = leftTime;
    double hour = [[NSString stringWithFormat:@"%.1f", (leftTime - leftDay) * 24] doubleValue];
    NSString *str = [NSString stringWithFormat:@"到下月1号还有:   %d天%.1f小时\n剩   余   流   量:   %.2fM", leftDay, hour, [self getAllFlow] - [self getHasUsedFlow]];
    return str;
}

@end
