# Keep Flutter embedding and plugins; stripping them may break runtime loading.
-keep class io.flutter.** { *; }

# Keep the generated main activity (package name aligns with defaultConfig).
-keep class com.example.test_elkood1.MainActivity { *; }
