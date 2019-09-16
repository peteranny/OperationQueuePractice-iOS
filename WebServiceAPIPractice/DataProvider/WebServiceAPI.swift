//
//  WebServiceAPI.swift
//  WebServiceAPIPractice
//
//  Created by peter.shih on 2019/9/16.
//  Copyright © 2019年 Peteranny. All rights reserved.
//

import UIKit

class WebServiceAPI {
    static let shared = WebServiceAPI()

    private init() {}

    func fetchGetResponse(_ callback: @escaping (HTTPBinData?, Error?) -> ()) {
        let url = URL(string: "http://httpbin.org/get")!
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                callback(nil, error!)
                return
            }
            do {
                let binData = try HTTPBinData(data: data!)
                callback(binData, nil)
            } catch {
                callback(nil, error)
            }
        }.resume()
    }

    func postCustomerName(_ name: String, _ callback: @escaping (HTTPBinData?, Error?) -> ()) {
        let url = URL(string: "http://httpbin.org/post")!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = "custname=\(name)".data(using: .utf8)
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            guard error == nil else {
                callback(nil, error!)
                return
            }
            do {
                let binData = try HTTPBinData(data: data!)
                callback(binData, nil)
            } catch {
                callback(nil, error)
            }
        }.resume()
    }

    func fetchImage(_ callback: @escaping (UIImage?, Error?) -> ()) {
        let url = URL(string: "http://httpbin.org/image/png")!
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                callback(nil, error!)
                return
            }
            let image = UIImage(data: data!)
            callback(image, nil)
        }.resume()
    }
}
