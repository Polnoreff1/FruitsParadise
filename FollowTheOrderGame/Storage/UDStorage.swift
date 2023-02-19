//
//  UDStorage.swift
//  FollowTheOrderGame
//
//  Created by Андрей on 18.02.2023.
//

import Foundation

protocol IUDStorage {
    func value<Value: Codable>(forKey key: String) -> Value?
    func set<Value: Codable>(_ value: Value, forKey key: String)
    func clearValue(forKey key: String)
}

class UDStorage: IUDStorage {
    
    // Dependencies
    private let userDefaults: UserDefaults = .standard
    
    // MARK: - Storable
    
    func value<Value: Codable>(forKey key: String) -> Value? {
        if let data: Data  = userDefaults.object(forKey: key) as? Data {
            return try? JSONDecoder().decode(Value.self, from: data)
        } else {
            return nil
        }
    }
    
    func set<Value: Codable>(_ value: Value, forKey key: String) {
        if let data: Data = try? JSONEncoder().encode(value) {
            userDefaults.set(data, forKey: key)
        }
    }
    
    func clearValue(forKey key: String) {
        userDefaults.removeObject(forKey: key)
    }
}
