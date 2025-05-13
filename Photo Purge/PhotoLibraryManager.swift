//
//  PhotoLibraryManager.swift
//  Photo Purge
//
//  Created by Izabela Marcinkowska on 2025-05-05.
//

import Foundation
import Photos
import SwiftUI

class PhotoLibraryManager: ObservableObject {
    @Published var authorizationStatus: PHAuthorizationStatus = .notDetermined
    
    init() {
        checkPermission()
    }
    
    func checkPermission() {
        authorizationStatus = PHPhotoLibrary.authorizationStatus(for: .readWrite)
    }
    
    func requestPermission() {
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
            DispatchQueue.main.async {
                self.authorizationStatus = status
            }
        }
    }
    
    var hasPermission: Bool {
        return authorizationStatus == .authorized || authorizationStatus == .limited
    }
    
    
    func fetchPhotos(for date: Date) -> PHFetchResult<PHAsset> {
        let calendar = Calendar.current
        
        let normalizedDate = calendar.date(from:
            calendar.dateComponents([.year, .month], from: date))!
        
        let startDate = normalizedDate
        
        let endDate = calendar.date(byAdding: .month, value: 1, to: startDate)!
        
        let predicate = NSPredicate(format: "creationDate >= %@ AND creationDate < %@",
            startDate as NSDate, endDate as NSDate)
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = predicate
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        
        return PHAsset.fetchAssets(with: .image, options: fetchOptions)
    }
    
    func loadImage(for asset: PHAsset, targetSize: CGSize, completion: @escaping(UIImage?) -> Void) {
        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat
        options.isNetworkAccessAllowed = true
        options.isSynchronous = false
        
        PHImageManager.default().requestImage(
            for: asset,
            targetSize: targetSize,
            contentMode: .aspectFill,
            options: options
        ) { image, info in
                completion(image)
        }
    }
}
