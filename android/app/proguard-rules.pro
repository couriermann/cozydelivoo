# ============================================================
# ProGuard Rules for The Cozy Courier
# Flutter Android Release Build
# ============================================================

# ============================================================
# FLUTTER SPECIFIC RULES
# ============================================================

# Keep Flutter engine classes
-keep class io.flutter.** { *; }
-keep class io.flutter.embedding.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }

# Keep Flutter generated plugin registrant
-keep class io.flutter.plugins.GeneratedPluginRegistrant { *; }

# ============================================================
# PLAY CORE LIBRARY - DONTWARN RULES
# These rules prevent R8 from failing when Play Core classes
# are referenced but not included (deferred components feature)
# ============================================================

# Play Core base classes
-dontwarn com.google.android.play.core.**

# Play Core SplitCompat (deferred components)
-dontwarn com.google.android.play.core.splitcompat.**
-dontwarn com.google.android.play.core.splitcompat.SplitCompat
-dontwarn com.google.android.play.core.splitcompat.SplitCompatApplication

# Play Core SplitInstall (dynamic feature modules)
-dontwarn com.google.android.play.core.splitinstall.**
-dontwarn com.google.android.play.core.splitinstall.SplitInstallManager
-dontwarn com.google.android.play.core.splitinstall.SplitInstallManagerFactory
-dontwarn com.google.android.play.core.splitinstall.SplitInstallRequest
-dontwarn com.google.android.play.core.splitinstall.SplitInstallRequest$Builder
-dontwarn com.google.android.play.core.splitinstall.SplitInstallStateUpdatedListener
-dontwarn com.google.android.play.core.splitinstall.SplitInstallSessionState
-dontwarn com.google.android.play.core.splitinstall.SplitInstallException
-dontwarn com.google.android.play.core.splitinstall.SplitInstallHelper

# Play Core Tasks
-dontwarn com.google.android.play.core.tasks.**
-dontwarn com.google.android.play.core.tasks.Task
-dontwarn com.google.android.play.core.tasks.Tasks
-dontwarn com.google.android.play.core.tasks.OnSuccessListener
-dontwarn com.google.android.play.core.tasks.OnFailureListener
-dontwarn com.google.android.play.core.tasks.OnCompleteListener
-dontwarn com.google.android.play.core.tasks.RuntimeExecutionException

# Play Core Common
-dontwarn com.google.android.play.core.common.**
-dontwarn com.google.android.play.core.listener.**

# Play Core App Update (In-App Updates)
-dontwarn com.google.android.play.core.appupdate.**
-dontwarn com.google.android.play.core.appupdate.AppUpdateManager
-dontwarn com.google.android.play.core.appupdate.AppUpdateManagerFactory
-dontwarn com.google.android.play.core.appupdate.AppUpdateInfo
-dontwarn com.google.android.play.core.appupdate.AppUpdateOptions

# Play Core Review (In-App Review)
-dontwarn com.google.android.play.core.review.**
-dontwarn com.google.android.play.core.review.ReviewManager
-dontwarn com.google.android.play.core.review.ReviewManagerFactory
-dontwarn com.google.android.play.core.review.ReviewInfo

# Play Core Asset Delivery
-dontwarn com.google.android.play.core.assetpacks.**

# ============================================================
# KOTLIN SPECIFIC RULES
# ============================================================

-dontwarn kotlin.**
-dontwarn kotlin.reflect.jvm.internal.**
-keep class kotlin.Metadata { *; }

# ============================================================
# GENERAL ANDROID RULES
# ============================================================

# Keep native methods
-keepclasseswithmembernames class * {
    native <methods>;
}

# Keep Parcelable implementations
-keepclassmembers class * implements android.os.Parcelable {
    public static final android.os.Parcelable$Creator *;
}

# Keep Serializable classes
-keepclassmembers class * implements java.io.Serializable {
    static final long serialVersionUID;
    private static final java.io.ObjectStreamField[] serialPersistentFields;
    private void writeObject(java.io.ObjectOutputStream);
    private void readObject(java.io.ObjectInputStream);
    java.lang.Object writeReplace();
    java.lang.Object readResolve();
}

# Keep R class and its fields
-keepclassmembers class **.R$* {
    public static <fields>;
}

# ============================================================
# HIVE (LOCAL STORAGE) RULES
# ============================================================

-keep class * extends com.hive.** { *; }
-keepclassmembers class * {
    @com.hive.** *;
}

# ============================================================
# OPTIMIZATION SETTINGS
# ============================================================

# Don't note about classes that we've handled
-dontnote android.net.http.**
-dontnote org.apache.http.**

# Remove logging in release builds
-assumenosideeffects class android.util.Log {
    public static int v(...);
    public static int d(...);
    public static int i(...);
}
