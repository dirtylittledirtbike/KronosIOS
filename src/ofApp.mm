#include "ofApp.h"


//--------------------------------------------------------------
void ofApp::setup(){	
    ofSetOrientation(OFXIOS_ORIENTATION_PORTRAIT);
    cout << ofxiOSGetUIWindow().bounds.size.width << " : " << ofxiOSGetUIWindow().bounds.size.height << endl;
    numFrames = 100;
    grabber.setDeviceID(1);
    grabber.setDesiredFrameRate(30);
    grabber.setup(grabber.getWidth(), grabber.getHeight());

    printf("asked for 320 by 240 - actual size is %i by %i", frameWidth, frameHeight);
    frameHeight = grabber.getHeight();
    frameWidth = grabber.getWidth();
    //grabber.setup(frameWidth, frameHeight);
    
    grabberPix.allocate(frameWidth, frameHeight, OF_PIXELS_RGB);
    grabberBuffer.allocate(frameWidth, frameHeight, OF_PIXELS_RGB);
    frames.assign(numFrames, ofPixels());

    counter = 0;

    for (int i = 0; i < frames.size(); i++){
        frames[i].allocate(frameWidth, frameHeight, OF_PIXELS_RGB);
        frames[i].set(0);
    }
    
    panel.setup();
    panel.setPosition(170,660);
    panel.add(pixelThresh.set("pixel threshold", 255, 0, 255));
   // panel.add(soundThresh.set("color threshold", numFrames, 0, numFrames));
    grabber.listDevices();
    counterCondition = false;
    counterJump = false;
}

//--------------------------------------------------------------
void ofApp::update(){
    if (counterCondition == true){
        if (counter < numFrames - 2){
            counter ++;
        }
    } else {
        if (counter > 0){
            counter --;
        }
    }
    
    if (counterJump == true){
        counter = numFrames-1;
        if (counter > 0){
            counter --;
            soundThresh = 0;
        }
    }
    
    grabber.update();
    if (grabber.isFrameNew()){
        
        grabberPix = grabber.getPixels();
        grabberBuffer = grabberPix;
        
        for(int x = 0; x < frameWidth; x++){
            for(int y = 0; y < frameHeight; y++){
                
                int colorShift = ofMap(counter, 0, numFrames-1, 0, 200, true);
                int index = 3 * (x + y * frameWidth);
                int rValue = grabberBuffer[index + 0];
                int gValue = grabberBuffer[index + 1];
                int bValue = grabberBuffer[index + 2];
                int xMinus = x - colorShift;
                
                if (xMinus < 0){
                    xMinus = frameWidth + xMinus;
                }
                
                int xPlus = x + colorShift;
                if (xPlus > frameWidth-1){  //100
                    xPlus = xPlus - frameWidth;
                }
                
                int yMinus = y - colorShift;
                if (yMinus < 0){
                    yMinus = frameHeight + yMinus;
                }
                
                int yPlus = y + colorShift;
                if (yPlus > frameHeight - 1){
                    yPlus = yPlus - frameHeight;
                };
                
                int left = 3 * ( xMinus + y * frameWidth);
                int up = 3 * ( x + yMinus * frameWidth);
                // int down = 3 * ( x + yPlus * frameWidth);
                int right = 3 * (xPlus + y * frameWidth);
                
                int average = (rValue + gValue + bValue)/3;
                int pixAvgToFrameNumber = ofMap(average, 0, 255, (numFrames - counter) - 1, numFrames - 1, true);
                
                if (counter < soundThresh ){
                    ofColor pulledColor = frames[pixAvgToFrameNumber].getColor(x,y);
                    grabberBuffer.setColor(x, y, pulledColor);
                }
                else
                {
                    int frameIndex = ofMap(average, 0, 255, (numFrames - counter) - 1, numFrames - 1, true);
                    grabberPix[left + 0] = rValue;
                    grabberPix[right + 1] = bValue;
                    grabberPix[up + 2] = gValue;
                    
                    ofColor pulledColor = frames[frameIndex].getColor(x,y);
                    grabberBuffer.setColor(x, y, pulledColor);
                }
                
                if(average > pixelThresh){
                    ofColor pulledColor = frames[0].getColor(x,y);
                    grabberBuffer.setColor(x, y, pulledColor);
                }
                
            }
        }
        
        frames.push_back(grabberPix);
        
        while (frames.size() > numFrames){
            frames.erase(frames.begin());
        }
    }
    
    finalTex.loadData(grabberBuffer);
    counterJump = false;
    if (counter <= 5){
        soundThresh = numFrames;
        
    }
}

//--------------------------------------------------------------
void ofApp::draw(){
    ofBackground(0);
    finalTex.draw(finalTex.getWidth()/2 + ofGetWidth()/2, ofGetHeight()/2 - finalTex.getHeight()/2, -frameWidth, frameHeight);
    panel.draw();
    ofDrawBitmapString(ofToString(counter), 20, 30);
    //grabber.getWidth() = 360
    //grabber.getHeight() = 480
}

//--------------------------------------------------------------
void ofApp::exit(){

}

//--------------------------------------------------------------
void ofApp::touchDown(ofTouchEventArgs & touch){
    counterCondition = true;
}

//--------------------------------------------------------------
void ofApp::touchMoved(ofTouchEventArgs & touch){

}

//--------------------------------------------------------------
void ofApp::touchUp(ofTouchEventArgs & touch){
    counterCondition = false;
}

//--------------------------------------------------------------
void ofApp::touchDoubleTap(ofTouchEventArgs & touch){
    counterJump = true;
}

//--------------------------------------------------------------
void ofApp::touchCancelled(ofTouchEventArgs & touch){
    
}

//--------------------------------------------------------------
void ofApp::lostFocus(){

}

//--------------------------------------------------------------
void ofApp::gotFocus(){

}

//--------------------------------------------------------------
void ofApp::gotMemoryWarning(){

}

//--------------------------------------------------------------
void ofApp::deviceOrientationChanged(int newOrientation){

}

