//
//  AUSamplePlayer.m
//  Sampler
//
//  Created by Dustin O'Connor on 9/21/15.
//  Copyright © 2015 Dustin O'Connor. All rights reserved.
//

#import "AUSamplePlayer2.h"



@interface AUSamplePlayer2() @end

@implementation AUSamplePlayer2

//@synthesize player = _player;

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


#pragma mark - augraph
-(void)setupAUGraph:(MyMIDIPlayer *)player {
    CheckError(NewAUGraph(&player->graph),"Couldn't open AU Graph");
    // generate description that will match our output device (speakers)
    AudioComponentDescription outputcd = {0};
    outputcd.componentType = kAudioUnitType_Output;
    outputcd.componentSubType = kAudioUnitSubType_RemoteIO;
    outputcd.componentManufacturer = kAudioUnitManufacturer_Apple;
    
    // adds a node with above description to the graph
    AUNode outputNode;
    CheckError(AUGraphAddNode(player->graph, &outputcd, &outputNode), "AUGraphAddNode[kAudioUnitSubType_DefaultOutput] failed");
    
    //au samper node
    AudioComponentDescription instrumentcd = {0};
    instrumentcd.componentManufacturer = kAudioUnitManufacturer_Apple;
    instrumentcd.componentType = kAudioUnitType_MusicDevice;
    instrumentcd.componentSubType = kAudioUnitSubType_Sampler;  // changed!
     AUNode instrumentNode;
    CheckError(AUGraphAddNode(player->graph, &instrumentcd, &instrumentNode), "AUGraphAddNode[kAudioUnitSubType_DLSSynth] failed");
    
    //au reverb node
    AudioComponentDescription reverbcd = {0};
    reverbcd.componentManufacturer = kAudioUnitManufacturer_Apple;
    reverbcd.componentType = kAudioUnitType_Effect;
    reverbcd.componentSubType = kAudioUnitSubType_Reverb2;  // changed!
    
    AUNode reverbNode;
    CheckError(AUGraphAddNode(player->graph, &reverbcd, &reverbNode),"AUGraphAddNode[kAudioUnitSubType_Reverb2] failed");
    
    //au delay node
    AudioComponentDescription delaycd = {0};
    delaycd.componentManufacturer = kAudioUnitManufacturer_Apple;
     delaycd.componentType = kAudioUnitType_Effect;
     delaycd.componentSubType = kAudioUnitSubType_Delay;  // changed!
     
     AUNode delayNode;
     CheckError(AUGraphAddNode(player->graph, &delaycd, &delayNode),"AUGraphAddNode[kAudioUnitSubType_Delay] failed");
     // opening the graph opens all contained audio units but does not allocate any resources yet
     CheckError(AUGraphOpen(player->graph),"AUGraphOpen failed");
     // get the reference to the AudioUnit object for the instrument graph node
     CheckError(AUGraphNodeInfo(player->graph, instrumentNode, NULL, &player->instrumentUnit),"AUGraphNodeInfo instrument failed");
     // get the reference to the AudioUnit object for the instrument graph node
     CheckError(AUGraphNodeInfo(player->graph, reverbNode, NULL, &player->reverbUnit), "AUGraphNodeInfo reverb failed");
     // get the reference to the AudioUnit object for the instrument graph node
     CheckError(AUGraphNodeInfo(player->graph, delayNode, NULL, &player->delayUnit), "AUGraphNodeInfo delay failed");
     // connect the output source of the instrument AU to the input source of the reverb node
     CheckError(AUGraphConnectNodeInput(player->graph, instrumentNode, 0, reverbNode, 0),"AUGraphConnectNodeInput");
     // connect the output source of the reverb to the input source of the output node
     CheckError(AUGraphConnectNodeInput(player->graph, reverbNode, 0, delayNode, 0),"AUGraphConnectNodeInput");
     // connect the output source of the reverb to the input source of the output node
     CheckError(AUGraphConnectNodeInput(player->graph, delayNode, 0, outputNode, 0),"AUGraphConnectNodeInput");
    
    // now initialize the graph (causes resources to be allocated)
    CheckError(AUGraphInitialize(player->graph),
               "AUGraphInitialize failed");
}

