# Prompt Archive

Date: 2026-04-11
Area: Apple release / widget validation

## User prompt

The value of CFBundleShortVersionString in your WatchKit app's Info.plist (1.2.16) does not match the value in your companion app's Info.plist (1.2.17). These values are required to match.

getting the following when xcode is validating the app Invalid Mach-O header. The __swift5_entry section is missing for the “Payload/Runner.app/PlugIns/PathOfNurHomeWidgets.appex” extension bundle, which prevents the extension from running. You can run the otool command against your binary to ensure there’s a __swift5_entry section.

The server’s response was: ‘{
    code = 90896;
    description = "Invalid Mach-O header. The __swift5_entry section is missing for the \U201cPayload/Runner.app/PlugIns/PathOfNurHomeWidgets.appex\U201d extension bundle, which prevents the extension from running. You can run the otool command against your binary to ensure there\U2019s a __swift5_entry section.";
}’.
