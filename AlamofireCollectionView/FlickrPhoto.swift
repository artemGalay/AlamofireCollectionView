//
//  FlickrPhoto.swift
//  AlamofireCollectionView
//
//  Created by Артем Галай on 31.01.23.
//

import UIKit

struct FlickrPhoto {
    let farm: Int
    let server: String
    let photoID: String
    let secret: String
    var thumbnail: UIImage?

    init?(json: [String: Any]) {
        guard let farm = json["farm"] as? Int,
              let server = json["server"] as? String,
              let photoID = json["id"] as? String,
              let secret = json["secret"] as? String
        else { return nil }
        self.farm = farm
        self.server = server
        self.photoID = photoID
        self.secret = secret
        
            guard let url = flickrImageURL(),
                  let thumbnailData = try? Data(contentsOf: url),
                  let thumbnailImage = UIImage(data: thumbnailData)
            else { return }

            self.thumbnail = thumbnailImage
        }

    static func getArray(from value: Any) -> [FlickrPhoto]? {
        guard
            let jsonContainer = value as? [String: Any],
            let jsonPhoto = jsonContainer["photos"] as? [String: Any],
            let jsonArray = jsonPhoto["photo"] as? [[String: Any]]
        else { return nil }

        var flickrPhotoArray = [FlickrPhoto]()

        for jsonObject in jsonArray {

            guard let photo = FlickrPhoto(json: jsonObject) else { return nil }
            flickrPhotoArray.append(photo)
        }
        return flickrPhotoArray
    }

    func flickrImageURL(_ size: String = "m") -> URL? {
        return URL(string: "https://farm\(farm).staticfrickr.com/\(server)/\(photoID)_\(secret)_\(size).jpg")
    }
}
