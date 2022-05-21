//
//  PhotoListViewModel.swift
//  PhotoList_FlickrApp
//
//  Created by Ibram on 19/05/2022.
//  Copyright © 2022 Ibram. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class PhotoListViewModel: BaseViewModel {
    
    var service: PhotoListService
    var photoList = BehaviorRelay<[Photo]>(value: [])
    
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
                        let chachingPhoto = self?.photoList.value ?? []
                        let newPhoto = res.photo ?? []
                        self?.photoList.accept(chachingPhoto+newPhoto)
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
