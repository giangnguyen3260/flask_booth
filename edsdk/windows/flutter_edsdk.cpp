#include "flutter_edsdk.h"

#include <cstdio>


FlutterEdsdk::FlutterEdsdk() {
    // Constructor logic
//    initializeEdsdk();
}

FlutterEdsdk::~FlutterEdsdk() {
    // Destructor logic
//    terminateEdsdk();
}

bool FlutterEdsdk::initializeEdsdk() {
    EdsError err = EdsInitializeSDK();
    if (err != EDS_ERR_OK) {
        std::cerr << "Failed to initialize EDSDK. Error code: " << err << std::endl;
        return false;
    }
    return true;
}

bool FlutterEdsdk::terminateEdsdk() {
    EdsError err = EdsTerminateSDK();
    if (err != EDS_ERR_OK) {
        std::cerr << "Failed to terminate EDSDK. Error code: " << err << std::endl;
        return false;
    }
    return true;
}

std::vector <CameraModel> FlutterEdsdk::getCameraList() {
    EdsRelease(cameraList);
    std::vector <CameraModel> models;
    EdsError err = EdsGetCameraList(&cameraList);
    EdsUInt32 cameraCount;
    if (err != EDS_ERR_OK) {
        cout << "Failed to get camera list" << endl;
        return models;
    }
    err = EdsGetChildCount(cameraList, &cameraCount);

    if (err != EDS_ERR_OK || cameraCount == 0) {
        EdsRelease(cameraList);
        cout << "No cameras found" << endl;
        return models;
    }

    // Iterate over the camera list
    for (EdsUInt32 i = 0; i < cameraCount; ++i) {
        EdsCameraRef tCamera;
        if (EdsGetChildAtIndex(cameraList, i, &tCamera) == EDS_ERR_OK) {
            // Get camera info
            EdsDeviceInfo deviceInfo;
            if (EdsGetDeviceInfo(tCamera, &deviceInfo) == EDS_ERR_OK) {

                models.push_back(
                        CameraModel(deviceInfo.szDeviceDescription,
                                    deviceInfo.deviceSubType, deviceInfo.reserved));
            }
            // Release the camera reference
            EdsRelease(tCamera);
        }
    }
    return models;
}

bool FlutterEdsdk::getChildAtIndex(EdsInt32 index) {
    EdsError err = EdsGetChildAtIndex(cameraList, index, &camera);
    if (err != EDS_ERR_OK) {
        cout << "Fail to get child at index" << endl;
    }
    return err == EDS_ERR_OK;
}

bool FlutterEdsdk::startLivePreview() {
    EdsError err = EDS_ERR_OK;
    EdsUInt32 device;
    err = EdsGetPropertyData(camera, kEdsPropID_Evf_OutputDevice, 0, sizeof(device), &device);
    if (err == EDS_ERR_OK) {
        device |= kEdsEvfOutputDevice_PC;
        err = EdsSetPropertyData(camera, kEdsPropID_Evf_OutputDevice, 0, sizeof(device), &device);
    }
    return err == EDS_ERR_OK;
}


bool FlutterEdsdk::openSession() {
    EdsError err = EdsOpenSession(camera);
    if (err != EDS_ERR_OK) {
        std::cout << "Failed to open session with camera. Error code: " << err << std::endl;
    }
    return err == EDS_ERR_OK;
}

bool FlutterEdsdk::closeSession() {
    EdsError err = EdsCloseSession(camera);
    if (err != EDS_ERR_OK) {
        std::cout << "Failed to close session with camera. Error code: " << err << std::endl;
    }
    return err == EDS_ERR_OK;
}

bool FlutterEdsdk::stopLivePreview() {
    EdsError err = EDS_ERR_OK;
    // Get the output device for the live view image
    EdsUInt32 device;
    err = EdsGetPropertyData(camera, kEdsPropID_Evf_OutputDevice, 0, sizeof(device), &device);
    // PC live view ends if the PC is disconnected from the live view image output device.
    if (err == EDS_ERR_OK) {
        device &= ~kEdsEvfOutputDevice_PC;
        err = EdsSetPropertyData(camera, kEdsPropID_Evf_OutputDevice, 0, sizeof(device), &device);
    }
    return err == EDS_ERR_OK;
}

std::string FlutterEdsdk::downloadEvfImage(const std::string& outputPath) {
    EdsStreamRef stream = nullptr;
    EdsEvfImageRef evfImage = nullptr;
    EdsVoid* buffer = nullptr;
    EdsUInt64 length = 0;

    EdsError err = EdsCreateMemoryStream(0, &stream);
    if (err != EDS_ERR_OK) {
        std::cerr << "Failed to create EVF memory stream. Error: " << err << std::endl;
        return "";
    }

    err = EdsCreateEvfImageRef(stream, &evfImage);
    if (err == EDS_ERR_OK) {
        err = EdsDownloadEvfImage(camera, evfImage);
    }
    if (err == EDS_ERR_OK) {
        err = EdsGetLength(stream, &length);
    }
    if (err == EDS_ERR_OK) {
        err = EdsGetPointer(stream, &buffer);
    }
    if (err == EDS_ERR_OK && buffer != nullptr && length > 0) {
        FILE* file = nullptr;
        fopen_s(&file, outputPath.c_str(), "wb");
        if (file != nullptr) {
            fwrite(buffer, 1, static_cast<size_t>(length), file);
            fclose(file);
        } else {
            std::cerr << "Failed to open EVF output file: " << outputPath << std::endl;
            err = EDS_ERR_FILE_IO_ERROR;
        }
    }

    if (evfImage != nullptr) {
        EdsRelease(evfImage);
    }
    if (stream != nullptr) {
        EdsRelease(stream);
    }

    return err == EDS_ERR_OK ? outputPath : "";
}

