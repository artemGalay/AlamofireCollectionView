//
//  FlickrPhoto.swift
//  AlamofireCollectionView
//
//  Created by Артем Галай on 31.01.23.
//

import Foundation

struct FlickrPhoto {
    let farm: Int
    let server: String
    let photoID: String
    let secret: String

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
}
