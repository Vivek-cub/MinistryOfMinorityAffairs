package com.minorityaffairs.ministry_of_minority_affairs

import android.content.Context
import android.net.Uri
import android.telephony.SubscriptionManager
import android.telephony.TelephonyManager
import androidx.exifinterface.media.ExifInterface
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import java.io.File

class MainActivity : FlutterActivity() {
    private val simChannel = "app.sim_info"
    private val exifChannel = "app.exif"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            simChannel
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "getSimFingerprint" -> result.success(getSimFingerprint())
                "hasSimAvailable" -> result.success(hasSimAvailable())
                else -> result.notImplemented()
            }
        }

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            exifChannel
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "addExifData" -> {
                    try {
                        addExifData(
                            path = call.argument<String>("path").orEmpty(),
                            lat = call.argument<Double>("lat"),
                            lng = call.argument<Double>("lng"),
                            accuracy = call.argument<Double>("accuracy"),
                            altitude = call.argument<Double>("altitude"),
                            speed = call.argument<Double>("speed"),
                            heading = call.argument<Double>("heading"),
                            time = call.argument<String>("time").orEmpty(),
                            userId = call.argument<String>("userId").orEmpty()
                        )
                        result.success(null)
                    } catch (e: Exception) {
                        result.error("EXIF_WRITE_FAILED", e.message, null)
                    }
                }
                "readExifData" -> {
                    try {
                        result.success(
                            readExifData(call.argument<String>("path").orEmpty())
                        )
                    } catch (e: Exception) {
                        result.error("EXIF_READ_FAILED", e.message, null)
                    }
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun addExifData(
        path: String,
        lat: Double?,
        lng: Double?,
        accuracy: Double?,
        altitude: Double?,
        speed: Double?,
        heading: Double?,
        time: String,
        userId: String
    ) {
        require(path.isNotBlank()) { "Image path is empty" }
        val normalizedPath = normalizeFilePath(path)
        val file = File(normalizedPath)

        if (file.exists()) {
            writeExif(ExifInterface(file.absolutePath), lat, lng, accuracy,altitude,speed,heading,time, userId)
            return
        }

        val uri = Uri.parse(path)
        if (uri.scheme == "content") {
            contentResolver.openFileDescriptor(uri, "rw")?.use { descriptor ->
                writeExif(ExifInterface(descriptor.fileDescriptor), lat, lng, accuracy,altitude,speed,heading, time, userId)
                return
            }
        }

        throw IllegalArgumentException("Image file does not exist: $path")
    }

    private fun writeExif(
        exif: ExifInterface,
        lat: Double?,
        lng: Double?,
        accuracy: Double?,
        altitude: Double?,
        speed: Double?,
        heading: Double?,
        time: String,
        userId: String
    ) {
        if (time.isNotBlank()) {
            exif.setAttribute(ExifInterface.TAG_DATETIME_ORIGINAL, time)
            exif.setAttribute(ExifInterface.TAG_DATETIME, time)
        }
        
        if (lat != null && lng != null) {
            exif.setLatLong(lat, lng)
        }
        

        val userComment = "ASCII\u0000\u0000\u0000UserId:$userId;Accuracy:$accuracy"


        if (userComment.isNotEmpty()) {
            exif.setAttribute(
                ExifInterface.TAG_USER_COMMENT,
                userComment
            )
        }
        
        if (altitude != null) {
            exif.setAttribute(
            ExifInterface.TAG_GPS_ALTITUDE,
            toExifRational(altitude)
            )
        }

        if (speed != null) {
            exif.setAttribute(
                ExifInterface.TAG_GPS_SPEED,
                toExifRational(speed)
            )
        }

        if (heading != null) {
            exif.setAttribute(
                ExifInterface.TAG_GPS_IMG_DIRECTION,
                toExifRational(heading)
            )
            exif.setAttribute(
                ExifInterface.TAG_GPS_IMG_DIRECTION_REF,
                "T"
            )
        }

        
        exif.saveAttributes()
        
    }

    private fun readExifData(path: String): Map<String, String?> {
        require(path.isNotBlank()) { "Image path is empty" }
        val normalizedPath = normalizeFilePath(path)
        val file = File(normalizedPath)

        if (file.exists()) {
            return exifAttributes(ExifInterface(file.absolutePath))
        }

        val uri = Uri.parse(path)
        if (uri.scheme == "content") {
            contentResolver.openFileDescriptor(uri, "r")?.use { descriptor ->
                return exifAttributes(ExifInterface(descriptor.fileDescriptor))
            }
        }

        throw IllegalArgumentException("Image file does not exist: $path")
    }

    private fun exifAttributes(exif: ExifInterface): Map<String, String?> {
        return mapOf(
            "DateTimeOriginal" to exif.getAttribute(ExifInterface.TAG_DATETIME_ORIGINAL),
            "DateTime" to exif.getAttribute(ExifInterface.TAG_DATETIME),
            "UserComment" to exif.getAttribute(ExifInterface.TAG_USER_COMMENT),
            "GPSLatitude" to exif.getAttribute(ExifInterface.TAG_GPS_LATITUDE),
            "GPSLatitudeRef" to exif.getAttribute(ExifInterface.TAG_GPS_LATITUDE_REF),
            "GPSLongitude" to exif.getAttribute(ExifInterface.TAG_GPS_LONGITUDE),
            "GPSLongitudeRef" to exif.getAttribute(ExifInterface.TAG_GPS_LONGITUDE_REF),
            "GPSAltitude" to exif.getAttribute(ExifInterface.TAG_GPS_ALTITUDE),
            "GPSSpeed" to exif.getAttribute(ExifInterface.TAG_GPS_SPEED),
            "GPSImgDirection" to exif.getAttribute(ExifInterface.TAG_GPS_IMG_DIRECTION)
        )
    }

    private fun normalizeFilePath(path: String): String {
        return if (path.startsWith("file://")) {
            Uri.parse(path).path ?: path
        } else {
            path
        }
    }

    private fun hasSimAvailable(): Boolean {
        val telephony = getSystemService(Context.TELEPHONY_SERVICE) as TelephonyManager
        val hasSimState = telephony.simState != TelephonyManager.SIM_STATE_ABSENT &&
                telephony.simState != TelephonyManager.SIM_STATE_UNKNOWN

        val hasActiveSubscription = try {
            val manager = getSystemService(Context.TELEPHONY_SUBSCRIPTION_SERVICE) as SubscriptionManager
            val list = manager.activeSubscriptionInfoList ?: emptyList()
            list.isNotEmpty()
        } catch (_: Exception) {
            false
        }

        return hasSimState || hasActiveSubscription
    }

    private fun getSimFingerprint(): String {
        val telephony = getSystemService(Context.TELEPHONY_SERVICE) as TelephonyManager
        val baseFingerprint = listOf(
            telephony.simOperator.orEmpty(),
            telephony.simOperatorName.orEmpty(),
            telephony.simCountryIso.orEmpty(),
            telephony.simState.toString()
        ).joinToString("|")

        val subFingerprint = try {
            val manager = getSystemService(Context.TELEPHONY_SUBSCRIPTION_SERVICE) as SubscriptionManager
            val list = manager.activeSubscriptionInfoList ?: emptyList()
            list.map {
                "${it.mcc}-${it.mnc}-${it.carrierName}-${it.countryIso}"
            }.sorted().joinToString(",")
        } catch (_: Exception) {
            ""
        }

        return "$baseFingerprint#$subFingerprint"
    }

    private fun toExifRational(value: Double): String {
            return "${(value * 100).toInt()}/100"
    }
}
