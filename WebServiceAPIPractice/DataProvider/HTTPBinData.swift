//
//  GetData.swift
//  WebServiceAPIPractice
//
//  Created by peter.shih on 2019/9/16.
//  Copyright © 2019年 Peteranny. All rights reserved.
//

import Foundation

struct HTTPBinData {
    let args: [AnyHashable: Any]
    let data: String?
    let files: [AnyHashable: Any]?
    let form: [AnyHashable: Any]?
    let headers: [AnyHashable: Any]
    let json: String?
    let origin: String
    let url: String
    
    enum ConversionError: Error {
        case root
        case args
        case data
        case files
        case form
        case headers
        case json
        case origin
        case url
    }
    
    init(data: Data) throws {
        let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
        guard let obj = json as? [AnyHashable: Any] else {
            throw ConversionError.root
        }

        guard let args = obj["args"] as? [AnyHashable: Any] else {
            throw ConversionError.args
        }
        self.args = args

        let data = obj["data"]
        if data != nil {
            guard let dataString = data as? String else {
                throw ConversionError.data
            }
            self.data = dataString
        } else {
            self.data = nil
        }

        let files = obj["files"]
        if files != nil {
            guard let filesObj = files as? [AnyHashable: Any] else {
                throw ConversionError.files
            }
            self.files = filesObj
        } else {
            self.files = nil
        }

        let form = obj["form"]
        if form != nil {
            guard let formObj = form as? [AnyHashable: Any] else {
                throw ConversionError.form
            }
            self.form = formObj
        } else {
            self.form = nil
        }

        guard let headers = obj["headers"] as? [AnyHashable: Any] else {
            throw ConversionError.headers
        }
        self.headers = headers

        let jsonValue = obj["json"]
        if jsonValue is NSNull {
            self.json = nil
        } else if jsonValue != nil {
            guard let jsonString = jsonValue as? String else {
                throw ConversionError.json
            }
            self.json = jsonString
        } else {
            self.json = nil
        }

        guard let origin = obj["origin"] as? String else {
            throw ConversionError.origin
        }
        self.origin = origin

        guard let url = obj["url"] as? String else {
            throw ConversionError.url
        }
        self.url = url
    }
}
