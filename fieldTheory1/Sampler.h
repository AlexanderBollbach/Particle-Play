//
//  AUSamplePlayer.h
//  Sampler
//
//  Created by Dustin O'Connor on 9/21/15.
//  Copyright © 2015 Dustin O'Connor. All rights reserved.
//

#import <CoreMIDI/CoreMIDI.h>
#import <AudioToolbox/AudioToolbox.h>
#import <CoreFoundation/CoreFoundation.h>
#import "myFunction.h"

#pragma mark - state struct
typedef struct MyMIDIPlayer {
     AUGraph		graph;
     AudioUnit	instrumentUnit;
     AudioUnit reverbUnit;
     AudioUnit hpUnit;
     AudioUnit lpUnit;
     AudioUnit dlUnit;
} MyMIDIPlayer;


@interface Sampler : NSObject {
     
    MIDIEndpointRef destinationEndpoint;
    MIDIPortRef outPort;
    AUNode outputNode;
    AUNode instrumentNode;
    AudioUnit ioUnit;
    Float64   graphSampleRate;
    MIDIPortRef    dOutPort;
    MIDIEndpointRef  dDest;
}

@property MyMIDIPlayer player;
@property (strong, nonatomic) NSString * preset;


//- (OSStatus) loadSynthFromPresetURL:(NSString *)presetURL sampler:(MyMIDIPlayer *)player;
- (id)initWithPresetPath:(NSString *)path;

-(void)setupAUGraph:(MyMIDIPlayer *)player;


-(void) sendNoteCCEvent:(UInt32)channel data:(UInt32)value;
-(void) sendNoteOffEvent:(UInt32)key velocity:(UInt32)velocity;
-(void) sendNoteOnEvent:(UInt32)key velocity:(UInt32)velocity;

// effects
- (void)setLowPassCutoff:(AudioUnitParameterValue)value;
- (void)setHighPassCutoff:(AudioUnitParameterValue)value;
- (void)setReverbCutoff:(AudioUnitParameterValue)value;
- (void)setDelayAmount:(AudioUnitParameterValue)value;

@end