std::vector<uint8_t> FlutterEdsdk::downloadEvfBytes() {
    EdsStreamRef stream = nullptr;
    EdsEvfImageRef evfImage = nullptr;
    EdsVoid* buffer = nullptr;
    EdsUInt64 length = 0;
    std::vector<uint8_t> bytes;

    EdsError err = EdsCreateMemoryStream(0, &stream);
    if (err != EDS_ERR_OK) {
        std::cerr << "Failed to create EVF memory stream. Error: " << err << std::endl;
        return bytes;
    }

    err = EdsCreateEvfImageRef(stream, &evfImage);
    if (err == EDS_ERR_OK) {
        err = EdsDownloadEvfImage(camera, evfImage);
    }
    if (err == EDS_ERR_OK) {
        err = EdsGetLength(stream, &length);
    }
    if (err == EDS_ERR_OK) {
        err = EdsGetPointer(stream, &buffer);
    }
    if (err == EDS_ERR_OK && buffer != nullptr && length > 0) {
        auto start = static_cast<uint8_t*>(buffer);
        bytes.assign(start, start + static_cast<size_t>(length));
    }

    if (evfImage != nullptr) {
        EdsRelease(evfImage);
    }
    if (stream != nullptr) {
        EdsRelease(stream);
    }

    return bytes;
}

bool FlutterEdsdk::startRecord() {
    // Assuming camera is already connected and initialized
    EdsError err = EDS_ERR_OK;
    EdsUInt32 record_start = 4;
    err = EdsSetPropertyData(camera, kEdsPropID_Record, 0, sizeof(record_start), &record_start);
    return err == EDS_ERR_OK;
}

bool FlutterEdsdk::stopRecord() {
    // Assuming camera is already connected and initialized
    EdsError err = EDS_ERR_OK;

    EdsUInt32 record_stop = 0; // End movie shooting
    err = EdsSetPropertyData(camera, kEdsPropID_Record, 0, sizeof(record_stop),
                             &record_stop);
    return err == EDS_ERR_OK;
}

bool FlutterEdsdk::addEvent(EdsObjectEventHandler eventHandler) {
    return EdsSetObjectEventHandler(camera, kEdsObjectEvent_All,
                                    eventHandler, NULL) == EDS_ERR_OK;
}

bool FlutterEdsdk::shoot() {
    EdsError err;
    err = EdsSendCommand(camera, kEdsCameraCommand_PressShutterButton,
                         kEdsCameraCommand_ShutterButton_Completely);
    err = EdsSendCommand(camera, kEdsCameraCommand_PressShutterButton,
                         kEdsCameraCommand_ShutterButton_OFF);
    for(int i = 0 ; i <= 10 ; i++){
        err = EdsSendCommand(camera, kEdsCameraCommand_PressShutterButton,
                             kEdsCameraCommand_ShutterButton_Halfway);
        err = EdsSendCommand(camera, kEdsCameraCommand_PressShutterButton,
                             kEdsCameraCommand_ShutterButton_OFF);
    }



//    err = EdsSendCommand(camera, kEdsCameraCommand_TakePicture, 0);
    return err == EDS_ERR_OK;
}


bool FlutterEdsdk::saveToHost() {
    EdsError err = EDS_ERR_OK;
    EdsUInt32 saveTo;

    // Step 1: Check the current SaveTo property
    err = EdsGetPropertyData(camera, kEdsPropID_SaveTo, 0, sizeof(saveTo), &saveTo);
    if (err != EDS_ERR_OK) {
        std::cerr << "Error retrieving SaveTo property: " << err << std::endl;
        return err;
    }

    // Step 2: If not set to Host, change it
    if (saveTo != kEdsSaveTo_Host) {
        saveTo = kEdsSaveTo_Host;
        err = EdsSetPropertyData(camera, kEdsPropID_SaveTo, 0, sizeof(saveTo), &saveTo);
        if (err == EDS_ERR_OK) {
            std::cout << "Successfully set SaveTo to Host." << std::endl;
        } else {
            std::cerr << "Failed to set SaveTo to Host. Error: " << err << std::endl;
        }
    } else {
        std::cout << "SaveTo is already set to Host." << std::endl;
    }

    EdsCapacity newCapacity = {0x7FFFFFFF, 0x1000, 1};
    err = EdsSetCapacity(camera, newCapacity);

    return err == EDS_ERR_OK;
}

bool FlutterEdsdk::clearMem() {
    EdsRelease(camera);
    EdsRelease(cameraList);
    return true;
}


bool FlutterEdsdk::enableAspectRatio() {
    EdsUInt32 id;
    EdsError err;
    id = kEdsPropID_Aspect;
    err = EdsSetPropertyData(camera, 0x01000000, 0x3FB1718B, sizeof(id), &id);
    if (err != EDS_ERR_OK) {
        cout << "Can't set kEdsPropID_Aspect" << endl;
        return false;
    }
    id = kEdsPropID_Evf_VisibleRect;
    err = EdsSetPropertyData(camera, 0x01000000, 0x4D2879F3, sizeof(id), &id);
    if (err != EDS_ERR_OK) {
        cout << "Can't set kEdsPropID_Evf_VisibleRect" << endl;
        return false;
    }
    return true;

}

bool FlutterEdsdk::setAspectRatio(EdsUInt32 aspectRatio) {
    EdsError err;
    err = EdsSetPropertyData(camera, kEdsPropID_Aspect, 0, sizeof(aspectRatio), &aspectRatio);
    return err == EDS_ERR_OK;
}
