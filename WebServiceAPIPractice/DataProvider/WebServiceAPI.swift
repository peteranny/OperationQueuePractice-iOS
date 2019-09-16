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
    
    var currentTask: URLSessionDataTask? = nil {
        willSet {
            currentTask?.cancel()
        }
        didSet {
            currentTask?.resume()
        }
    }

    private init() {}
    
    func fetchGetResponse(_ callback: @escaping (HTTPBinData?, Error?) -> ()) {
        let url = URL(string: "http://httpbin.org/get")!
        currentTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                callback(nil, error!)
                return
            }
            do {
                let decoder = JSONDecoder()
                let binData = try decoder.decode(HTTPBinData.self, from: data!)
                callback(binData, nil)
            } catch {
                callback(nil, error)
            }
        }
    }

    func postCustomerName(_ name: String, _ callback: @escaping (HTTPBinData?, Error?) -> ()) {
        let url = URL(string: "http://httpbin.org/post")!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = "custname=\(name)".data(using: .utf8)
        currentTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            guard error == nil else {
                callback(nil, error!)
                return
            }
            do {
                let decoder = JSONDecoder()
                let binData = try decoder.decode(HTTPBinData.self, from: data!)
                callback(binData, nil)
            } catch {
                callback(nil, error)
            }
        }
    }

    func fetchImage(_ callback: @escaping (UIImage?, Error?) -> ()) {
        let url = URL(string: "http://httpbin.org/image/png")!
        currentTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                callback(nil, error!)
                return
            }
            let image = UIImage(data: data!)
            callback(image, nil)
        }
    }
}
