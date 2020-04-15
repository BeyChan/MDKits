//
//  MDNetworkingConfig.swift
//  MDFooBox
//
//  Created by  MarvinChan on 2019/10/18.
//  Copyright © 2019  MarvinChan. All rights reserved.
//

import Foundation
import Alamofire

public typealias MDRequestHeaders = [String: String]

public enum MDRequestEncoding{
    case json, propertyList, url
}
public enum MDRequestMethod{
    case get, post, delete, put
}
extension MDRequestMethod{
    func toAlamofireMethod()->HTTPMethod{
        switch self {
        case .get:
            return .get
        case .post:
            return .post
        case .delete:
            return .delete
        case .put:
            return .put
        }
    }
}
extension MDRequestEncoding{
    func toAlamofireEncoding()->ParameterEncoding{
        switch self {
        case .json:
            return JSONEncoding()
        case .propertyList:
            return PropertyListEncoding()
        case .url:
            return URLEncoding()
        }
    }
}
