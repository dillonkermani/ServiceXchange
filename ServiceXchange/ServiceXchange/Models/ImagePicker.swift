//
//  ImagePicker.swift
//  Campus Post
//
//  Created by Tim Longfield on 2/3/20.
//  Copyright © 2020 Tim Longfield. All rights reserved.
//

import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var showImagePicker: Bool
    @Binding var pickedImage: Image
    @Binding var imageData: Data
    var sourceType: UIImagePickerController.SourceType
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
//        imagePicker.allowsEditing = true
        imagePicker.delegate = context.coordinator
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
        return
    }
    
    func makeCoordinator() -> ImagePicker.Coordinator {
        Coordinator.init(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parentImagePicker: ImagePicker
        
        init(_ imagePicker: ImagePicker) {
            self.parentImagePicker = imagePicker
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            let uiImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            parentImagePicker.pickedImage = Image(uiImage: uiImage)
            if let mediaData = uiImage.jpegData(compressionQuality: 0.5) {
                parentImagePicker.imageData = mediaData
                print(parentImagePicker.imageData)
            }
            parentImagePicker.showImagePicker = false
            
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parentImagePicker.showImagePicker = false
        }
        
    }
}


