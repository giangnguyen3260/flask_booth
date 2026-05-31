#include "string"

class CameraModel {
    char szDeviceDescription[256];
    int32_t deviceSubType;
    int32_t reserved;

public:
    CameraModel() {
        std::memset(szDeviceDescription, 0, sizeof(szDeviceDescription));
        deviceSubType = 0;
        reserved = 0;
    }

    CameraModel(const char *deviceDescription, int32_t subType, int32_t res)
            : deviceSubType(subType), reserved(res) {
        strncpy_s(szDeviceDescription, deviceDescription, sizeof(szDeviceDescription) - 1);
    }

    std::string toJson() const {
        std::string jsonStr = "{";
        jsonStr += "\"szDeviceDescription\":\"" + std::string(szDeviceDescription) + "\",";
        jsonStr += "\"deviceSubType\":" + std::to_string(deviceSubType) + ",";
        jsonStr += "\"reserved\":" + std::to_string(reserved);
        jsonStr += "}";
        return jsonStr;
    }
};