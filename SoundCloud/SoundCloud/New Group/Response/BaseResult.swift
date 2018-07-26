//
//  File.swift
//  SoundCloud
//
//  Created by Can Khac Nguyen on 7/25/18.
//  Copyright © 2018 Do Hung. All rights reserved.
//

import Foundation
import ObjectMapper

enum BaseResult<T: Mappable> {
    case success(T?)
    case failure(error: BaseError?)
}
