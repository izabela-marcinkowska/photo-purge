//
//  PhotoReviewView.swift
//  Photo Purge
//
//  Created by Izabela Marcinkowska on 2025-05-02.
//

import SwiftUI
import Photos

struct PhotoReviewView: View {
    var selectedMonth: Date
    
    @EnvironmentObject var photoLibraryManager: PhotoLibraryManager
    @EnvironmentObject var photoAssetManager: PhotoAssetManager
    
    @State private var assets: PHFetchResult<PHAsset>?
    @State private var currentIndex = 0
    @State private var currentImage: UIImage?
    @State private var isLoading = true
    @State private var showSummary = false
    @State private var dragOffset: CGFloat = 0
    @State private var cardRotation: Double = 0
    
    private let screenSize = UIScreen.main.bounds.size
    private let dragThreshold: CGFloat = 150
    
    private func formattedMonth(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: date)
    }
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            if isLoading {
                ProgressView("Loading photos...")
            } else if let assets = assets, assets.count > 0 {
                VStack {
                    HStack {
                        Text("Photo \(currentIndex + 1) of \(assets.count)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.top, 4)
                    
                    ZStack {
                        if let currentImage = currentImage {
                            Image(uiImage: currentImage)
                                .resizable()
                                .scaledToFit()
                                .cornerRadius(10)
                                .shadow(radius: 5)
                                .offset(x: dragOffset)
                                .rotationEffect(.degrees(cardRotation))
                                .gesture(
                                    DragGesture()
                                        .onChanged { value in
                                            dragOffset = value.translation.width
                                            cardRotation = Double(dragOffset / 20)
                                        }
                                        .onEnded { value in
                                            handleSwipe(width: value.translation.width)
                                        }
                                )
                        }
                        
                        if dragOffset > 50 {
                            VStack {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.system(size: 80))
                                    .foregroundColor(.green)
                                    .opacity(min(Double(dragOffset) / 150, 0.8))
                                Text("Keep")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(.green)
                                    .opacity(min(Double(dragOffset) / 150, 0.8))
                            }
                            .offset(x: -120)
                        } else if dragOffset < -50 {
                            VStack {
                                Image(systemName: "trash.circle.fill")
                                    .font(.system(size: 80))
                                    .foregroundColor(.red)
                                    .opacity(min(Double(-dragOffset) / 150, 0.8))
                                Text("Delete")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(.red)
                                    .opacity(min(Double(-dragOffset) / 150, 0.8))
                            }
                            .offset(x: 120)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(.horizontal)
                    
                    if currentIndex == 0 {
                        Text("Swipe right to keep, left to delete")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .padding(.bottom, 8)
                    }
                }
                
            } else {
                VStack {
                    Image(systemName: "photo.on.rectangle.angled")
                        .font(.system(size: 60))
                        .foregroundColor(.gray)
                    Text("No photos found for \(formattedMonth(from: selectedMonth))")
                        .font(.title3)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding()
                }
            }
        }
        .navigationTitle("Review Photos")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Done") {
                    showSummary = true
                }
            }
        }
        .navigationDestination(isPresented: $showSummary) {
            DeleteSummaryView()
        }
        .onAppear {
            loadPhotosForMonth()
        }
    }
    
    private func loadPhotosForMonth() {
        isLoading = true
        
        assets = photoLibraryManager.fetchPhotos(for: selectedMonth)
        
        if let assets = assets, assets.count > 0 {
            loadCurrentImage()
        } else {
            isLoading = false
        }
    }
    
    private func loadCurrentImage() {
        guard let assets = assets, currentIndex < assets.count else {
            isLoading = false
            return
        }
        
        let asset = assets.object(at: currentIndex)
        photoLibraryManager.loadImage(for: asset, targetSize: CGSize(width: screenSize.width, height: screenSize.height)) { image in
            if let image = image {
                self.currentImage = image
                self.isLoading = false
            }
        }
    }
    
    private func handleSwipe(width: CGFloat) {
        if width > dragThreshold {
            handleKeep()
        } else if width < -dragThreshold {
            handleDelete()
        } else {
            withAnimation(.spring()) {
                dragOffset = 0
                cardRotation = 0
            }
        }
    }
    
    private func handleKeep() {
        guard let assets = assets, currentIndex < assets.count else { return }
        
        let asset = assets.object(at: currentIndex)
        photoAssetManager.unmarkForDeletion(asset: asset)
        
        moveToNextPhoto()
    }
    
    private func handleDelete() {
        guard let assets = assets, currentIndex < assets.count else { return }
        
        let asset = assets.object(at: currentIndex)
        photoAssetManager.markForDeletion(asset: asset)
        
        moveToNextPhoto()
    }
    
    private func moveToNextPhoto() {
        withAnimation(.spring()) {
            dragOffset = dragOffset > 0 ? 1000 : -1000
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            currentIndex += 1
            
            if let assets = assets, currentIndex >= assets.count {
                showSummary = true
                return
            }
            
            dragOffset = 0
            cardRotation = 0
            
            isLoading = true
            loadCurrentImage()
        }
    }
    
}
