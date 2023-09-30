//
//  ViewController.swift
//  SampleApp
//
//  Created by Nana Bonsu on 6/21/23.
//


import UIKit

///Defines swift  elements to correctly parse the fetched JSON data.
struct ImageData {
    let title:String
    let description:String
    let imageUrl:String
    let createdDate:String
    //
    
}

///Manages the primary UI screen of the app.
///
///This screen displays the images of pets and the associated text data in a list format. The fucntion that fetch and display the data are in an extension that is located in the file ImageListFetchandDisplayFunctions
///
class ImageListViewController: UIViewController {
    
    /// outlet connection to the stackView that displays the custom Views in a list
    @IBOutlet weak var dataStackView: UIStackView!
    
    ///The scrollView that the user can interact with
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var searchFeild: UISearchBar!
    
    ///Displaying My Pets title
    @IBOutlet weak var navItem: UINavigationItem!
    
    let data_url = "https://eulerity-hackathon.appspot.com/pets"
    let loadingIndicator = UIActivityIndicatorView(style: .large)
    let userStoryBoard = UIStoryboard(name: "Main", bundle: nil)
    
    var imageDataList:[ImageData] = []
    var imageAdded = UIImage()
    var imageURLKey: UInt8 = 0
    var customViewList:[PetImageandTextDisplayView] = []
    

    ///Sets the searchField delegate and shows the spinning acitity indicator when the view loads
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchFeild.delegate = self
        
        navItem.largeTitleDisplayMode = .always
        
        loadingIndicator.center = view.center
        
        loadingIndicator.hidesWhenStopped = true
        view.addSubview(loadingIndicator)
            
        fetchData()
        
        hideKeyboard() //hides the keyboard when user presses on view
    }
    
    func hideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
         target: self,
         action: #selector(dismissMyKeyboard))
         //Add this tap gesture recognizer to the parent view
         view.addGestureRecognizer(tap)
    }
    
    @objc func dismissMyKeyboard() {
        view.endEditing(true)
    }
}

extension ImageListViewController: UISearchBarDelegate {
    
    /// The implementation of the textDidChange method in the UISearchBarDelegate for this app
    ///
    /// Filters the displayed images based on the searchText entered. If an image description contains the searchText, then that image and assocaited data are displayed, while other images are hidden from the user.
    /// - Parameters:
    ///   - searchBar: the searchBar UI element that is implemented by this view controller
    ///   - searchText: the text that the user types in the search bar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        let filteredViews = customViewList.filter { customView in

            if(searchText.isEmpty) {
                return true
            } else {
                return
                 (customView.descriptionLabelText!.lowercased().contains(searchText.lowercased()) || customView.titleLabelText!.lowercased().contains(searchText.lowercased()))
                //maybe check just for white spaced characters
            }
            
        }
        for view in dataStackView.arrangedSubviews {
            view.removeFromSuperview()
        }
        
        for view in filteredViews {
            dataStackView.addArrangedSubview(view)
        }
    }
}




