import Flutter
import UIKit
import CoreTelephony

@main
@objc class AppDelegate: FlutterAppDelegate {
  private let simChannel = "app.sim_info"

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    if let controller = window?.rootViewController as? FlutterViewController {
      let channel = FlutterMethodChannel(name: simChannel, binaryMessenger: controller.binaryMessenger)
      channel.setMethodCallHandler { [weak self] call, result in
        guard let self = self else { return }
        switch call.method {
        case "getSimFingerprint":
          result(self.getSimFingerprint())
        case "hasSimAvailable":
          result(self.hasSimAvailable())
        default:
          result(FlutterMethodNotImplemented)
        }
      }
    }

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  private func getSimFingerprint() -> String {
    let networkInfo = CTTelephonyNetworkInfo()
    var values: [String] = []

    if #available(iOS 12.0, *) {
      if let providers = networkInfo.serviceSubscriberCellularProviders {
        values = providers.values.map { provider in
          let mcc = provider.mobileCountryCode ?? ""
          let mnc = provider.mobileNetworkCode ?? ""
          let carrier = provider.carrierName ?? ""
          let iso = provider.isoCountryCode ?? ""
          return "\(mcc)-\(mnc)-\(carrier)-\(iso)"
        }.sorted()
      }
    } else if let provider = networkInfo.subscriberCellularProvider {
      let mcc = provider.mobileCountryCode ?? ""
      let mnc = provider.mobileNetworkCode ?? ""
      let carrier = provider.carrierName ?? ""
      let iso = provider.isoCountryCode ?? ""
      values = ["\(mcc)-\(mnc)-\(carrier)-\(iso)"]
    }

    return values.joined(separator: ",")
  }

  private func hasSimAvailable() -> Bool {
    let networkInfo = CTTelephonyNetworkInfo()

    if #available(iOS 12.0, *) {
      guard let providers = networkInfo.serviceSubscriberCellularProviders else {
        return false
      }

      let validProviders = providers.values.filter { provider in
        let mcc = provider.mobileCountryCode ?? ""
        let mnc = provider.mobileNetworkCode ?? ""
        let carrier = provider.carrierName ?? ""
        return !(mcc.isEmpty && mnc.isEmpty && carrier.isEmpty)
      }

      return !validProviders.isEmpty
    } else {
      guard let provider = networkInfo.subscriberCellularProvider else {
        return false
      }
      let mcc = provider.mobileCountryCode ?? ""
      let mnc = provider.mobileNetworkCode ?? ""
      let carrier = provider.carrierName ?? ""
      return !(mcc.isEmpty && mnc.isEmpty && carrier.isEmpty)
    }
  }
}
