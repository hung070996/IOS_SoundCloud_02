//
//  APIManager.swift
//  SoundCloud
//
//  Created by Can Khac Nguyen on 7/25/18.
//  Copyright © 2018 Do Hung. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

final class APIManager {
    static let shared = APIManager()
    private var alamofireManager = Alamofire.SessionManager.default
    
    private init() {}
    
    func cancelRequest() {
        alamofireManager.session.getTasksWithCompletionHandler { (sessionDataTask, uploadData, downloadData) in
            sessionDataTask.forEach {
                $0.cancel()
            }
        }
    }
    
    func request<T: Mappable>(input: BaseRequest, completion: @escaping (_ value: T?, _ error: BaseError?) -> Void) {
        let router = input is GenreRequest ? GeneralAPIRouter.getGenre(request: input) : GeneralAPIRouter.getSearch(request: input)
        alamofireManager.request(router).validate(statusCode: 200..<500)
            .responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    guard let statusCode = response.response?.statusCode else {
                        completion(nil, BaseError.unexpectedError)
                        return
                    }
                    if statusCode == 200 {
                        let object = Mapper<T>().map(JSONObject: value)
                        completion(object, nil)
                    } else {
                        guard let error = Mapper<ErrorResponse>().map(JSONObject: value) else {
                            completion(nil, BaseError.httpError(httpCode: statusCode))
                            return
                        }
                        completion(nil, BaseError.apiFailure(error: error))
                    }
                case .failure(let error):
                    completion(nil, error as? BaseError)
                }
        }
    }
}
