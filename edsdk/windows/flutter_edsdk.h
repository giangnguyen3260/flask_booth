#ifndef FLUTTER_EDSDK_H
#define FLUTTER_EDSDK_H

#include <memory>
#include <EDSDK.h>
#include <iostream>
#include "models/camera_model.cpp"
#include <vector>

using namespace std;


class FlutterEdsdk {
public:
    FlutterEdsdk();

    ~FlutterEdsdk();

    // Initialize EDSDK
    bool initializeEdsdk();

    // Terminate EDSDK
    bool terminateEdsdk();

    bool startLivePreview();

    bool addEvent(EdsObjectEventHandler eventHandler);

    bool openSession();

    bool closeSession();

    std::vector<CameraModel> getCameraList();

    bool getChildAtIndex(EdsInt32 index);

    bool stopLivePreview();

    bool startRecord();

    bool stopRecord();

    bool shoot();

    bool clearMem();

    int getCameraCount();

    bool saveToHost();

    bool enableAspectRatio();

    bool setAspectRatio(EdsUInt32 aspectRatio);



    // Add private members for EDSDK session, camera, etc.
private:
    EdsCameraRef camera = nullptr;
    EdsCameraListRef cameraList = nullptr;
};

#endif // FLUTTER_EDSDK_H
