//
//  NewFile.m
//  mts-iphone
//
//  Created by 李曜 on 15/5/12.
//  Copyright (c) 2015年 中国电信. All rights reserved.
//

#import "NewFile.h"
#import "TSFileCache.h"

@implementation NewFile


-(id) initWith:(NSDictionary*) dic{
    self.key=[dic valueForKey:@"file_key"];
    self.url=[dic valueForKey:@"file_url"];
    self.name=[dic valueForKey:@"file_name"];
    return self;
}

-(NSData*) getFileData{
    if(_data){
        return _data;
    }else{
      TSFileCache*cache=  [TSFileCache sharedInstance];
        if(![DataUtil isEmptyString:self.url]){
            NSString* key_cache=[TSFileCache keyForUrl:self.url andSuffix:[TSFileCache suffixForUrl:self.url]];
            if([cache existsDataForKey:key_cache]){
                _data=[cache dataForKey:key_cache];
                return _data;
            }
        }else if(![DataUtil isEmptyString:self.name]){
           NSString* key_cache=[TSFileCache keyForUrl:self.name andSuffix:[TSFileCache suffixForUrl:self.name]];
            if([cache existsDataForKey:key_cache]){
                _data=[cache dataForKey:key_cache];
                return _data;
            }
        }
        return nil;
    }



}

-(void) removeCache{
        TSFileCache*cache=  [TSFileCache sharedInstance];
        if(![DataUtil isEmptyString:self.url]){
            NSString* key_cache=[TSFileCache keyForUrl:self.url andSuffix:[TSFileCache suffixForUrl:self.url]];
            if([cache existsDataForKey:key_cache]){
                [cache removeDataForKey:key_cache];
            }
        }else if(![DataUtil isEmptyString:self.name]){
            NSString* key_cache=[TSFileCache keyForUrl:self.name andSuffix:[TSFileCache suffixForUrl:self.name]];
            if([cache existsDataForKey:key_cache]){
                _data=[cache dataForKey:key_cache];
                [cache removeDataForKey:key_cache];
            }
        }
    
}

    

///计算缓存文件的大小的M

+ (long long) fileSizeAtPath:(NSString*) filePath{
    
    NSFileManager* manager = [NSFileManager defaultManager];
    
    if ([manager fileExistsAtPath:filePath]){
        
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
        
    }
    
    
    
    return 0;
    
}

+ (float ) folderSizeAtPath:(NSString*) folderPath{
    
    NSFileManager* manager = [NSFileManager defaultManager];
    
    if (![manager fileExistsAtPath:folderPath]) return 0;
    
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];//从前向后枚举器／／／／//
    
    NSString* fileName;
    
    long long folderSize = 0;
    
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        
        NSLog(@"fileName ==== %@",fileName);
        
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        
        NSLog(@"fileAbsolutePath ==== %@",fileAbsolutePath);
        
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
        
    }
    
    NSLog(@"folderSize ==== %lld",folderSize);
    
    return folderSize/(1024.0*1024.0);
    
}

-(NSMutableDictionary*) getUploadDictionary{
    NSMutableDictionary* dic=[NSMutableDictionary dictionary];
    [dic setValue:self.key forKey:@"file_key"];
    [dic setValue:self.url forKey:@"file_url"];
    [dic setValue:self.name forKey:@"file_name"];
    return dic;


}

-(void)saveDataToCache:(NSData*) data{
    if(data){
        NSString* key_cache=@"";
        TSFileCache*cache=  [TSFileCache sharedInstance];
        if(![DataUtil isEmptyString:self.url]){
            key_cache=[TSFileCache keyForUrl:self.url andSuffix:[TSFileCache suffixForUrl:self.url]];
           }else if(![DataUtil isEmptyString:self.name]){
             key_cache=[TSFileCache keyForUrl:self.name andSuffix:[TSFileCache suffixForUrl:self.name]];
        }
        if(![DataUtil isEmptyString:key_cache])
          [cache storeData:data forKey:key_cache];
     }
}

-(void)moveDataFromNameToUrl{
    
    
    TSFileCache*cache=  [TSFileCache sharedInstance];
    if([DataUtil isEmptyString:self.url]){
    
        return;
    }
    
    
    if([cache existsDataForKey:self.url]){
    
        return;
    }
    NSString *key_cache_orgin=[TSFileCache keyForUrl:self.name andSuffix:[TSFileCache suffixForUrl:self.name]];
    
    
    if(![DataUtil isEmptyString:self.name]&&[cache existsDataForKey:key_cache_orgin]){
        NSData* data=[cache dataForKey:key_cache_orgin];
        NSString* key_cache=[TSFileCache keyForUrl:self.url andSuffix:[TSFileCache suffixForUrl:self.url]];
        [cache storeData:data forKey:key_cache];
        [cache removeDataForKey:self.name];
    }
}
-(NSString*)getFilePathOfCache{
    
    
    TSFileCache*cache=  [TSFileCache sharedInstance];
    NSString* key_cache=@"";
    if(![DataUtil isEmptyString:self.url]){
         key_cache=[TSFileCache keyForUrl:self.url andSuffix:[TSFileCache suffixForUrl:self.url]];
    }else if(![DataUtil isEmptyString:self.name]){
         key_cache=[TSFileCache keyForUrl:self.name andSuffix:[TSFileCache suffixForUrl:self.name]];
        
    }
    
    return [cache filePathOfKey:key_cache];
}

@end
