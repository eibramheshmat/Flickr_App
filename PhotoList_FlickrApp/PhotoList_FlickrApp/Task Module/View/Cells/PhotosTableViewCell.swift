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
        mainView.layer.borderWidth = 1
        imageCellView.layer.cornerRadius = 20
        imageCellView.layer.borderWidth = 1
    }
    
    func setData(dataObj: Photo) {
        title.text = dataObj.title
        let url = URL(string: "https://farm\(dataObj.farm ?? 0).static.flickr.com/\(dataObj.server ?? "")/\(dataObj.id ?? "")_\(dataObj.secret ?? "").jpg")
        imageCellView.kf.setImage(with: url)
    }
    
}
