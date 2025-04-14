import Flutter
import UIKit
import GoogleMaps

@main
@objc class AppDelegate: FlutterAppDelegate {
private let CHANNEL = "com.example.env_channel"
var iosMapKey: String?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
        let envChannel = FlutterMethodChannel(name: CHANNEL, binaryMessenger: controller.binaryMessenger)

        envChannel.setMethodCallHandler({
          (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
          if call.method == "setApiKeys" {
            if let args = call.arguments as? [String: Any],
               let iosKey = args["iosMapKey"] as? String {
              self.iosMapKey = iosKey
              GMSServices.provideAPIKey(iosKey)
              print("--> Received iOS MAP API KEY: \(iosKey)")
              result(nil)
            } else {
              result(FlutterError(code: "INVALID_ARGUMENT", message: "Missing iOS Key", details: nil))
            }
          } else {
            result(FlutterMethodNotImplemented)
          }
        })

        GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
