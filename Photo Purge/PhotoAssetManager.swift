//
//  PhotoAssetManager.swift
//  Photo Purge
//
//  Created by Izabela Marcinkowska on 2025-05-09.
//

import Foundation
import Photos
import SwiftUI

class PhotoAssetManager: ObservableObject {
    @Published var assetsToDelete: [String] = []
    private let userDefaultsKey = "PhotoPurge.AssetsToDelete"
    
    init() {
        if let savedAssets = UserDefaults.standard.stringArray(forKey: userDefaultsKey) {
            assetsToDelete = savedAssets
        }
    }
    
    func markForDeletion(asset: PHAsset) {
        let assetId = asset.localIdentifier
        if !assetsToDelete.contains(assetId) {
            assetsToDelete.append(assetId)
            saveToUserDefaults()
        }
    }
    
    func unmarkForDeletion(asset: PHAsset) {
        let assetId = asset.localIdentifier
        if let index = assetsToDelete.firstIndex(of: assetId) {
            assetsToDelete.remove(at: index)
            saveToUserDefaults()
        }
    }
    
    func isMarkedForDeletion(asset: PHAsset) -> Bool {
        return assetsToDelete.contains(asset.localIdentifier)
    }
    
    private func saveToUserDefaults() {
        UserDefaults.standard.set(assetsToDelete, forKey: userDefaultsKey)
    }
    
    func clearAssetsToDelete() {
        assetsToDelete = []
        saveToUserDefaults()
    }
    
    func deleteMarkedPhotos(completion: @escaping (Bool, Error?) -> Void) {
        let fetchOptions = PHFetchOptions()
        let predicate = NSPredicate(format: "localIdentifier IN %@", assetsToDelete)
        fetchOptions.predicate = predicate
        
        let assets = PHAsset.fetchAssets(with: fetchOptions)
        
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.deleteAssets(assets as NSFastEnumeration)
        }) { success, error in
            if success {
                DispatchQueue.main.async {
                    self.clearAssetsToDelete()
                }
            }
            completion(success, error)
        }
    }
    
}
