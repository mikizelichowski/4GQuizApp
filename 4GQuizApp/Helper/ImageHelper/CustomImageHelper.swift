//
//  CustomImageHelper.swift
//  4GQuizApp
//
//  Created by Mikolaj Zelichowski on 06/10/2023.
//

import SwiftUI

class ImageHelperViewModel: ObservableObject {
    let manager = CacheManager.instance
    private let networkManager = NetworkManager(cache: Cache())
    
    let imageKey: String
    
    @Published var viewStates: ViewStates = ViewStates.ready
    @Published var isLoading: Bool = false
    @Published var assetImage: UIImage? = nil
    
    init(imageKey: String? = nil) {
        self.imageKey = imageKey ?? ""
        self.getImage()
    }
    
    private func getImage() {
        if let saveImage = manager.get(key: imageKey) {
            self.assetImage = saveImage
        } else {
            downloadImage(urlName: imageKey)
        }
    }
    
    private func getPath(width: Int, height: Int, urlName: String) -> String {
        return "https://i.wpimg.pl/\(width)x\(height)\(urlName)"
    }
    
    func downloadImage(urlName: String) {
        self.setViewState(to: .loading)
        
        
        Task {
            let asset =  try await self.networkManager.getImage(imgUrl: urlName)
            
            await MainActor.run {
                guard let image = asset else { return }
                self.manager.add(key: self.imageKey, value: image)
                assetImage = image
            }
            self.setViewState(to: .ready)
        }
    }
    
    private func setViewState(to state: ViewStates) {
        DispatchQueue.main.async {
            self.viewStates = state
            self.isLoading = state == .loading
            
            switch state {
            case .empty, .ready, .error:
                self.isLoading = false
            case .loading:
                self.isLoading = true
            }
        }
    }
}

struct CustomImageHelper: View {
    @StateObject private var loader: ImageHelperViewModel
    
    init(imagekey: String) {
        _loader = StateObject(wrappedValue: ImageHelperViewModel(imageKey: imagekey))
    }
    
    var body: some View {
        ZStack {
            if loader.isLoading {
                ProgressView()
            } else if let image = loader.assetImage {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipped()
                    .frame(width: 300, height: 200)
                    .cornerRadius(4, corners: .allCorners)
            }
        }
    }
}

class ImageHelper {
    static let shared = ImageHelper()
    
    func getPath(width: Int, height: Int, urlName: String) -> String {
        let url = urlName.prepareStringFromResponse(start: 7)
        let path = "https://i.wpimg.pl/\(width)x\(height)\(url)"
        return path
    }
}
