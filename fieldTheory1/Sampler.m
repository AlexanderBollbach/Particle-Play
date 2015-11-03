//
//  AUSamplePlayer.m
//  Sampler
//
//  Created by Dustin O'Connor on 9/21/15.
//  Copyright © 2015 Dustin O'Connor. All rights reserved.
//

#import "Sampler.h"



@interface Sampler() @end

@implementation Sampler

- (id)initWithPresetPath:(NSString *)path {
     self = [super init];
     if (self) {
          
          _preset = path;
          [self setupAUGraph:&_player];
          [self loadSynthFromPresetURL:_preset sampler:&_player];
          CheckError (AUGraphStart(_player.graph),"couldn't start graph");
          
   
          AudioUnitSetParameter(_player.reverbUnit,
                                kAudioUnitScope_Global,
                                0,
                                kDelayParam_WetDryMix,
                                0,
                                0);
          AudioUnitSetParameter(_player.lpUnit,
                                kAudioUnitScope_Global,
                                0,
                                kLowPassParam_CutoffFrequency,
                                20000,
                                0);
//          AudioUnitSetParameter(_player.hpUnit,
//                                kAudioUnitScope_Global,
//                                0,
//                                kHipassParam_CutoffFrequency,
//                              20000,
//                                0);
          AudioUnitSetParameter(_player.dlUnit,
                                kAudioUnitScope_Global,
                                0,
                                kDelayParam_WetDryMix,
                                0,
                                0);
          AudioUnitSetParameter(_player.dlUnit,
                                kAudioUnitScope_Global,
                                0,
                                kDelayParam_Feedback,
                                70,
                                0);
          AudioUnitSetParameter(_player.dlUnit,
                                kAudioUnitScope_Global,
                                0,
                                kDelayParam_DelayTime,
                                0.5,
                                0);
     }
     return self;
}



- (void)setHighPassCutoff:(AudioUnitParameterValue)value {
     AudioUnitParameterValue valueInterpolated = interpolate(0, 1, 0, 20000, value, 1);
     //   NSLog(@"%f", valueInterpolated);
     AudioUnitSetParameter(_player.hpUnit,
                           kAudioUnitScope_Global,
                           0,
                           kHipassParam_CutoffFrequency,
                           valueInterpolated,
                           0);
}

- (void)setReverbCutoff:(AudioUnitParameterValue)value {
     AudioUnitParameterValue valueInterpolated = interpolate(0, 1, 0, 100, value, 1);
     //   NSLog(@"%f", valueInterpolated);
     AudioUnitSetParameter(_player.reverbUnit,
                           kAudioUnitScope_Global,
                           0,
                           kReverb2Param_DryWetMix,
                           valueInterpolated,
                           0);
}

- (void)setLowPassCutoff:(AudioUnitParameterValue)value {
     AudioUnitParameterValue valueInterpolated = interpolate(0, 1, 20000, 40, value, 1);
     //   NSLog(@"%f", valueInterpolated);
     AudioUnitSetParameter(_player.lpUnit,
                           kAudioUnitScope_Global,
                           0,
                           kLowPassParam_CutoffFrequency,
                           valueInterpolated,
                           0);
}

- (void)setDelayAmount:(AudioUnitParameterValue)value {
     AudioUnitParameterValue valueInterpolated = interpolate(0, 1, 0, 1, value, 1);
     //   NSLog(@"%f", valueInterpolated);
     AudioUnitSetParameter(_player.dlUnit,
                           kAudioUnitScope_Global,
                           0,
                           kDelayParam_WetDryMix,
                           valueInterpolated,
                           0);
}


