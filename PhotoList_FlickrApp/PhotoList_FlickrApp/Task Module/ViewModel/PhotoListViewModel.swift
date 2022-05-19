//
//  PhotoListViewModel.swift
//  PhotoList_FlickrApp
//
//  Created by Ibram on 19/05/2022.
//  Copyright © 2022 Ibram. All rights reserved.
//

import Foundation
import RxSwift

class PhotoListViewModel: BaseViewModel {
    
    var service: PhotoListService
    var photoList: Photos?
    
    init(service: PhotoListService = PhotoListService()) {
        self.service = service
        super.init()
        getAllPhotos()
    }
    
    func getAllPhotos() {
        loading.accept(true)
        service.getPhotoList().subscribe(
            onSuccess: {[weak self] (err,result) in
                self?.loading.accept(false)
                if let errMsg = err{
                    print(errMsg)
                }else{
                    if let res = result{
                        self?.photoList = res
                    }else{
                        print("empty result")
                    }
                }
        }, onError: { (errMoya) in
            self.loading.accept(false)
            print(errMoya.localizedDescription)
        }).disposed(by: disposeBag)
    }
}