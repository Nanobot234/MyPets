//
//  imageEditingViewController.swift
//  SampleApp
//
//  Created by Nana Bonsu on 6/24/23.
//

import UIKit


/// Manages the second screen of the application where image edits can be made
///
///This view controller manages the screen where the user can make edits to the pet image that they have selected. Some of these edits include rotation, opacity, inverting colors, and overlaying another image. The edited image can then be saved to the user's device or uploaded to the server.
class ImageEditingViewController: UIViewController {
    
    ///Displays the pet image that the user selects.
    @IBOutlet weak var editedImageView: UIImageView!
    
    ///A slider the user interacts with that adjusts the opacity value of the current image
    @IBOutlet weak var opacitySlider: UISlider!
    
    //////A slider the user interacts with that adjusts the exposure value of the current image
    @IBOutlet weak var exposureSlider: UISlider!
    
    ///A slider the user interacts with that adjusts the image size
    @IBOutlet weak var distortionSlider: UISlider!
    
    ///Displays the image that will be overlaid on the pet image.
    var overlayImageView: UIImageView!
    
    ///spinning indicator to show that image upload is ongoing
    let uploadImgeProgressIndicator = UIActivityIndicatorView(style: .large)
    
    var currentRotationAngle: CGFloat = 0.0
    
    let uploadURL = URL(string: "https://eulerity-hackathon.appspot.com/upload")
    let appID = "Nbonsu2000@gmail.com" //email address to identify
    
    
    var imageRecieved = UIImage()
    var imageURLRecieved = String()
    var imageURL = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        editedImageView.image = imageRecieved
        imageURL = imageURLRecieved
        
        opacitySlider.value = 1.0
        distortionSlider.value = 0.0
        exposureSlider.value = 0.0
        
        opacitySlider.addTarget(self, action: #selector(opacitySliderValueChanged), for: .valueChanged)
        distortionSlider.addTarget(self, action: #selector(distortionSliderValueChanged), for: .valueChanged)
        exposureSlider.addTarget(self, action: #selector(exposureSliderValueChanged), for: .valueChanged)
        
        
        uploadImgeProgressIndicator.center = view.center
        uploadImgeProgressIndicator.hidesWhenStopped = true
        
        view.addSubview(uploadImgeProgressIndicator)
    
    }
    
    /// Inverts the color of the current image of the pet
    /// - Parameter sender: the button that initiates this function
    @IBAction func imageColorInversion(_ sender: Any) {
        let ciImage = CIImage(image: editedImageView.image!)
        
        if let filter = CIFilter(name: "CIColorInvert") {
            filter.setValue(ciImage, forKey: kCIInputImageKey)
            let context = CIContext(options: nil)
            if let outputImage = filter.outputImage, let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
                editedImageView.image = UIImage(cgImage: cgImage)
            }
        }
    }
    
    /// Overlays an image, picked from the user photo gallery, on top of the existing pet image  displayed
    /// - Parameter sender: The UI element that the user interacts with. In this case. The user presses on the button to choose an image to overlay
    @IBAction func overlayNewImage(_ sender: Any) {
        
        let overlayImageViewWidthAmount = editedImageView.frame.width/2
        
        let overlayImageViewHeightAmount = editedImageView.frame.height/2
        
        overlayImageView = UIImageView(frame: CGRectMake(40, 70, overlayImageViewWidthAmount / 2, overlayImageViewHeightAmount / 2))
        
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
        
    }
    
    /// Rotates the image of the pet
    ///
    /// The `rotateImage` function that this function calls returns a rotatedImage that is displayed.
    /// - Parameter sender: button that the user presses which activates this function
    @IBAction func rotateImage(_ sender: Any) {
        
        let rotationAngle = CGFloat.pi / 2;
        let rotatedImage = rotateImage(editedImageView.image!, by: rotationAngle)
       editedImageView.image = rotatedImage
    }
    
    /// Saves the current edited or non edited image to the users photo library
    ///
    ///  the `showAlertToUser' function is called to perfom this action`
    /// - Parameter sender: the save button that the user clicks to initiate this function
    @IBAction func saveImageToDevice(_ sender: Any) {
    
        showAlerttoUser(alertReason: "saveToCamera")
    }
    
    /// Uploads the current edited or non edited image to the server
    ///
    ///  the `showAlertToUser' function is called to perfom this action`
    /// - Parameter sender: the upload Image button that the user clicks to initiate this function
    @IBAction func uploadImage(_ sender: Any) {
        
        showAlerttoUser(alertReason: "uploadRequest")
   
    }
   
}
    

extension ImageEditingViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    /// Function executes after the user has picked an image from their photo library. The picked image is overlaid on top of the existing image.
    ///
    /// The function creates a graphics context that the original image is draw in. Then the overlaid image is drawn on top of the original image to get a combined image that is displayed to the user.
    /// - Parameters:
    ///   - picker: the controller created by implementing this function
    ///   - info: information about what the user selects
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage {
            overlayImageView.image = image
            //need to do some extra things here, to set the UIImage as this image!!
        }
        
        picker.dismiss(animated: true, completion: nil)
      
        let overLayPosition = CGPoint(x: 160, y: 150)

        UIGraphicsBeginImageContextWithOptions(editedImageView.image!.size, false, 0.0)

        editedImageView.image?.draw(in: CGRect(origin: .zero, size: editedImageView.image!.size))
        
        overlayImageView.image?.draw(at: overLayPosition)
        
        let combinedImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        editedImageView.image = combinedImage!
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

}




