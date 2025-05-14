import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

val localProperties = Properties()
val localPropertiesFile = rootProject.file("local.properties")
if (localPropertiesFile.exists()) {
    localProperties.load(FileInputStream(localPropertiesFile))
}

var flutterVersionCode = "1"
var flutterVersionName = "1.0"
var buff = localProperties["flutter.versionCode"] as String?
buff?.let { versionCode -> flutterVersionCode = versionCode }
buff = localProperties["flutter.versionName"] as String?
buff?.let { versionName -> flutterVersionName = versionName }

android {
    namespace = "org.zeit.example"
    compileSdk = 36 //flutter.compileSdkVersion != last Android SDK version
    ndkVersion = "26.3.11579264" //flutter.ndkVersion != actual Android NDK version

    buildFeatures {
        buildConfig = true
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    packaging {
        // Fixes duplicate libraries build issue,
        // when your project uses more than one plugin that depend on C++ libs.
        //pickFirst = "lib/**/libc++_shared.so"
        jniLibs.pickFirsts.add("lib/**/libc++_shared.so")
    }

    defaultConfig {
        applicationId = "org.zeit.example"
        minSdk = 21
        targetSdk = 36
        versionCode = flutterVersionCode.toInt()
        versionName = flutterVersionName
    }

    buildTypes {
        getByName("debug") {
            isDebuggable = true
            //minifyEnabled = false
        }
        getByName("release") {
            signingConfig = signingConfigs.getByName("debug")
            //enableV3Signing true
            //enableV4Signing true
            minifyEnabled true
            shrinkResources false // Push action icons and launcher foreground saver. True - Push messages will be broken
            proguardFiles getDefaultProguardFile('proguard-android.txt'), 'proguard-rules.pro'
        }
    }

    dependencies {
        coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.5")
    }
}

flutter {
    source = "../.."
}
