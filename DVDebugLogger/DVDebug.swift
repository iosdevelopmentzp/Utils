//
//  DebugLogger.swift
//  DebugLogger
//
//  Created by 6 on 22.07.2020.
//  Copyright © 2020 6. All rights reserved.
//

import UIKit

// MARK: - DebugLoggerType

public enum DVDebugLoggerType: String {
    case appLyfeCycle = "Application Lyfe Cycle"
    case common = "Common"
    case network = "Network"
    case ui = "UI"
}

// MARK: - DebugLoggerPriority

public enum DVDebugLoggerPriority: Int, Codable {
    case low
    case medium
    case high
}

// MARK: - DebugLoggerConsoleOutputMethod

public enum DVDebugLoggerConsoleOutputMethod {
    case print
    case debugPrint
}

// MARK: - DebugLogger

public final class DVDebug: NSObject {

    private override init() {
        super.init()
    }
    
    private lazy var cacheManager = DVDebugLoggerCacheManager()
    private var consoleOutputType: DVDebugLoggerConsoleOutputMethod = .debugPrint
    
    // MARK: Public
    
    public static let `default` = DVDebug()
    
    public func setupLogger() {
        self.sendAppLifeCycleLog(message: "✅ DebugLogger has been initialized")
        setupNotifications()
    }
    
    public func log(_ message: String,
                    type: DVDebugLoggerType = .common,
                    hashtags: [String] = [],
                    priority: DVDebugLoggerPriority = .medium,
                    consoleMethod: DVDebugLoggerConsoleOutputMethod? = nil) {
        let consoleMethod = consoleMethod ?? consoleOutputType
        ptintToConsole(message, methodType: consoleMethod)

        let id = UUID()
        let logObject = DVLoggerObject.init(type: type.rawValue, priority: priority, content: message, date: Date(), id: id.uuidString, hashtags: hashtags)
        cacheManager.save(object: logObject)
    }
    
    public func getLocalLogs(completion: @escaping (String?) -> Void) {
        cacheManager.uploadLogs { result in

            switch result {
            case .success(let loggers):
                let text = loggers.map { $0.content }.reduce("") { (result, current) -> String in
                    let nextText = result + " || " + current
                    return nextText
                }
                completion(text)
            case .failure(_):
                completion(nil)
            }
        }
    }
    
    public func clearLocalLogs() {
        cacheManager.removeAllLogs()
    }
    
    public func loggerViewController() -> UIViewController {
        return DebugLoggerViewController()
    }
    
    // MARK: - Internal
    
    internal func getLocalLogsObjects(completion: @escaping (Result<[DVLoggerObject], Error>) -> Void ) {
        cacheManager.uploadLogs { result in
            completion(result)
        }
    }
    
    internal func remove(log: DVLoggerObject, completion: @escaping (Result<Void, Error>) -> Void) {
        self.cacheManager.removeLogObject(log, completion: completion)
    }
    
    // MARK: - Private methods
    
    private func ptintToConsole(_ message: String, methodType: DVDebugLoggerConsoleOutputMethod) {
        switch methodType {
        case .print:
            print(message)
        case .debugPrint:
            debugPrint(message)
        }
    }
    
    // MARK: - Notifications
    
    private func setupNotifications() {
        
        let notificationInfo: [(name: NSNotification.Name, selector: Selector)] = [
            (UIApplication.willTerminateNotification, #selector(self.applicationWillTerminate(notification:))),
            (UIApplication.didEnterBackgroundNotification, #selector(self.applicationDidEnterBackground(notification:))),
            (UIApplication.willEnterForegroundNotification, #selector(self.applicationWillEnterForeground(notification:))),
            (UIApplication.didFinishLaunchingNotification, #selector(self.applicationDidFinishLaunching(notification:))),
            (UIApplication.didBecomeActiveNotification, #selector(self.applicationDidBecomeActive(notification:))),
            (UIApplication.willResignActiveNotification, #selector(self.applicationWillResignActive(notification:))),
            (UIApplication.didReceiveMemoryWarningNotification, #selector(self.applicationDidReceiveMemoryWarning(notification:)))
        ]
        
        for info in notificationInfo {
            NotificationCenter.default.addObserver(self,
                                                   selector: info.selector,
                                                   name: info.name,
                                                   object: nil)
        }
    }
    
    private func sendAppLifeCycleLog(message: String) {
        let content = "🌀 \(message)"
        self.log(content, type: .appLyfeCycle, hashtags: ["applicationlifecycle"], priority: .high, consoleMethod: self.consoleOutputType)
    }
    
    @objc private func applicationWillTerminate(notification: Notification) {
        sendAppLifeCycleLog(message: "Application Will Terminate Event")
    }
    
    @objc private func applicationDidEnterBackground(notification: Notification) {
        sendAppLifeCycleLog(message: "Application Did Enter Background")
    }
    
    @objc private func applicationWillEnterForeground(notification: Notification) {
        sendAppLifeCycleLog(message: "Application Will Enter Foreground")
    }
    
    @objc private func applicationDidFinishLaunching(notification: Notification) {
        sendAppLifeCycleLog(message: "Application Did Finish Launching")
    }
    
    @objc private func applicationDidBecomeActive(notification: Notification) {
        sendAppLifeCycleLog(message: "Application Did Become Active")
    }
    
    @objc private func applicationWillResignActive(notification: Notification) {
        sendAppLifeCycleLog(message: "Application Will Resign Active")
    }
    
    @objc private func applicationDidReceiveMemoryWarning(notification: Notification) {
        sendAppLifeCycleLog(message: "Application Did Reseive Memory Warning")
    }
}

// MARK: - Convinience global function

public func debugLog(_ message: String,
                     type: DVDebugLoggerType = .common,
                     hashtags: [String] = [],
                     priority: DVDebugLoggerPriority = .medium,
                     consoleMethod: DVDebugLoggerConsoleOutputMethod? = nil) {
    DVDebug.default.log(message, type: type, hashtags: hashtags, priority: priority, consoleMethod: consoleMethod)
}
