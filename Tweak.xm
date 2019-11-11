// Import the framework which has the AVAudioPlayer class
#import <AVFoundation/AVFoundation.h> 

@interface UIKeyboardLayoutStar : UIView
// Create new property for AVAudioPlayer and retain it. 
@property (nonatomic, retain) AVAudioPlayer* bruhPlayer;
@end

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

		// Make a string with the file path of the mp3 bruh sound file and create a NSURL of it
		NSString* bruhFilePath = @"/Library/Application Support/BruhKeysTM/bruhSound.mp3";
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