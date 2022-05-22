//
//  AllPhotosListViewController.swift
//  PhotoList_FlickrApp
//
//  Created by Ibram on 20/05/2022.
//  Copyright © 2022 Ibram. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import Kingfisher

class AllPhotosListViewController: BaseViewController, UITableViewDelegate {
    
    @IBOutlet weak var photosTableView: UITableView!
    @IBOutlet weak var fullImageView: UIView!
    @IBOutlet weak var fullScreenImage: UIImageView!
    
    var viewModel = PhotoListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerTableCell()
        bindTableViewModel()
        
    }
    
    func registerTableCell() {
        photosTableView.register(UINib(nibName: "PhotosTableViewCell", bundle: nil), forCellReuseIdentifier: "PhotosTableViewCell")
        photosTableView.register(UINib(nibName: "AdBannerTableViewCell", bundle: nil), forCellReuseIdentifier: "AdBannerTableViewCell")
    }
    
    func bindTableViewModel() {
        photosTableView.rx.setDelegate(self).disposed(by: viewModel.disposeBag)
        
        viewModel.photoList.asObservable().bind(to: photosTableView.rx.items){
            (data,index,item) -> UITableViewCell in
            if (index % 5 == 0) {
                let cell = self.photosTableView.dequeueReusableCell(withIdentifier: "AdBannerTableViewCell", for: IndexPath.init(row: index, section: 0))
                return cell
            } else {
                let cell = self.photosTableView.dequeueReusableCell(withIdentifier: "PhotosTableViewCell", for: IndexPath.init(row: index, section: 0)) as? PhotosTableViewCell
                cell?.setData(dataObj: item)
                return cell ?? UITableViewCell()
            }
        }.disposed(by: viewModel.disposeBag)
        
        photosTableView.rowHeight = 220
        
        Observable
            .zip(photosTableView.rx.itemSelected, photosTableView.rx.modelSelected(Photo.self))
            .bind { [unowned self] indexPath, model in
                if (indexPath.row % 5 == 0) {
                    
                }else{
                    let url = URL(string: "https://farm\(model.farm ?? 0).static.flickr.com/\(model.server ?? "")/\(model.id ?? "")_\(model.secret ?? "").jpg")
                    self.fullScreenImage.kf.setImage(with: url)
                    self.fullImageView.isHidden = false
                }
        }
        .disposed(by: viewModel.disposeBag)
        
        photosTableView.rx.didScroll.subscribe { [weak self] _ in
            guard let self = self else { return }
            let offSetY = self.photosTableView.contentOffset.y
            let contentHeight = self.photosTableView.contentSize.height
            
            if offSetY > (contentHeight - self.photosTableView.frame.size.height - 100) {
                let currentPage = Int(PhotoListAPI.currentPage) ?? 0
                let currentShouldBe = currentPage + 1
                PhotoListAPI.currentPage = "\(currentShouldBe)"
                self.viewModel.getAllPhotos()
            }
        }
        .disposed(by: viewModel.disposeBag)
    }
    
    @IBAction func closeFullScreenImgAction(_ sender: UIButton) {
        fullImageView.isHidden = true
    }
    
    
}
