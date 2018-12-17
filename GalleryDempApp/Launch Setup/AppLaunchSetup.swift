
import Foundation
import AFNetworking

class AppLaunchSetup: NSObject {
    
    /*
     Create Singleton object for the class
     */
    static let shareInstance = AppLaunchSetup()
    
    private override init() {
    }

    /**
     This method is used to enable network rechability monitoring
     */
    func startMonitoringNetworkRechability() {
        AFNetworkReachabilityManager.shared().startMonitoring()
    }

    /**
     This method is used to check if network is available or not
     */
    static func isNetworkReachable()-> Bool {
        return AFNetworkReachabilityManager.shared().isReachable
    }
}
