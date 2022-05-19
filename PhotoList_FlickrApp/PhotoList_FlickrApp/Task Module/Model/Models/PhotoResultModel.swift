//
//  PhotoResultModel.swift
//  PhotoList_FlickrApp
//
//  Created by Ibram on 19/05/2022.
//  Copyright © 2022 Ibram. All rights reserved.
//

// PhotoResults.swift

import Foundation

// MARK: - PhotoResults
struct PhotoResults: Codable {
    var photos: Photos?
    var stat: String?
}

// MARK: - Photos
struct Photos: Codable {
    var page, pages, perpage, total: Int?
    var photo: [Photo]?
}

// MARK: - Photo
struct Photo: Codable {
    var id, owner, secret, server: String?
    var farm: Int?
    var title: String?
    var ispublic, isfriend, isfamily: Int?
}
