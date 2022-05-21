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
import CoreData

class PhotoListViewModel: BaseViewModel {
    
    var service: PhotoListService
    var photoList = BehaviorRelay<[Photo]>(value: [])
    var photosURL: [NSManagedObject] = []
    
    init(service: PhotoListService = PhotoListService()) {
        self.service = service
        super.init()
        if UserDefaults.standard.bool(forKey: "firstLaunch"){
            getAllPhotos()
        }else{
            //show cashing
            print("chashing")
        }
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
                        if UserDefaults.standard.bool(forKey: "firstLaunch") {
                            self?.photoList.accept(res.photo ?? [])
                            self?.photoList.value.forEach({ (Photo) in
                                self?.saveToCoreData(url: "https://farm\(Photo.farm ?? 0).static.flickr.com/\(Photo.server ?? "")/\(Photo.id ?? "")_\(Photo.secret ?? "").jpg")
                            })
                        }else{
                            let chachingPhoto = self?.photoList.value ?? []
                            let newPhoto = res.photo ?? []
                            self?.photoList.accept(chachingPhoto+newPhoto)
                        }
                    }else{
                        print("empty result")
                    }
                }
            }, onError: { (errMoya) in
                self.loading.accept(false)
                print(errMoya.localizedDescription)
        }).disposed(by: disposeBag)
    }
    
    func saveToCoreData(url: String) {
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        // 1
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        // 2
        let entity =
            NSEntityDescription.entity(forEntityName: "PhotosCash",
                                       in: managedContext)!
        
        let photo = NSManagedObject(entity: entity,
                                    insertInto: managedContext)
        
        // 3
        photo.setValue(url, forKeyPath: "url")
        
        // 4
        do {
            try managedContext.save()
            photosURL.append(photo)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
}