#pragma mark preset loader
// Load a synthesizer preset file and apply it to the Sampler unit
- (OSStatus) loadSynthFromPresetURL:(NSString *)presetURL sampler:(MyMIDIPlayer *)player {
    NSString *presetPath = presetURL;
    const char* presetPathC = [presetPath cStringUsingEncoding:NSUTF8StringEncoding];
    //NSLog (@"presetPathC: %s", presetPathC);
    CFURLRef _presetURL = CFURLCreateFromFileSystemRepresentation(kCFAllocatorDefault,presetPathC,[presetPath length],false);
    // load preset file into a CFDataRef
    CFDataRef presetData = NULL;
    SInt32 errorCode = noErr;
    Boolean gotPresetData =
    CFURLCreateDataAndPropertiesFromResource(kCFAllocatorSystemDefault,_presetURL,&presetData,NULL,NULL,&errorCode);
    //CheckError(errorCode, "couldn't load .aupreset data");
    //CheckError(!gotPresetData, "couldn't load .aupreset data");
    // convert this into a property list
    CFPropertyListFormat presetPlistFormat = {0};
    CFErrorRef presetPlistError = NULL;
    CFPropertyListRef presetPlist = CFPropertyListCreateWithData(kCFAllocatorSystemDefault,
                                                                 presetData, kCFPropertyListImmutable,
                                                                 &presetPlistFormat, &presetPlistError);
    if (presetPlistError) {
        printf ("Couldn't create plist object for .aupreset");
    }
    // set this plist as the kAudioUnitProperty_ClassInfo on _auSampler
    if (presetPlist) {
        CheckError(AudioUnitSetProperty(player->instrumentUnit,
                                        kAudioUnitProperty_ClassInfo, kAudioUnitScope_Global, 0,
                                        &presetPlist, sizeof(presetPlist)),
                   "Couldn't set aupreset plist as sampler's class info");
    }
    
   // NSLog (@"AUGraph ready");
  //  CAShow(player->graph);
    return errorCode;
}


-(void) sendNoteOnEvent:(UInt32)key velocity:(UInt32)velocity {
   // int midiOutChannel = 0;
    CheckError(MusicDeviceMIDIEvent (_player.instrumentUnit, (int)(144+0),key & 0x7F,velocity & 0x7F,0),"Couldn't send MIDI event");
}

-(void) sendNoteOffEvent:(UInt32)key velocity:(UInt32)velocity {
    CheckError(MusicDeviceMIDIEvent (_player.instrumentUnit,(int)(128+0),key & 0x7F,velocity & 0x7F,0),"Couldn't send MIDI event");
}

-(void) sendNoteCCEvent:(UInt32)channel data:(UInt32)value {
    CheckError(MusicDeviceMIDIEvent (_player.instrumentUnit,(int)(0+176),channel & 0x7F ,value & 0x7F,0),"Couldn't device MIDI event");
}

-(void)sendDelayWetDry:(AudioUnitParameterValue)value {
    AudioUnitSetParameter(_player.delayUnit, kAudioUnitScope_Global, 0, kDelayParam_WetDryMix, value, 0);
}

-(void)sendReverbWetDry:(AudioUnitParameterValue)value {
     AudioUnitSetParameter(_player.reverbUnit, kAudioUnitScope_Global, 0,  kReverb2Param_DryWetMix, value, 0);
}

- (id)initWithPresetPath:(NSString *)path {
    self = [super init];
    if (self) {
        _preset = path;
        [self setupAUGraph:&_player];
        [self loadSynthFromPresetURL:_preset sampler:&_player];
        CheckError (AUGraphStart(_player.graph),"couldn't start graph");
         //NSLog(@"MIDI app running\n");
    }
    return self;
}


@end
