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
                    .padding()
                    
                    Spacer()
                    
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
                                    .font(.system(size: 60))
                                    .foregroundColor(.green)
                                    .opacity(Double(dragOffset) / 150)
                                Text("Keep")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.green)
                                    .opacity(Double(dragOffset) / 150)
                            }
                        } else if dragOffset < -50 {
                            VStack {
                                Image(systemName: "trash.circle.fill")
                                    .font(.system(size: 60))
                                    .foregroundColor(.red)
                                    .opacity(Double(-dragOffset) / 150)
                                Text("Delete")
                                    .font(.system(size: 60))
                                    .foregroundColor(.red)
                                    .opacity(Double(-dragOffset) / 150)
                            }
                            
                        }
                        
                    }
                    .frame(height: screenSize.height * 0.6)
                    .padding()
                    
                    Spacer()
                    
                    HStack(spacing: 60) {
                        Button(action: {
                            handleKeep()
                        }) {
                            VStack {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.system(size: 40))
                                    .foregroundColor(.green)
                                Text("Keep")
                                    .font(.subheadline)
                                    .foregroundColor(.green)
                            }
                        }
                        
                        Button(action: {
                            handleDelete()
                        }) {
                            VStack {
                                Image(systemName: "trash.circle.fill")
                                    .font(.system(size: 40))
                                    .foregroundColor(.red)
                                Text("Delete")
                                    .font(.subheadline)
                                    .foregroundColor(.red)
                            }
                        }
                    }
                    .padding(.bottom, 30)
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
}
