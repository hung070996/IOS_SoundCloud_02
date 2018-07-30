//
//  GeneralAPIRouter.swift
//  SoundCloud
//
//  Created by Can Khac Nguyen on 7/25/18.
//  Copyright © 2018 Do Hung. All rights reserved.
//

import Foundation
import Alamofire

enum GeneralAPIRouter: BaseAPIRouter {
    
    case getGenre(request: BaseRequest)
    case getSearch(request: BaseRequest)
    
    var headers: HTTPHeaders {
        switch self {
        default:
            return [:]
        }
    }
    
    var method: HTTPMethod {
        switch self {
        default:
            return .get
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case let .getGenre(request):
            return request.getParameter()
        case let .getSearch(request):
            return request.getParameter()
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        switch self {
        default:
            return URLEncoding.default
        }
    }
    
    var path: String {
        switch self {
        case .getGenre(_):
            return BaseUrl.general
        case .getSearch(_):
            return BaseUrl.search
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try path.asURL()
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.allHTTPHeaderFields = headers
        return try parameterEncoding.encode(urlRequest, with: parameters)
    }
}
