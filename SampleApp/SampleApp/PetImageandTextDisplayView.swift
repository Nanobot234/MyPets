//
//  Imagea&DataUiDisplay.swift
//  SampleApp
//
//  Created by Nana Bonsu on 6/22/23.
//

import Foundation
import UIKit



/// Creates a custom view that is originally designed in the `ImagesUIDisplay.xib`file. The custom view is actually created as a subview of this view.
class PetImageandTextDisplayView: UIView {
    
    ///  holds the pet image to be displayed
    @IBOutlet weak var displayImageView: UIImageView!
    
    /// the description bio of the pet
    @IBOutlet weak var descriptionLabel: UILabel!
    
    ///the UiView that holds the imageView and related text data
    @IBOutlet var contentView: UIView!
    
    /// displays the date that the image was created
    @IBOutlet weak var creationDate: UILabel!
    
    /// displays the image title which is seen as the name
    @IBOutlet weak var titleLabel: UILabel!
    
    
    var loadedImage:UIImage? {
        get {return displayImageView.image}
        set {
            displayImageView.image = newValue
        }
    }
    
    var descriptionLabelText: String? {
        get {return descriptionLabel.text}
        
        set {descriptionLabel.text = newValue}
    }
    
    var createdDateText:String? {
        get {return descriptionLabel.text}
        set {creationDate.text = newValue}
    }

    var titleLabelText: String? {
        get {return titleLabel.text}
        set {titleLabel.text = newValue}
    }

    
    override init(frame: CGRect) {
        super.init(frame: frame)
       //self.subViews
        self.setCustomView()
   }
   
    required init?(coder: NSCoder) {
        
        super.init(coder: coder)
        self.setCustomView()
    }
    
    
    /// Instantiates the provided nib file and adds the contentView as a subview of this class. The contentView actually holds the imageView and related data that is defined in the nib file
    private func setCustomView() {
        let nib = UINib(nibName: "ImagesUIDisplay", bundle: nil)
        nib.instantiate(withOwner: self)
        contentView.frame = CGRect(x: 10, y: 10, width: self.frame.width - 10, height: self.frame.height - 10)
        
        contentView.clipsToBounds = true
        
        displayImageView.isUserInteractionEnabled = true
        addSubview(contentView)
        print(contentView.frame)
        print(self.frame)
    }
}
