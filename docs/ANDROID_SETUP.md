# Konfigurasi Platform untuk Notifikasi

Lakukan setelah membuat kerangka proyek dengan `flutter create` (lihat README).

## Android

### 1. `android/app/src/main/AndroidManifest.xml`

Tambahkan di dalam `<manifest>` (di atas `<application>`):

```xml
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
<uses-permission android:name="android.permission.VIBRATE"/>
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
<uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM"/>
```

Tambahkan di dalam `<application>` (setelah `<activity>...</activity>`):

```xml
<receiver android:exported="false"
    android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationReceiver" />
<receiver android:exported="false"
    android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationBootReceiver">
    <intent-filter>
        <action android:name="android.intent.action.BOOT_COMPLETED"/>
        <action android:name="android.intent.action.MY_PACKAGE_REPLACED"/>
        <action android:name="android.intent.action.QUICKBOOT_POWERON" />
        <action android:name="com.htc.intent.action.QUICKBOOT_POWERON"/>
    </intent-filter>
</receiver>
```

### 2. `android/app/build.gradle` (atau `build.gradle.kts`)

Plugin notifikasi memerlukan *core library desugaring* dan Java 17.

Groovy (`build.gradle`):

```groovy
android {
    compileOptions {
        coreLibraryDesugaringEnabled true
        sourceCompatibility JavaVersion.VERSION_17
        targetCompatibility JavaVersion.VERSION_17
    }
    kotlinOptions { jvmTarget = '17' }
}

dependencies {
    coreLibraryDesugaring 'com.android.tools:desugar_jdk_libs:2.1.4'
}
```

Kotlin DSL (`build.gradle.kts`):

```kotlin
android {
    compileOptions {
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }
    kotlinOptions { jvmTarget = "17" }
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}
```

Jika blok `dependencies { }` belum ada di file tersebut, tambahkan di bagian bawah file.

### 3. Menguji

1. Jalankan aplikasi, izinkan notifikasi saat diminta.
2. Menu titik tiga di halaman **Hari Ini** > **Tes notifikasi** (muncul dalam 5 detik).
3. Tambahkan obat dengan jam 2-3 menit dari sekarang, tutup aplikasi, tunggu notifikasi.

## iOS

Di `ios/Runner/AppDelegate.swift`, di dalam `application(_:didFinishLaunchingWithOptions:)`
sebelum `return`, tambahkan:

```swift
if #available(iOS 10.0, *) {
  UNUserNotificationCenter.current().delegate = self as UNUserNotificationCenterDelegate
}
```
