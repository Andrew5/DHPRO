//
//  AudioParam.m
//  PlayAudio
//
//  Created by 杨飞 on 10/25/12.
//  Copyright (c) 2012 self. All rights reserved.
//

#import "AudioParam.h"
#import "AVFoundation/AVFoundation.h"

@implementation AudioParam

@synthesize title;
@synthesize artist;
@synthesize album;
@synthesize duration;
@synthesize year;
@synthesize artwork;


- (id)initWithAudioPath:(NSString *)path
{
    if (self == [super init])
    {
        NSMutableDictionary *paramDic = [self audioParamWithAudioPath:path];
        self.album = [paramDic objectForKey:@"album"];
        self.artist = [paramDic objectForKey:@"artist"];
        self.title = [paramDic objectForKey:@"title"];
        self.year = [paramDic objectForKey:@"year"];
        self.artwork = [paramDic objectForKey:@"artWorkImages"];
        self.duration = [paramDic objectForKey:@"approximate duration in seconds"];
    }
    
    return self;
}

- (NSMutableDictionary *)audioParamWithAudioPath:(NSString *)path
{
    NSURL *fileURL = [NSURL fileURLWithPath:path];
    NSString *fileExtension = [[fileURL path] pathExtension];
    NSMutableDictionary *piDict = nil;
    if ([fileExtension isEqual:@"mp3"]||[fileExtension isEqual:@"m4a"])
    {
        AudioFileID fileID  = nil;
        OSStatus err        = noErr;
        
        err = AudioFileOpenURL( (__bridge CFURLRef) fileURL, kAudioFileReadPermission, 0, &fileID );
        if( err != noErr )
        {
            NSLog( @"AudioFileOpenURL failed" );
        }
        
        UInt32 id3DataSize  = 0;
        err = AudioFileGetPropertyInfo( fileID,   kAudioFilePropertyID3Tag, &id3DataSize, NULL );
        if( err != noErr )
        {
            NSLog( @"AudioFileGetPropertyInfo failed for ID3 tag" );
        }
        
        UInt32 piDataSize   = sizeof(piDict);
        err = AudioFileGetProperty( fileID, kAudioFilePropertyInfoDictionary, &piDataSize, &piDict);
        if( err != noErr )
        {
            NSLog( @"AudioFileGetProperty failed for property info dictionary" );
            return nil;
        }
        NSArray *artWorkImages = [self artworksForFileAtPath:path];
        [piDict setObject:artWorkImages forKey:@"artWorkImages"];

        return piDict;
    }
    
    return nil;
}

- (NSArray *)artworksForFileAtPath:(NSString *)path
{
    NSMutableArray *artworkImages = [NSMutableArray array];
    NSURL *u = [NSURL fileURLWithPath:path];
    AVURLAsset *a = [AVURLAsset URLAssetWithURL:u options:nil];
    
    NSArray *artworks = [AVMetadataItem metadataItemsFromArray:a.commonMetadata  withKey:AVMetadataCommonKeyArtwork keySpace:AVMetadataKeySpaceCommon];
    
    for (AVMetadataItem *i in artworks)
    {
        NSString *keySpace = i.keySpace;
        UIImage *im = nil;
        
        if ([keySpace isEqualToString:AVMetadataKeySpaceID3])
        {
            NSDictionary *d = [i.value copyWithZone:nil];
            im = [UIImage imageWithData:[d objectForKey:@"data"]];
//            [d release];
        }
        else if ([keySpace isEqualToString:AVMetadataKeySpaceiTunes])
        {
            im = [UIImage imageWithData:[i.value copyWithZone:nil]];
        }
        if (im)
        {
            [artworkImages addObject:im];
        }
    }
    
    return artworkImages;
    
}
@end
