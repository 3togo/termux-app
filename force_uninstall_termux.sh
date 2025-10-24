adb shell pm list packages | grep termux
adb shell am force-stop com.termux
adb uninstall com.termux
adb shell pm uninstall --user 0 com.termux
adb shell pm clear com.termux

adb shell am force-stop com.termux.boot
adb uninstall com.termux.boot
adb shell pm uninstall --user 0 com.termux.boot
adb shell pm clear com.termux.boot
