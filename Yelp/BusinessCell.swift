//
//  BusinessCell.swift
//  Yelp
//
//  Created by Raina Wang on 9/21/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessCell: UITableViewCell {

    @IBOutlet weak var businessPoster: UIImageView!
    @IBOutlet weak var reviewStars: UIImageView!
    @IBOutlet weak var businessName: UILabel!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var numberOfReviews: UILabel!
    @IBOutlet weak var categories: UILabel!
    @IBOutlet weak var address: UILabel!

    var business: Business! {
        didSet {
            businessName.text = business.name
            businessPoster.setImageWith(business.imageURL!)
            reviewStars.setImageWith(business.ratingImageURL!)
            distance.text = business.distance
            numberOfReviews.text = "\(business.reviewCount!) Reviews"
            categories.text = business.categories
            address.text = business.address
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        businessPoster.layer.cornerRadius = 5
        businessPoster.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
