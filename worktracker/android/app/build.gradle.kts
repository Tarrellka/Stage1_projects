plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.worktracker"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        // Включаем поддержку Java 8 для уведомлений
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
    }

    kotlinOptions {
        // Должно совпадать с compileOptions
        jvmTarget = "1.8"
    }

    defaultConfig {
        applicationId = "com.example.worktracker"
        // Устанавливаем 21 для корректной работы дешугаринга
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // Обновляем версию здесь:
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}
