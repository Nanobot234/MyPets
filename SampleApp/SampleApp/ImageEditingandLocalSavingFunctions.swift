//
//  ImageEditingFunctions.swift
//  SampleApp
//
//  Created by Nana Bonsu on 6/26/23.
//

import Foundation
import UIKit

extension ImageEditingViewController {
    
    ///sets the alpha value of the current pet image based on the current value of the slider
    @objc func opacitySliderValueChanged() {
        let opacity = opacitySlider.value
        editedImageView.alpha = CGFloat(opacity)
    }
    
    ///scales the image based on the distortion Value in the associated slider
    ///
    ///The function transforms the image ,but currently does not save the transformed image to the server or to the users device
    @objc func distortionSliderValueChanged() {
        let distortion = distortionSlider.value
        
        let transform = CGAffineTransform(scaleX: CGFloat(1.0 + distortion), y: CGFloat(1.0 + distortion))
        
        editedImageView.transform = transform

    }
    
    
    
    /// Changes the expore level of the image based on the value of the assciated slider
    @objc func exposureSliderValueChanged() {
        
        let exposureval = exposureSlider.value
        let ciImage = CIImage(image: editedImageView.image!)
        
        if let filter = CIFilter(name: "CIExposureAdjust") {
            filter.setValue(ciImage, forKey: kCIInputImageKey)
            filter.setValue(exposureval, forKey: kCIInputEVKey)
            
            let context = CIContext(options: nil)
            if let outputImage = filter.outputImage, let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
                editedImageView.image = UIImage(cgImage: cgImage)
            } else {
                print("Problem")
            }
        }
        
    }
    
    
    /// Generates a rotated image by a certain angle
    /// - Parameters:
    ///   - image: The image to be rotated
    ///   - angle: The angle to rotate the image by
    /// - Returns: The rotated image
    func rotateImage(_ image: UIImage, by angle: CGFloat) -> UIImage {
        
            UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
            let context = UIGraphicsGetCurrentContext()!
            
            context.translateBy(x: image.size.width / 2, y: image.size.height / 2)
            context.rotate(by: angle)
            image.draw(in: CGRect(origin: CGPoint(x: -image.size.width / 2, y: -image.size.height / 2), size: image.size))
            
            let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            
            return rotatedImage
        }
    
    
    
    /// Presents various alerts to the user. Based on the alertReason parameter, various alert actions will be performed
    /// - Parameter alertReason: The purpose why an alert is requested. the `alertReason` determines which alertMessage will be displayed and which alertAction will be performed.
    func showAlerttoUser(alertReason:String) {
        
        var alertMessage: UIAlertController
    
        if(alertReason == "uploadRequest") {
            alertMessage = UIAlertController(title: "Upload Image", message: "Are you sure you want to upload the current image with the edits", preferredStyle: .alert)
            
            let confirmButton = UIAlertAction(title: "Yes", style: .default) { UIAlertAction in
                self.uploadUrlRetrieval()
            }
            
            let cancel = UIAlertAction(title: "No", style: .cancel)
            
            alertMessage.addAction(confirmButton)
            alertMessage.addAction(cancel)
            
            self.present(alertMessage, animated: true, completion: nil)
        }
        else if(alertReason == "successfulUpload"){
            
            alertMessage = UIAlertController(title: "Success", message: "Your image has been sucessfully uploaded", preferredStyle: .alert)
            
            let dismissButton = UIAlertAction(title: "Ok", style: .cancel)
           
            alertMessage.addAction(dismissButton)
            self.present(alertMessage, animated: true, completion: nil)
        }
        
        else if(alertReason == "saveToCamera") {
            guard let image = editedImageView.image else { return }

            
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
            
            let dismissButton = UIAlertAction(title: "Ok", style: .cancel)
            
            alertMessage = UIAlertController(title: "Saved", message: "Your image has been sucessfully saved to your Photos. Dont forget to share it!", preferredStyle: .alert)
            
            alertMessage.addAction(dismissButton)
            self.present(alertMessage, animated: true, completion: nil)
        }
    }
    
 
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            print("Error saving image: \(error.localizedDescription)")
        } else {
            print("Image saved successfully!")
        }
    }
}
