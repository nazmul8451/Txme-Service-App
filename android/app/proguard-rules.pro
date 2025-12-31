# Stripe ProGuard Rules
-dontwarn com.stripe.android.pushProvisioning.**
-keep class com.stripe.android.pushProvisioning.** { *; }

# Also adding general Flutter Stripe rules just in case
-keep class com.reactnativestripesdk.** { *; }

# Handling lStar and other common androidx issues if they persist
-dontwarn androidx.core.view.ViewHierarchyEncoder
-dontwarn androidx.core.view.WindowInsetsControllerCompat$Impl30
