# Stripe ProGuard Rules
-dontwarn com.stripe.android.pushProvisioning.**
-keep class com.stripe.android.pushProvisioning.** { *; }

# Also adding general Flutter Stripe rules just in case
-keep class com.reactnativestripesdk.** { *; }

# Handling lStar and other common androidx issues if they persist
-dontwarn androidx.core.view.ViewHierarchyEncoder
-dontwarn androidx.core.view.WindowInsetsControllerCompat$Impl30

-dontwarn com.stripe.android.pushProvisioning.PushProvisioningActivity$g
-dontwarn com.stripe.android.pushProvisioning.PushProvisioningActivityStarter$Args
-dontwarn com.stripe.android.pushProvisioning.PushProvisioningActivityStarter$Error
-dontwarn com.stripe.android.pushProvisioning.PushProvisioningActivityStarter
-dontwarn com.stripe.android.pushProvisioning.PushProvisioningEphemeralKeyProvider
-dontwarn kotlinx.parcelize.Parceler$DefaultImpls
-dontwarn kotlinx.parcelize.Parceler
-dontwarn kotlinx.parcelize.Parcelize
# Keep Stripe classes
-keep class com.stripe.** { *; }

# Keep rules for open_file plugin
-keep class com.crazecoder.openfile.** { *; }
-dontwarn com.crazecoder.openfile.**
