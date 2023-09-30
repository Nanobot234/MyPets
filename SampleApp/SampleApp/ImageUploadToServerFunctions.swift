//
//  imageUploadToServerFunctions.swift
//  SampleApp
//
//  Created by Nana Bonsu on 6/26/23.
//

import Foundation
import UIKit


extension ImageEditingViewController {
    
    /// Retrieves the URL that the image will later be uploaded to
    func uploadUrlRetrieval() {
        
        
        guard let uploadURLink = uploadURL else {
            print("Image is not valid or isnt found")
            return}
        
        uploadImgeProgressIndicator.startAnimating()
        uploadImgeProgressIndicator.isUserInteractionEnabled = false
        view.isUserInteractionEnabled = false
        
        _ = Utilities.shared.fetchData(from: uploadURLink) { result in
            switch result {
            
            case .success(let data):
                
                do {
                    let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    
                    guard let uploadURLString = jsonObject?["url"] as? String, let uploadURL = URL(string: uploadURLString) else {
                        print("Invalid upload URL received.")
                        return
                    }
                    
                    DispatchQueue.main.async {
                        self.uploadImageFile(uploadURL: uploadURL)
                    }
                    
                } catch {
                    print("Error parsing JSON response: \(error.localizedDescription)")
                }
                
            case .failure(let err):
                    print("Error retrieving upload URL: \(err.localizedDescription)")
                    return
                
            }
            
            }
        
    
    }
    
    ///  uploads Image to the server using mult part form data encoing
    /// - Parameters:
    ///   - uploadURL:  the URL that describes where the image should be uploaded on the server.
    func uploadImageFile(uploadURL: URL) {
        let boundary = UUID().uuidString
        let imageURL = URL(string: imageURL)!
        var request = URLRequest(url: uploadURL)
        
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        
        let formData = createMultipartFormData(imageURL: imageURL,boundary: boundary)
        request.httpBody = formData
        //can this be placed in a method? will need to test out
        
            _ = Utilities.shared.uploadData(from: request) { result in
                
                switch result {
                case .success(let data):
                    
                    print("Image uploaded successfully.")
                    print("Response data: \(String(data: data, encoding: .utf8) ?? "")")
                    
                    DispatchQueue.main.async {
                        self.uploadImgeProgressIndicator.stopAnimating()
                        self.view.isUserInteractionEnabled = true
                        self.showAlerttoUser(alertReason: "successfulUpload")
                    }
                    
                case .failure(let err):
                    print("Error uploading image: \(err.localizedDescription)")
                    return
                }
            }
            
        
    }
       
    
    ///  creates form data with the appropriate  encoding
    /// - Parameters:
    ///   - boundary:A string that unique identifies this form data
    /// - Returns: the formData Data object that is created
    
    func createMultipartFormData(imageURL: URL, boundary: String) -> Data {
        
        var formData = Data()
        
        let appIDData = Data("--\(boundary)\r\nContent-Disposition: form-data; name=\"appid\"\r\n\r\n\(appID)\r\n".utf8)
        formData.append(appIDData)
        
        let orginalImageURLData = Data("--\(boundary)\r\nContent-Disposition: form-data; name=\"original\"\r\n\r\n\(uploadURL!.absoluteString)\r\n".utf8)
        formData.append(orginalImageURLData)
        
        let fileData = Data("--\(boundary)\r\nContent-Disposition: form-data; name=\"file\"; filename=\"image.jpg\"\r\nContent-Type: image/jpeg\r\n\r\n".utf8)
        formData.append(fileData)
        
        do {
            ///gets the edited Image of the user
            let imageData =  editedImageView.image?.pngData()
            
            formData.append(imageData!)
            
        }
        let closingData = Data("\r\n--\(boundary)--\r\n".utf8)
        formData.append(closingData)
        
        return formData
        
    }
}
