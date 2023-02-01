//
//  ViewController.swift
//  AlamofireCollectionView
//
//  Created by Артем Галай on 29.01.23.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    var flickrPhotoArray = [FlickrPhoto]()

    let key = "c21c0d08dc14b7847a96ce222261e7e7"
    let perPage = "25"
    let text = "Мерлин Монро"

    let countItem: CGFloat = 3
    let sectionInsert = UIEdgeInsets(top: 50, left: 20, bottom: 50, right: 20)



    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(FlickrCollectionViewCell.self, forCellWithReuseIdentifier: FlickrCollectionViewCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupHierarchy()
        setupLayout()

        let param = ["api_key": key,
                     "format": "json",
                     "method": "flickr.photos.search",
                     "per_page": perPage,
                     "text": text,
                     "nojsoncallback": "1"]

        AF.request("https://api.flickr.com/services/rest/", parameters: param).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                guard let photos = FlickrPhoto.getArray(from: value) else { return }
                self.flickrPhotoArray = photos
                self.collectionView.reloadData()
                
            case.failure(let error):
                print(error)
            }
        }
    }

    private func setupHierarchy() {
        view.addSubview(collectionView)
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        flickrPhotoArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FlickrCollectionViewCell.identifier, for: indexPath) as? FlickrCollectionViewCell else { return UICollectionViewCell() }
        cell.backgroundColor = .white
        cell.image.image = flickrPhotoArray[indexPath.row].thumbnail
        return cell
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let space = sectionInsert.left * (countItem + 1)
        let itemsWidth = view.frame.width - space
        let widthParItem = itemsWidth / countItem
        return CGSize(width: widthParItem, height: widthParItem)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        sectionInsert.left
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        sectionInsert
    }

}
