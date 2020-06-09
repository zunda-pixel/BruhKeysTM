// Import the framework which has the AVAudioPlayer class
#import <AVFoundation/AVFoundation.h> 
#import "Tweak.h"

HBPreferences *preferences;
bool enabled = false;
char soundFiles[3][50] = {
"bruhSound.mp3", "pa1.mp3", "pafu1.mp3"
};

@interface UIKeyboardLayoutStar : UIView
// Create new property for AVAudioPlayer and retain it. 
@property (nonatomic, retain) AVAudioPlayer* bruhPlayer;
@end

%group BruhKeysTM
// hook the UIKeyboardLayoutStar view
%hook UIKeyboardLayoutStar
// Add the property to the UIKeyboardLayoutStar class because it doesn't exist :DD
%property (nonatomic, retain) AVAudioPlayer* bruhPlayer;

-(instancetype)initWithFrame:(CGRect)frame {
    if ((self = %orig)) {
		// Add a UITapGestureRecognizer to the keyboard layout and do not let it block touches in the view
		UITapGestureRecognizer* gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onKeyboardTouch:)];
        gestureRecognizer.cancelsTouchesInView = NO;
        [self addGestureRecognizer:gestureRecognizer];

		NSString* bruhFilePath = @"/Library/Application Support/BruhKeysTM/";
		int presetNumber = [selectedPreset intValue];
		NSString* NSbruhFilePath = [NSString stringWithCString: soundFiles[presetNumber] encoding:NSUTF8StringEncoding];
		bruhFilePath = [NSString stringWithFormat:@"%@%@",bruhFilePath, NSbruhFilePath];

		NSURL* bruhFileURL = [NSURL fileURLWithPath:bruhFilePath];

		// Init the bruhPlayer, set its volume
		self.bruhPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:bruhFileURL error:nil];
		self.bruhPlayer.volume = 1;
     }
     return self;

}

// %new because the method doesn't exist in the class 
%new
-(void)onKeyboardTouch:(UITapGestureRecognizer *)gestureRecognizer {
	// Rewind the current time of the bruhPlayer back to 0, if the old sound was still playing :D
	self.bruhPlayer.currentTime = 0;
	// In the next 2 methods we prepare the bruhPlayer to play and actually play it, the prepare one is needed for less lag between playing and clicking a key on the keyboard
	[self.bruhPlayer prepareToPlay];
	[self.bruhPlayer play];    
}

// end of the hook
%end
%end


void loadPrefs() {

preferences = [[HBPreferences alloc] initWithIdentifier:@"com.tr1fectaandcameren.bruhkeystmprefs"];

  [preferences registerBool:&enabled default:NO forKey:@"enabled"];
  [preferences registerObject:&selectedPreset default:@"0" forKey:@"selectedSound"];
}


%ctor {
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL,(CFNotificationCallback)loadPrefs, CFSTR("com.tr1fectaandcameren.bruhkeystmprefs/ReloadPrefs"), NULL,
CFNotificationSuspensionBehaviorDeliverImmediately);

	loadPrefs();
	if(enabled) {%init(BruhKeysTM);}
}