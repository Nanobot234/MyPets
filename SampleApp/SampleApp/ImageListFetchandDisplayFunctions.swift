//
//  ImageListFetchandDisplayFunctions.swift
//  SampleApp
//
//  Created by Nana Bonsu on 6/26/23.
//

import Foundation
import UIKit
import Nuke
import NukeExtensions

extension ImageListViewController {
    
    
    /// Fetches and parses the JSON data recieved from a URLSessionTask
    ///
    ///If the JSON data is recieved by  creaing a URLSession task. The specific code for the URLSession is found in the Utilities file. After the JSON is successfully recieved, the it is parsed using the parseJSON() method
    ///The function also starts an asychronous code block that runs a function that displays images and associated data to the user.
    func fetchData() {
        //guard statement for url
        guard let url = URL(string: data_url) else {return}
        
        loadingIndicator.startAnimating()
        view.isUserInteractionEnabled = false
        
        
            _ = Utilities.shared.fetchData(from: url) { result in
                switch result {
                case .success(let data):
                    
                    do {
                        let json = try JSONSerialization.jsonObject(with: data,options: []) as? [[String: Any]]
                        
                        if let jsonArray = json {
                            print("JSON was correctly serialized")
                            self.parseJSON(jsonArray)
                            
                            DispatchQueue.main.async {
                                self.displayImagesandInfo()
                            }
                        }
                    }  catch {
                        
                        print("Error parsing JSON: \(error.localizedDescription)")
                    }
                    
                case .failure(let error):
                    print("Errror: \(error.localizedDescription)")
                    return
                }
                
            }
        
    }
        
   
    
    /// Parses the JSON that has been recieved and creates and ImageData object.
    /// - Parameter jsonArray: the JSON array to be parsed
    func parseJSON(_ jsonArray:[[String:Any]]) {
        
        for item in jsonArray {
            if let title = item["title"] as? String,
               let description = item["description"] as? String,
               let imageURL = item["url"] as? String,
               let created = item["created"] as? String {
                let object = ImageData(title: title, description: description, imageUrl: imageURL, createdDate: created)
                
                imageDataList.append(object)
                //mabe change name here?
            }
            
        }
    }
    
    ///Displays the images and associated text data in a list format
    ///
    ///The function fetches each image based on the given imageUrl and then creates the custom view that details how the image and associated text data is displayed.
    ///The creation of the custom view is actually done in the `setCustomViewPropertiesandElements` method.
    ///Then the custom view that is created is then added to the stackView that this controller manages.
    /// Since a customView is created for each pet, the stackView displays a list of custom views in vertical scrolling order.
    ///The loading spinning circle is dismissed on the main thread after the custom views have been added
    func displayImagesandInfo() {
    
        for (index,imageData) in imageDataList.enumerated() {
            print(imageData.description)
            print(imageData.imageUrl)
           
            guard let url = URL(string: imageData.imageUrl) else {return}
                
            let createdDisplayData = self.setCustomViewPropertiesandElements(imageURL: url, imageData: imageData, index: index)
            self.dataStackView.addArrangedSubview(createdDisplayData)
            self.customViewList.append(createdDisplayData)
                
            }
        
        DispatchQueue.main.async {
            self.loadingIndicator.stopAnimating()
            self.view.isUserInteractionEnabled = true
        }
        
        }
    
    /// instantiates the Image Editing View controller when a user clicks on an image. The URL of the tapped image and the image is passed into the new controller
    ///
    /// - Parameter sender: this gesture recognizer holds the image that the user has tapped on
    @objc func petImageTapped(_ sender: UITapGestureRecognizer) {
        
        let imageTapped = sender.view as! UIImageView
        
        let imageURL = imageDataList[imageTapped.tag].imageUrl
        print("The image URL" + imageURL)
        
        let editingViewController = storyboard?.instantiateViewController(withIdentifier: "editingVC") as! ImageEditingViewController
        
        editingViewController.imageRecieved = imageTapped.image!
        
        editingViewController.imageURLRecieved = imageURL
        
        navigationController?.pushViewController(editingViewController, animated: true)
        
    }
    
    /// Extracts the  month, day and year from a string
    /// - Parameter dateString: the input string that contains a date
    /// - Returns: a string with only the date formatted
    func formattingDate(dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E MMM d HH:mm:ss zzz yyyy"
        
        if let date = dateFormatter.date(from: dateString) {
            let calendar = Calendar.current
            let components = calendar.dateComponents([.year, .month, .day], from: date)
            
            if let extractedDate = calendar.date(from: components) {
                let extractedDateString = DateFormatter.localizedString(from: extractedDate, dateStyle: .medium, timeStyle: .none)
                return extractedDateString
            }
                    
        }
        return ""
    }
    
    
    /// initializes and creates a custom view that holds a pet image and relevant text data. Also sets various rendering properties for the custom view.

    /// - Parameters:
    ///   - image: the image of a pet. The image is intially fetched from the server by means of the imageURL
    ///   - imageData: The imagData object that holds information about the pet
    ///   - index: the index number of the current pet to be displayed. This index is later used to retrive the relevant imageURL
    /// - Returns: the customView that is created
    func setCustomViewPropertiesandElements(imageURL:URL, imageData: ImageData, index:Int) -> PetImageandTextDisplayView {
        
        //use Nuke.
        
        let displayData =  PetImageandTextDisplayView(frame: CGRectMake(10, 10, self.view.frame.width - 10, 280))
        
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(self.petImageTapped))
        
        
        NukeExtensions.loadImage(with: imageURL, into: displayData.displayImageView) { result in
            displayData.displayImageView.layer.cornerRadius = 25.0
            displayData.displayImageView.layer.masksToBounds = true
            displayData.displayImageView.contentMode = .scaleAspectFill 

        }
        
        displayData.descriptionLabelText = "Paw Bio: " + imageData.description
        displayData.createdDateText = "Made on: " + self.formattingDate(dateString: imageData.createdDate)
       
        displayData.titleLabelText = "Name: " + imageData.title
        
        displayData.displayImageView.addGestureRecognizer(singleTap)
        
        displayData.displayImageView.tag = index
       
        displayData.layer.shadowColor = UIColor.black.cgColor
        displayData.layer.shadowOffset = CGSize(width: 0, height: 2)
        displayData.layer.shadowOpacity = 0.5
        displayData.layer.shadowRadius = 4.0
        displayData.layer.cornerRadius = 50
        
        displayData.heightAnchor.constraint(equalToConstant: 290).isActive = true
        
        
        return displayData
        
    }

}
