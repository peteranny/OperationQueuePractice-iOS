//
//  GetData.swift
//  WebServiceAPIPractice
//
//  Created by peter.shih on 2019/9/16.
//  Copyright © 2019年 Peteranny. All rights reserved.
//

struct HTTPBinData: Decodable {
    let args: [String: String]
    let data: String?
    let files: [String: String]?
    let form: [String: String]?
    let headers: [String: String]
    let json: String?
    let origin: String
    let url: String
}
