import java.util.Properties
import java.io.FileInputStream

val localProperties = Properties().apply {
    val localPropertiesFile = rootProject.file("local.properties")
    if (localPropertiesFile.exists()) {
        localPropertiesFile.inputStream().use { load(it) }
    }
}

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    namespace = "com.hoplift.app"
    compileSdk = 36

    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.hoplift.app"
        manifestPlaceholders.put("appAuthRedirectScheme", "com.hoplift.app")
        minSdk = flutter.minSdkVersion
        targetSdk = 35
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
    create("release") {
        val keyAliasValue = keystoreProperties["keyAlias"] as String?
        val keyPasswordValue = keystoreProperties["keyPassword"] as String?
        val storeFileValue = keystoreProperties["storeFile"] as String?
        val storePasswordValue = keystoreProperties["storePassword"] as String?

        if (
            keyAliasValue != null &&
            keyPasswordValue != null &&
            storeFileValue != null &&
            storePasswordValue != null
        ) {
            keyAlias = keyAliasValue
            keyPassword = keyPasswordValue
            storeFile = file(storeFileValue)
            storePassword = storePasswordValue
        }
    }
}

    buildTypes {
        getByName("release") {
    if (signingConfigs.findByName("release") != null) {
        signingConfig = signingConfigs.getByName("release")
    }
    isMinifyEnabled = true
    isShrinkResources = true
}
    }
}

flutter {
    source = "../.."
}

dependencies {
    implementation("com.facebook.android:facebook-login:16.2.0")
}
