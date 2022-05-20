//
//  PhotosTableViewCell.swift
//  PhotoList_FlickrApp
//
//  Created by Ibram on 20/05/2022.
//  Copyright © 2022 Ibram. All rights reserved.
//

import UIKit

class PhotosTableViewCell: UITableViewCell {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var imageCellView: UIImageView!
    @IBOutlet weak var title: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setDesign()
        
    }
    
    
    func setDesign() {
        self.selectionStyle = .none
        mainView.layer.cornerRadius = 20
    }
    
}
