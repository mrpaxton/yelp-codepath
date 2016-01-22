//
//  BusinessCell.swift
//  Yelp
//
//  Created by Sarn Wattanasri on 1/19/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessCell: UITableViewCell {

    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var ratingImageView: UIImageView!
    @IBOutlet weak var reviewCountLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!

    @IBOutlet weak var categoriesLabel: UILabel!
    
    var business: Business! {
        didSet {
            nameLabel.text = business.name
            if let imageURL = business.imageURL {
                thumbImageView.setImageWithURL(imageURL )
            }
            //thumbImageView.setImageWithURL((business.imageURL ?? nil)!)
            categoriesLabel.text = business.categories
            addressLabel.text = business.address
            reviewCountLabel.text = "\(business.reviewCount!) Reviews"
            ratingImageView.setImageWithURL(business.ratingImageURL!)
            distanceLabel.text = business.distance
            
            
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        thumbImageView.layer.cornerRadius = 3
        thumbImageView.clipsToBounds = true
        
        
        //sync the label width with the Apple's preferredMaxLayoutWidth - really needed?
        //nameLabel.preferredMaxLayoutWidth = nameLabel.frame.size.width
    }
    
    //called when rotation happens, this method gets called. so override
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //sync again, the label width with the Apple's preferredMaxLayoutWidth - really needed?
        //nameLabel.preferredMaxLayoutWidth = nameLabel.frame.size.width
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
