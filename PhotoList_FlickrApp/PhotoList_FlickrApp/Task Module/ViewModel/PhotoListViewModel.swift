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
    var photosCashed: [NSManagedObject] = []
    
    init(service: PhotoListService = PhotoListService()) {
        self.service = service
        super.init()
        if UserDefaults.standard.bool(forKey: "firstLaunch"){
            getAllPhotos()
        }else{
            //show cashing
            fetchFromCoreData()
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
                                self?.saveToCoreData(photo: Photo)
//                                self?.saveToCoreData(url: "https://farm\(Photo.farm ?? 0).static.flickr.com/\(Photo.server ?? "")/\(Photo.id ?? "")_\(Photo.secret ?? "").jpg")
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
    
    func saveToCoreData(photo: Photo) {
        
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
        
        let photoObj = NSManagedObject(entity: entity,
                                    insertInto: managedContext)
        
        // 3
        photoObj.setValue(String(photo.farm ?? 0), forKeyPath: "farm")
        photoObj.setValue(photo.id, forKeyPath: "id")
        photoObj.setValue(photo.secret, forKeyPath: "secret")
        photoObj.setValue(photo.server, forKeyPath: "server")
        photoObj.setValue(photo.title, forKeyPath: "title")
        
        // 4
        do {
            try managedContext.save()
//            photosCashed.append(photoObj)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func fetchFromCoreData() {
        guard let appDelegate =
          UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext =
          appDelegate.persistentContainer.viewContext
        
        //2
        let fetchRequest =
          NSFetchRequest<NSManagedObject>(entityName: "PhotosCash")
        
        //3
        do {
          photosCashed = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        var photosChased : [Photo] = []
        photosCashed.forEach { (obj) in
            let photoObj = Photo(id: (obj.value(forKey: "id") as! String), owner: "", secret: (obj.value(forKey: "secret") as! String), server: (obj.value(forKey: "server") as! String), farm: Int((obj.value(forKey: "farm") as! String)), title: (obj.value(forKey: "title") as! String), ispublic: 0, isfriend: 0, isfamily: 0)
            photosChased.append(photoObj)
        }
        
        photoList.accept(photosChased)
        
    }
    
}
