import UIKit
import Flutter
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    GMSServices.provideAPIKey(AIzaSyBblx1FKi0Z8ylD3r1D8CuW61YEq9Qq2z4)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
