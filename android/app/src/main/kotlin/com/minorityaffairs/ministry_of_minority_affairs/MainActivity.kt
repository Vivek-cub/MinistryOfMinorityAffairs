package com.minorityaffairs.ministry_of_minority_affairs

import android.content.Context
import android.telephony.SubscriptionManager
import android.telephony.TelephonyManager
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val simChannel = "app.sim_info"

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
}
