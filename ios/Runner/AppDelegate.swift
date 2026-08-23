import Flutter
import UIKit
import CoreTelephony
import ImageIO

@main
@objc class AppDelegate: FlutterAppDelegate {
  private let simChannel = "app.sim_info"
  private let exifChannel = "app.exif"

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

      let exifMethodChannel = FlutterMethodChannel(name: exifChannel, binaryMessenger: controller.binaryMessenger)
      exifMethodChannel.setMethodCallHandler { [weak self] call, result in
        guard let self = self else { return }
        switch call.method {
        case "addExifData":
          do {
            let arguments = call.arguments as? [String: Any] ?? [:]
            try self.addExifData(
              path: arguments["path"] as? String ?? "",
              lat: self.optionalDouble(arguments["lat"]),
              lng: self.optionalDouble(arguments["lng"]),
              accuracy: self.optionalDouble(arguments["accuracy"]),
              altitude: self.optionalDouble(arguments["altitude"]),
              speed: self.optionalDouble(arguments["speed"]),
              heading: self.optionalDouble(arguments["heading"]),
              time: arguments["time"] as? String ?? "",
              userId: arguments["userId"] as? String ?? ""
            )
            result(nil)
          } catch {
            result(FlutterError(code: "EXIF_WRITE_FAILED", message: error.localizedDescription, details: nil))
          }
        case "readExifData":
          do {
            let arguments = call.arguments as? [String: Any] ?? [:]
            result(try self.readExifData(path: arguments["path"] as? String ?? ""))
          } catch {
            result(FlutterError(code: "EXIF_READ_FAILED", message: error.localizedDescription, details: nil))
          }
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

  private func addExifData(
    path: String,
    lat: Double?,
    lng: Double?,
    accuracy: Double?,
    altitude: Double?,
    speed: Double?,
    heading: Double?,
    time: String,
    userId: String
  ) throws {
    let fileURL = try normalizedFileURL(path: path)
    guard FileManager.default.fileExists(atPath: fileURL.path) else {
      throw NSError(domain: "Exif", code: 1, userInfo: [NSLocalizedDescriptionKey: "Image file does not exist: \(path)"])
    }

    guard let source = CGImageSourceCreateWithURL(fileURL as CFURL, nil) else {
      throw NSError(domain: "Exif", code: 2, userInfo: [NSLocalizedDescriptionKey: "Could not open image source"])
    }

    let imageCount = CGImageSourceGetCount(source)
    guard imageCount > 0 else {
      throw NSError(domain: "Exif", code: 3, userInfo: [NSLocalizedDescriptionKey: "Image source has no frames"])
    }

    guard let imageType = CGImageSourceGetType(source) else {
      throw NSError(domain: "Exif", code: 4, userInfo: [NSLocalizedDescriptionKey: "Could not determine image type"])
    }

    let tempURL = fileURL
      .deletingLastPathComponent()
      .appendingPathComponent("\(UUID().uuidString).tmp")

    guard let destination = CGImageDestinationCreateWithURL(tempURL as CFURL, imageType, imageCount, nil) else {
      throw NSError(domain: "Exif", code: 5, userInfo: [NSLocalizedDescriptionKey: "Could not create image destination"])
    }

    for index in 0..<imageCount {
      let originalProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil) as? [String: Any] ?? [:]
      var properties = originalProperties

      if index == 0 {
        properties = updatedExifProperties(
          originalProperties,
          lat: lat,
          lng: lng,
          accuracy: accuracy,
          altitude: altitude,
          speed: speed,
          heading: heading,
          time: time,
          userId: userId
        )
      }

      CGImageDestinationAddImageFromSource(destination, source, index, properties as CFDictionary)
    }

    guard CGImageDestinationFinalize(destination) else {
      try? FileManager.default.removeItem(at: tempURL)
      throw NSError(domain: "Exif", code: 6, userInfo: [NSLocalizedDescriptionKey: "Could not finalize EXIF image"])
    }

    let updatedData = try Data(contentsOf: tempURL)
    try updatedData.write(to: fileURL, options: .atomic)
    try? FileManager.default.removeItem(at: tempURL)
  }

  private func updatedExifProperties(
    _ properties: [String: Any],
    lat: Double?,
    lng: Double?,
    accuracy: Double?,
    altitude: Double?,
    speed: Double?,
    heading: Double?,
    time: String,
    userId: String
  ) -> [String: Any] {
    var updated = properties
    var exif = properties[kCGImagePropertyExifDictionary as String] as? [String: Any] ?? [:]
    var tiff = properties[kCGImagePropertyTIFFDictionary as String] as? [String: Any] ?? [:]
    var gps = properties[kCGImagePropertyGPSDictionary as String] as? [String: Any] ?? [:]

    if !time.isEmpty {
      exif[kCGImagePropertyExifDateTimeOriginal as String] = time
      tiff[kCGImagePropertyTIFFDateTime as String] = time
    }

    if let lat = lat, let lng = lng {
      gps[kCGImagePropertyGPSLatitude as String] = abs(lat)
      gps[kCGImagePropertyGPSLatitudeRef as String] = lat >= 0 ? "N" : "S"
      gps[kCGImagePropertyGPSLongitude as String] = abs(lng)
      gps[kCGImagePropertyGPSLongitudeRef as String] = lng >= 0 ? "E" : "W"
    }

    if let altitude = altitude {
      gps[kCGImagePropertyGPSAltitude as String] = abs(altitude)
      gps[kCGImagePropertyGPSAltitudeRef as String] = altitude < 0 ? 1 : 0
    }

    if let speed = speed {
      gps[kCGImagePropertyGPSSpeed as String] = speed
    }

    if let heading = heading {
      gps[kCGImagePropertyGPSImgDirection as String] = heading
      gps[kCGImagePropertyGPSImgDirectionRef as String] = "T"
    }

    exif[kCGImagePropertyExifUserComment as String] = "ASCII\u{0}\u{0}\u{0}UserId:\(userId);Accuracy:\(accuracy?.description ?? "")"
    updated[kCGImagePropertyExifDictionary as String] = exif
    updated[kCGImagePropertyTIFFDictionary as String] = tiff
    updated[kCGImagePropertyGPSDictionary as String] = gps

    return updated
  }

  private func readExifData(path: String) throws -> [String: String] {
    let fileURL = try normalizedFileURL(path: path)
    guard let source = CGImageSourceCreateWithURL(fileURL as CFURL, nil),
          let properties = CGImageSourceCopyPropertiesAtIndex(source, 0, nil) as? [String: Any] else {
      throw NSError(domain: "Exif", code: 7, userInfo: [NSLocalizedDescriptionKey: "Could not read image EXIF data"])
    }

    let exif = properties[kCGImagePropertyExifDictionary as String] as? [String: Any] ?? [:]
    let tiff = properties[kCGImagePropertyTIFFDictionary as String] as? [String: Any] ?? [:]
    let gps = properties[kCGImagePropertyGPSDictionary as String] as? [String: Any] ?? [:]

    return [
      "DateTimeOriginal": stringify(exif[kCGImagePropertyExifDateTimeOriginal as String]),
      "DateTime": stringify(tiff[kCGImagePropertyTIFFDateTime as String]),
      "UserComment": stringify(exif[kCGImagePropertyExifUserComment as String]),
      "GPSLatitude": stringify(gps[kCGImagePropertyGPSLatitude as String]),
      "GPSLatitudeRef": stringify(gps[kCGImagePropertyGPSLatitudeRef as String]),
      "GPSLongitude": stringify(gps[kCGImagePropertyGPSLongitude as String]),
      "GPSLongitudeRef": stringify(gps[kCGImagePropertyGPSLongitudeRef as String]),
      "GPSAltitude": stringify(gps[kCGImagePropertyGPSAltitude as String]),
      "GPSSpeed": stringify(gps[kCGImagePropertyGPSSpeed as String]),
      "GPSImgDirection": stringify(gps[kCGImagePropertyGPSImgDirection as String])
    ]
  }

  private func normalizedFileURL(path: String) throws -> URL {
    guard !path.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
      throw NSError(domain: "Exif", code: 8, userInfo: [NSLocalizedDescriptionKey: "Image path is empty"])
    }

    if path.hasPrefix("file://"), let url = URL(string: path) {
      return url
    }

    return URL(fileURLWithPath: path)
  }

  private func stringify(_ value: Any?) -> String {
    guard let value = value else { return "" }
    return "\(value)"
  }

  private func optionalDouble(_ value: Any?) -> Double? {
    if let doubleValue = value as? Double {
      return doubleValue
    }

    if let numberValue = value as? NSNumber {
      return numberValue.doubleValue
    }

    return nil
  }
}
