#include "edsdk_outlet.h"

EDSDKOutlet::EDSDKOutlet(flutter::TextureRegistrar* texture_registrar)
        : texture_registrar_(texture_registrar) {
    texture_ =
            std::make_unique<flutter::TextureVariant>(flutter::PixelBufferTexture(
                    [=](size_t width, size_t height) -> const FlutterDesktopPixelBuffer* {
                        const std::lock_guard<std::mutex> lock(mutex_);
                        return &flutter_pixel_buffer_;
                    }));
    texture_id_ = texture_registrar_->RegisterTexture(texture_.get());
}

void EDSDKOutlet::MarkEDSDKFrameAvailable(uint8_t* buffer, int32_t width,
                                          int32_t height) {
    const std::lock_guard<std::mutex> lock(mutex_);
    const auto buffer_size = static_cast<size_t>(width) *
                             static_cast<size_t>(height) * 4;
    pixel_buffer_storage_.assign(buffer, buffer + buffer_size);
    flutter_pixel_buffer_.buffer = pixel_buffer_storage_.data();
    flutter_pixel_buffer_.width = width;
    flutter_pixel_buffer_.height = height;
    texture_registrar_->MarkTextureFrameAvailable(texture_id_);
}

EDSDKOutlet::~EDSDKOutlet() {
    texture_registrar_->UnregisterTexture(texture_id_);
}
