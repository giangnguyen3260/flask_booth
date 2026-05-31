template<typename T>
std::string ListToJson(const std::vector<T>& list) {
    std::string jsonStr = "[";

    for (size_t i = 0; i < list.size(); ++i) {
        jsonStr += list[i].toJson();
        if (i < list.size() - 1) {
            jsonStr += ",";
        }
    }

    jsonStr += "]";
    return jsonStr;
}


