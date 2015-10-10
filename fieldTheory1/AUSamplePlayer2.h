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

#pragma mark - state struct
typedef struct MyMIDIPlayer {
    AUGraph		graph;
    AudioUnit	instrumentUnit;
    AudioUnit reverbUnit;
    AudioUnit delayUnit;
} MyMIDIPlayer;


@interface AUSamplePlayer2 : NSObject
{
    MIDIEndpointRef destinationEndpoint;
    MIDIPortRef outPort;
    AUNode outputNode;
    AUNode instrumentNode;
    AudioUnit ioUnit;
    Float64   graphSampleRate;
    MIDIPortRef    dOutPort;
    MIDIEndpointRef  dDest;
 
}
@property 	MyMIDIPlayer player;
@property (strong, nonatomic) NSString * preset;



-(void)sendDelayWetDry:(AudioUnitParameterValue)value;
-(void)sendReverbWetDry:(AudioUnitParameterValue)value;
-(void)setupAUGraph:(MyMIDIPlayer *)player;
- (OSStatus) loadSynthFromPresetURL:(NSString *)presetURL sampler:(MyMIDIPlayer *)player;
-(void) sendNoteCCEvent:(UInt32)channel data:(UInt32)value;
-(void) sendNoteOffEvent:(UInt32)key velocity:(UInt32)velocity;
-(void) sendNoteOnEvent:(UInt32)key velocity:(UInt32)velocity;
- (id)initWithPresetPath:(NSString *)path;

@end
