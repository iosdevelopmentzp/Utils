//
//  DVDebugLoggerCacheManager.swift
//  DebugLogger
//
//  Created by 6 on 22.07.2020.
//  Copyright © 2020 6. All rights reserved.
//

import Foundation

internal final class DVDebugLoggerCacheManager {
    
    // MARK: - Private
    
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    private let fileManager = FileManager.default
    
    private let updateQueue: DispatchQueue = {
        let appName = Bundle.main.object(forInfoDictionaryKey: kCFBundleNameKey as String) as? String ?? ""
        return DispatchQueue(label: "\(appName).debug.logger.serial.update.queue", qos: .default)
    }()
    
    private lazy var cachedFolderDirectory: URL? = {
        guard var documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last else {
            return nil
        }
        
        documentDirectory.appendPathComponent("DebugLoggerCachedTextFilesFolder")
        
        if !fileManager.fileExists(atPath: documentDirectory.path) {
            do {
                try fileManager.createDirectory(at: documentDirectory, withIntermediateDirectories: true, attributes: nil)
            } catch {
                debugPrint("\(String(describing: self)) Failed create cached directory. \(error)")
            }
        }
        
        return documentDirectory
    }()
    
    // MARK: - Public
    
    internal func save(object: DVLoggerObject) {
        
        guard let url = createFileUrl(id: object.id) else {
            debugPrint("\(String(describing: self)) Failed attempt write text to disk. Failed to create URL")
            return
        }
        
        updateQueue.async { [weak self] in
            guard let self = self else { return }
            do {
                let jsonData = try self.encoder.encode(object)
                try jsonData.write(to: url)
            }  catch let error {
                debugPrint("\(String(describing: self)). Failed attempt write text to disk \(error)")
            }
        }
    }
    
    internal func uploadLogs(completion: @escaping (Result<[DVLoggerObject], Error>) -> Void ) {
        updateQueue.async { [weak self] in
            guard let self = self else {
                completion(.failure(CacheManagerError.selfDDeinitialized))
                return
            }
            
            guard let cachedFolderDirectory = self.cachedFolderDirectory else {
                completion(.failure(CacheManagerError.failedAttemptGetCacheDirectory))
                return
            }
            
            do {
                let urls = try self.fileManager.contentsOfDirectory(at: cachedFolderDirectory, includingPropertiesForKeys: nil, options: [])
                
                let objects: [DVLoggerObject] = urls
                    .compactMap { try? Data(contentsOf: $0) }
                    .compactMap { [weak self] in try? self?.decoder.decode(DVLoggerObject.self, from: $0) }
                completion(.success(objects))
            } catch {
                debugPrint("\(String(describing: self)). Failed get loggers. \(error.localizedDescription)")
                completion(.failure(CacheManagerError.failManagerError(error)))
            }
        }
    }
    
    internal func removeAllLogs() {
        updateQueue.async { [weak self] in
            guard let self = self else { return }
            
            guard let cachedFolderDirectory = self.cachedFolderDirectory else {
                return
            }
            
            do {
                let urls = try self.fileManager.contentsOfDirectory(at: cachedFolderDirectory, includingPropertiesForKeys: nil, options: [])
                
                urls.forEach { [weak self] in try? self?.fileManager.removeItem(at: $0) }
            } catch {
                debugPrint("\(String(describing: self)). Failed remove all logs. \(error.localizedDescription)")
            }
        }
    }
    
    internal func removeLogObject(_ log: DVLoggerObject, completion: @escaping (Result<Void, Error>) -> Void) {
        updateQueue.async { [weak self] in
            guard let url = self?.createFileUrl(id: log.id) else {
                completion(.failure(CacheManagerError.failedAttemptGetCacheDirectory))
                return
            }
            do {
                try self?.fileManager.removeItem(at: url)
                completion(.success(()))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - Help methods
    
    private func createNewFileAndWriteText(_ text: String, url: URL) {
        let data = text.data(using: .utf8)
        do {
            try data?.write(to: url)
        } catch let error {
            debugPrint("\(String(describing: self)). Failed attempt create new file and write text to disk \(error)")
        }
    }
    
    private func createFileUrl(id: String) -> URL? {
        guard let cachedDirectory = cachedFolderDirectory else {
            return nil
        }
        return cachedDirectory.appendingPathComponent("\(id)")
    }
    
    // MARK - Error
    
    internal enum CacheManagerError: Error {
        case selfDDeinitialized
        case failedAttemptGetCacheDirectory
        case failManagerError(_ error: Error)
    }
}
