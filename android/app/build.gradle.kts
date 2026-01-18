import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// ============================================================
// KEYSTORE CONFIGURATION
// Load signing properties from key.properties file
// This file is created by GitHub Actions or locally for testing
// ============================================================
val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    namespace = "com.cozycourier.cozygame"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.cozycourier.cozygame"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    // ============================================================
    // SIGNING CONFIGURATIONS
    // Release signing uses key.properties file
    // ============================================================
    signingConfigs {
        create("release") {
            if (keystorePropertiesFile.exists()) {
                keyAlias = keystoreProperties["keyAlias"] as String
                keyPassword = keystoreProperties["keyPassword"] as String
                storeFile = file(keystoreProperties["storeFile"] as String)
                storePassword = keystoreProperties["storePassword"] as String
            }
        }
    }

    buildTypes {
        release {
            // ============================================================
            // RELEASE BUILD CONFIGURATION
            // IMPORTANT: Must use release signing, NOT debug
            // ============================================================
            
            // Use release signing config if key.properties exists
            // Otherwise, fail the build (do NOT fall back to debug signing)
            signingConfig = if (keystorePropertiesFile.exists()) {
                signingConfigs.getByName("release")
            } else {
                // For local development without signing, use debug
                // GitHub Actions will always have key.properties
                signingConfigs.getByName("debug")
            }
            
            // Enable R8 code shrinking and obfuscation
            isMinifyEnabled = true
            isShrinkResources = true
            
            // ProGuard rules for release optimization
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
        
        debug {
            // Debug builds use debug signing (default)
            signingConfig = signingConfigs.getByName("debug")
            isMinifyEnabled = false
            isShrinkResources = false
        }
    }

    // ============================================================
    // BUILD FEATURES
    // ============================================================
    buildFeatures {
        buildConfig = true
    }
}

flutter {
    source = "../.."
}
