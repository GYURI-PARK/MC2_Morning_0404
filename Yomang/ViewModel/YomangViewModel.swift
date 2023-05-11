//
//  YomangModel.swift
//  Yomang
//
//  Created by jose Yun on 2023/05/05.
//
// 요망 데이터 얻기
// 호제가

import SwiftUI
import PhotosUI
import CoreTransferable

@MainActor
class YomangViewModel: ObservableObject {
    
    @Published var savedImage: UIImage?
    
    // navigation cancel
    @Published var cancel: Bool = false
    
    @Published var test: String = "test"
        
    enum ImageState {
        case empty
        case loading(Progress)
//        case success(Image)
        case success(UIImage)
        case failure(Error)
    }
    
    enum ImageCroppedState {
        case empty
//        case success(Image)
        case success(UIImage)
        case failure(Error)
    }
    
    enum TransferError: Error {
        case importFailed
    }
    
    struct YomangImage: Transferable {
        let image: UIImage
        
        static var transferRepresentation: some TransferRepresentation {
            DataRepresentation(importedContentType: .image) { data in
            #if canImport(AppKit)
                guard let nsImage = NSImage(data: data) else {
                    throw TransferError.importFailed
                }
                let image = Image(nsImage: nsImage)
                return ProfileImage(image: image)
            #elseif canImport(UIKit)
                guard let uiImage = UIImage(data: data) else {
                    throw TransferError.importFailed
                }
//                let image = Image(uiImage: uiImage)
                let image = uiImage
                return YomangImage(image: image)
            #else
                throw TransferError.importFailed
            #endif
            }
        }
    }
    
    @Published private(set) var imageState: ImageState = .empty
    @Published private(set) var imageCroppedState: ImageCroppedState = .empty
    
    @Published var imageSelection: PhotosPickerItem? = nil {
        didSet {
            if let imageSelection {
                let progress = loadTransferable(from: imageSelection)
                imageState = .loading(progress)
            } else {
                imageState = .empty
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func loadTransferable(from imageSelection: PhotosPickerItem) -> Progress {
        return imageSelection.loadTransferable(type: YomangImage.self) { result in
            DispatchQueue.main.async {
                guard imageSelection == self.imageSelection else {
                    print("Failed to get the selected item.")
                    return
                }
                switch result {
                case .success(let profileImage?):
//                    self.imageState = .success(Image(uiImage: profileImage.image))
                    self.imageState = .success(profileImage.image)
                    self.savedImage = profileImage.image
                    
                case .success(nil):
                    self.imageState = .empty
                case .failure(let error):
                    self.imageState = .failure(error)
                }
            }
        }
    }
    
    // MARK: - IMAGECROPPED
    @Published var imageCropped: UIImage? = nil {
        didSet {
            if let imageCropped {
                imageCroppedState = .success(imageCropped)
            } else {
                imageCroppedState = .empty
            }
        }
    }
    
    

}