#pragma mark - augraph
-(void)setupAUGraph:(MyMIDIPlayer *)player {
     
     CheckError(NewAUGraph(&player->graph),"Couldn't open AU Graph");
     
     // generate description that will match our output device (speakers)
     AudioComponentDescription outputcd = { 0 };
     outputcd.componentType = kAudioUnitType_Output;
     outputcd.componentSubType = kAudioUnitSubType_RemoteIO;
     outputcd.componentManufacturer = kAudioUnitManufacturer_Apple;
     AUNode outputNode;
     CheckError(AUGraphAddNode(player->graph,
                               &outputcd,
                               &outputNode), "AUGraphAddNode[kAudioUnitSubType_DefaultOutput] failed");
     AudioComponentDescription instrumentcd = { 0 };
     instrumentcd.componentManufacturer = kAudioUnitManufacturer_Apple;
     instrumentcd.componentType = kAudioUnitType_MusicDevice;
     instrumentcd.componentSubType = kAudioUnitSubType_Sampler;  // changed!
     AUNode instrumentNode;
     CheckError(AUGraphAddNode(player->graph,
                               &instrumentcd,
                               &instrumentNode), "AUGraphAddNode[kAudioUnitSubType_DLSSynth] failed");
     AudioComponentDescription rvcd = { 0 };
     rvcd.componentManufacturer = kAudioUnitManufacturer_Apple;
     rvcd.componentType = kAudioUnitType_Effect;
     rvcd.componentSubType = kAudioUnitSubType_Reverb2;
     AUNode reverbNode;
     CheckError(AUGraphAddNode(player->graph,
                               &rvcd,
                               &reverbNode),"AUGraphAddNode[kAudioUnitSubType_Reverb2] failed");
     AudioComponentDescription hpcd = { 0 };
     hpcd.componentManufacturer = kAudioUnitManufacturer_Apple;
     hpcd.componentType = kAudioUnitType_Effect;
     hpcd.componentSubType = kAudioUnitSubType_Delay;
     AUNode hpNode;
     CheckError(AUGraphAddNode(player->graph,
                               &hpcd,
                               &hpNode),"AUGraphAddNode[kAudioUnitSubType_HighPass] failed");
     AudioComponentDescription lpcd = { 0 };
     lpcd.componentManufacturer = kAudioUnitManufacturer_Apple;
     lpcd.componentType = kAudioUnitType_Effect;
     lpcd.componentSubType = kAudioUnitSubType_LowPassFilter;  // changed!
     AUNode lpNode;
     CheckError(AUGraphAddNode(player->graph,
                               &lpcd,
                               &lpNode),"AUGraphAddNode[kAudioUnitSubType_LowPass] failed");
     AudioComponentDescription dlcd = { 0 };
     dlcd.componentManufacturer = kAudioUnitManufacturer_Apple;
     dlcd.componentType = kAudioUnitType_Effect;
     dlcd.componentSubType = kAudioUnitSubType_Delay;  // changed!
     AUNode dlNode;
     CheckError(AUGraphAddNode(player->graph,
                               &dlcd,
                               &dlNode),"AUGraphAddNode[kAudioUnitSubType_DIST] failed");
     
     // Open Graph
     CheckError(AUGraphOpen(player->graph),"AUGraphOpen failed");
     
     // get the reference to the AudioUnit object for the instrument graph node
     CheckError(AUGraphNodeInfo(player->graph,
                                instrumentNode,
                                NULL,
                                &player->instrumentUnit),"AUGraphNodeInfo instrument failed");
     CheckError(AUGraphNodeInfo(player->graph,
                                reverbNode,
                                NULL,
                                &player->reverbUnit), "AUGraphNodeInfo reverb failed");
     CheckError(AUGraphNodeInfo(player->graph,
                                hpNode,
                                NULL,
                                &player->hpUnit), "AUGraphNodeInfo hp failed");
     CheckError(AUGraphNodeInfo(player->graph,
                                lpNode,
                                NULL,
                                &player->lpUnit), "AUGraphNodeInfo hp failed");
     CheckError(AUGraphNodeInfo(player->graph,
                                dlNode,
                                NULL,
                                &player->dlUnit), "AUGraphNodeInfo hp failed");
     
     
     
     CheckError(AUGraphConnectNodeInput(player->graph,
                                        instrumentNode,
                                        0,
                                        reverbNode,
                                        0),"AUGraphConnectNodeInput");
     CheckError(AUGraphConnectNodeInput(player->graph,
                                        reverbNode,
                                        0,
                                        hpNode,
                                        0),"AUGraphConnectNodeInput");
     CheckError(AUGraphConnectNodeInput(player->graph,
                                        hpNode,
                                        0,
                                        lpNode,
                                        0),"AUGraphConnectNodeInput");
     CheckError(AUGraphConnectNodeInput(player->graph,
                                        lpNode,
                                        0,
                                        dlNode,
                                        0),"AUGraphConnectNodeInput");
     CheckError(AUGraphConnectNodeInput(player->graph,
                                        dlNode,
                                        0,
                                        outputNode,
                                        0),"AUGraphConnectNodeInput");
     CheckError(AUGraphInitialize(player->graph), "AUGraphInitialize failed");
}




