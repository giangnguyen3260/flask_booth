#include "string"

class XFile{
    string videoPath;
    string imagePath;

public:
    XFile(){
        videoPath = "";
        imagePath = "";
    }

    XFile(string videoPath, string imagePath) : videoPath(videoPath), imagePath(imagePath){

    }

    std::string toJson() const {
        std::string jsonStr = "{";
        jsonStr += "\"videoPath\":\"" + videoPath + "\",";
        jsonStr += "\"imagePath\":\"" + imagePath + "\"";
        jsonStr += "}";
        return jsonStr;
    }
};