//
//  ImagePicker.swift
//  budgetmanager
//
//  Created by Kiss Roland on 2023. 05. 06..
//

import SwiftUI
import PhotosUI

struct ImagePicker: UIViewControllerRepresentable {
    typealias UIViewControllerType = PHPickerViewController
    typealias Coordinator = ImagePickerCoordinator

    @Binding var image: UIImage?
    @Environment(\.presentationMode) var presentationMode

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images

        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator

        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}

    func makeCoordinator() -> ImagePickerCoordinator {
        return ImagePickerCoordinator(image: $image, presentationMode: presentationMode)
    }
}

class ImagePickerCoordinator: PHPickerViewControllerDelegate {
    @Binding var image: UIImage?
    var presentationMode: Binding<PresentationMode>

    init(image: Binding<UIImage?>, presentationMode: Binding<PresentationMode>) {
        _image = image
        self.presentationMode = presentationMode
    }

    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        guard let itemProvider = results.first?.itemProvider else {
            presentationMode.wrappedValue.dismiss()
            return
        }

        if itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                if let image = image as? UIImage {
                    self?.image = image
                }
                self?.presentationMode.wrappedValue.dismiss()
            }
        } else {
            presentationMode.wrappedValue.dismiss()
        }
    }
}
