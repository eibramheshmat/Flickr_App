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
    @IBOutlet weak var adView: UIView!
    @IBOutlet weak var adImg: UIImageView!
    @IBOutlet weak var title: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setDesign(obj: [mainView,imageCellView,adView,adImg])
        
    }
    
    
    func setDesign(obj: [UIView]) {
        self.selectionStyle = .none
        obj.forEach { (obj) in
            obj.layer.cornerRadius = 20
            obj.layer.borderWidth = 1
        }
    }
    
    func setData(dataObj: Photo) {
        adView.isHidden = true
        title.text = dataObj.title
        let url = URL(string: "https://farm\(dataObj.farm ?? 0).static.flickr.com/\(dataObj.server ?? "")/\(dataObj.id ?? "")_\(dataObj.secret ?? "").jpg")
        imageCellView.kf.setImage(with: url)
    }
    
    func setAd() {
        adView.isHidden = false
    }
    
}
