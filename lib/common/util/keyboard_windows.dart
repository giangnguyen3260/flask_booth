import 'dart:ffi';

final user32 = DynamicLibrary.open('user32.dll');

final keybd_event = user32.lookupFunction<
    Void Function(Uint8 bVk, Uint8 bScan, Uint32 dwFlags, Pointer dwExtraInfo),
    void Function(int bVk, int bScan, int dwFlags, Pointer dwExtraInfo)>('keybd_event');

void keyDown(int keyCode) {
  try{
    keybd_event(keyCode, 0, 0, nullptr);
  }catch(e){
    //
  }
}
void keyUp(int keyCode) {
  try{
    keybd_event(keyCode, 0, 2, nullptr);
  }catch(e){
    //
  }
}
