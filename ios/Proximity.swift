import ExpoModulesCore
import UIKit

public final class Proximity: Module {
  private var destroyed = false

  public func definition() -> ModuleDefinition {
    Name("Proximity")

    Property("proximityState") {
      if Thread.isMainThread { return UIDevice.current.proximityState }
      return DispatchQueue.main.sync { UIDevice.current.proximityState }
    }

    Property("isProximityMonitoringEnabled") {
      if Thread.isMainThread { return UIDevice.current.isProximityMonitoringEnabled }
      return DispatchQueue.main.sync { UIDevice.current.isProximityMonitoringEnabled }
    }

    Events("proximityStateDidChange")

    OnStartObserving("proximityStateDidChange") {
      DispatchQueue.main.async {
        self.setMonitoringEnabled(true)
      }
    }

    OnStopObserving("proximityStateDidChange") {
      DispatchQueue.main.async {
        self.setMonitoringEnabled(false)
      }
    }

    OnDestroy {
      DispatchQueue.main.async {
        self.destroyed = true
        self.setMonitoringEnabled(false)
      }
    }
  }

  private func setMonitoringEnabled(_ enabled: Bool) {
    guard !destroyed || !enabled else { return }
    NotificationCenter.default.removeObserver(
      self, name: UIDevice.proximityStateDidChangeNotification, object: nil)
    if enabled {
      NotificationCenter.default.addObserver(
        self, selector: #selector(proximityStateDidChange),
        name: UIDevice.proximityStateDidChangeNotification, object: nil)
    }
    UIDevice.current.isProximityMonitoringEnabled = enabled
    if enabled { proximityStateDidChange() }
  }

  @objc private func proximityStateDidChange() {
    sendEvent("proximityStateDidChange", ["proximityState": UIDevice.current.proximityState])
  }
}
