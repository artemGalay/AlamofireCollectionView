//
//  ViewController.swift
//  AlamofireCollectionView
//
//  Created by Артем Галай on 29.01.23.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    let key = "c21c0d08dc14b7847a96ce222261e7e7"
    let perPage = "2"
    let text = "Мерлин Монро"

    override func viewDidLoad() {
        super.viewDidLoad()

        let param = ["api_key": key,
                     "format": "json",
                     "method": "flickr.photos.search",
                     "per_page": perPage,
                     "text": text,
                     "nojsoncallback": "1"]

        AF.request("https://api.flickr.com/services/rest/", parameters: param).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                guard
                    let jsonContainer = value as? [String: Any],
                    let jsonPhoto = jsonContainer["photos"] as? [String: Any],
                    let jsonArray = jsonPhoto["photo"] as? [[String: Any]]
                else { return }
            case.failure(let error):
                print(error)
            }
        }
    }
}

