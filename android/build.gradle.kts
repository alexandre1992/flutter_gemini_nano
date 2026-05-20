plugins {
    id("com.android.library")
    id("org.jetbrains.kotlin.android")
}

android {
    namespace = "br.com.example.flutter_gemini_nano"

    compileSdk = 36

    defaultConfig {
        minSdk = 26
        targetSdk = 36
    }

    compileOptions {
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = "17"
    }

    // ✅ Plugin usa Kotlin
    sourceSets["main"].java.srcDirs("src/main/kotlin")

    lint {
        checkReleaseBuilds = false
    }
}

dependencies {
    implementation("com.google.mlkit:genai-prompt:1.0.0-beta2")
    implementation(platform("org.jetbrains.kotlinx:kotlinx-coroutines-bom:1.10.2"))
    implementation("org.jetbrains.kotlinx:kotlinx-coroutines-core")
    implementation("androidx.activity:activity-ktx:1.8.0")
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}