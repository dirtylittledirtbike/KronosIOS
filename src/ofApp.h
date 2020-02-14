#pragma once

#include "ofxiOS.h"
#include "ofxGui.h"






class ofApp : public ofxiOSApp{
    
public:
    void setup();
    void update();
    void draw();
    void exit();
    //void audioIn(ofSoundBuffer &input);
    
    
    void touchDown(ofTouchEventArgs & touch);
    void touchMoved(ofTouchEventArgs & touch);
    void touchUp(ofTouchEventArgs & touch);
    void touchDoubleTap(ofTouchEventArgs & touch);
    void touchCancelled(ofTouchEventArgs & touch);
    
    void lostFocus();
    void gotFocus();
    void gotMemoryWarning();
    void deviceOrientationChanged(int newOrientation);
    
    //        ofSoundStream stream;
    //
    //
    //        float smoothedVol;
    //        float unsmoothed;
    //        float distance;
    //        float smoothedVolb;
    
    
    ofxiOSVideoGrabber grabber;
    ofPixels grabberPix;
    ofPixels finalFrame;
    ofTexture finalTex;
    ofPixels grabberBuffer;
    
    
    
    //ADAM GLITCH
    
    
    
    
    std::vector<ofPixels> frames;
    
    int numFrames;
    int frameHeight;
    int frameWidth;
    //int channels;
    int counter;
    bool counterCondition;
    bool counterJump;
    //int smoothSoundValue;
    
    ofxPanel panel;
    ofParameter<int> soundThresh;
    ofParameter<int> pixelThresh;
    ofParameter<int> movementThresh;
    ofParameter<int> fluidThresh;
    
    
    
    
};


