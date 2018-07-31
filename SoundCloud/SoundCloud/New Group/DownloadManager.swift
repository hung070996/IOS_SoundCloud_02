//
//  DownloadManager.swift
//  SoundCloud
//
//  Created by Do Hung on 7/30/18.
//  Copyright © 2018 Do Hung. All rights reserved.
//

import UIKit
import Alamofire

class DownloadManager: NSObject {
    private struct Constant {
        static let mp3 = ".mp3"
        static let clientID = "?client_id="
        static let statusOK = 200
    }
    
    static func checkIsDownloading(completion: @escaping (_ isDownloading: Bool) -> Void) {
        Alamofire.SessionManager.default.session.getTasksWithCompletionHandler { (sessionDataTask, uploadData, downloadData) in
            let check = downloadData.count > 0 ? true : false
            completion(check)
        }
    }
    
    static func downloadTrack(track: Track,
                              progressDownload: @escaping (_ progress: Progress) -> Void,
                              completion: @escaping (_ downloadSuccess: Bool, _ error: BaseError?) -> Void) {
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            documentsURL.appendPathComponent(String(track.id) + Constant.mp3)
            return (documentsURL, [.removePreviousFile])
        }
        let urlDownload = BaseUrl.baseUrl(track: track) + Constant.clientID + APIKey.clientID
        Alamofire.download(
            urlDownload,
            method: .get,
            parameters: nil,
            encoding: JSONEncoding.default,
            headers: nil,
            to: destination).downloadProgress(closure: { (progress) in
                progressDownload(progress)
            }).response(completionHandler: { (defaultDownloadResponse) in
                defaultDownloadResponse.response?.statusCode == Constant.statusOK ? completion(true, nil) : completion(false, defaultDownloadResponse.error as? BaseError)
            })
    }
}