-(void)sendNoteOnEvent:(UInt32)key velocity:(UInt32)velocity {

     MusicDeviceMIDIEvent (_player.instrumentUnit,
                           (int)(0+144),
                           key & 0x7F,
                           velocity & 0x7F,
                           0);
}



#pragma mark utility functions
static void CheckError(OSStatus error, const char *operation)
{
     if (error == noErr) return;
     char str[20];
     // see if it appears to be a 4-char-code
     *(UInt32 *)(str + 1) = CFSwapInt32HostToBig(error);
     if (isprint(str[1]) && isprint(str[2]) && isprint(str[3]) && isprint(str[4])) {
          str[0] = str[5] = '\'';
          str[6] = '\0';
     } else
          // no, format it as an integer
          sprintf(str, "%d", (int)error);
     fprintf(stderr, "Error: %s (%s)\n", operation, str);
     exit(1);
}




#pragma mark preset loader
// Load a synthesizer preset file and apply it to the Sampler unit
- (OSStatus) loadSynthFromPresetURL:(NSString *)presetURL sampler:(MyMIDIPlayer *)player {
     
     NSString *presetPath = presetURL;
     const char* presetPathC = [presetPath cStringUsingEncoding:NSUTF8StringEncoding];
  //   NSLog (@"presetPathC: %s", presetPathC);
     CFURLRef _presetURL = CFURLCreateFromFileSystemRepresentation(kCFAllocatorDefault,
                                                                   presetPathC,
                                                                   [presetPath length],
                                                                   false);
     
     // load preset file into a CFDataRef
     CFDataRef presetData = NULL;
     SInt32 errorCode = noErr;
     Boolean gotPresetData = CFURLCreateDataAndPropertiesFromResource(kCFAllocatorSystemDefault,
                                                                      _presetURL,
                                                                      &presetData,
                                                                      NULL,
                                                                      NULL,
                                                                      &errorCode);
     CheckError(errorCode, "couldn't load .aupreset data");
     CheckError(!gotPresetData, "couldn't load .aupreset data");
     
     
     // convert this into a property list
     CFPropertyListFormat presetPlistFormat = { 0 };
     CFErrorRef presetPlistError = NULL;
     CFPropertyListRef presetPlist = CFPropertyListCreateWithData(kCFAllocatorSystemDefault,
                                                                  presetData,
                                                                  kCFPropertyListImmutable,
                                                                  &presetPlistFormat,
                                                                  &presetPlistError);
     if (presetPlistError) {
          printf ("Couldn't create plist object for .aupreset");
     }
     // set this plist as the kAudioUnitProperty_ClassInfo on _auSampler
     if (presetPlist) {
          CheckError(AudioUnitSetProperty(player->instrumentUnit,
                                          kAudioUnitProperty_ClassInfo,
                                          kAudioUnitScope_Global,
                                          0,
                                          &presetPlist,
                                          sizeof(presetPlist)),
                     "Couldn't set aupreset plist as sampler's class info");
     }
     
     // NSLog (@"AUGraph ready");
     //  CAShow(player->graph);
     return errorCode;
}


@end
