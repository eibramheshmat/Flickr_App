//
//  AdBannerTableViewCell.swift
//  PhotoList_FlickrApp
//
//  Created by Ibram on 21/05/2022.
//  Copyright © 2022 Ibram. All rights reserved.
//

import UIKit

class AdBannerTableViewCell: UITableViewCell {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var adImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
    }
    
}
