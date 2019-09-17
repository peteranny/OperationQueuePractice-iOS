//
//  HTTPBinDataManagerOperation.swift
//  WebServiceAPIPractice
//
//  Created by peter.shih on 2019/9/17.
//  Copyright © 2019年 Peteranny. All rights reserved.
//

import Foundation
import UIKit

protocol HTTPBinDataOperationDelegate: class {
    func operation(_: HTTPBinDataOperation, withProgress: Float)
    func operation(_: HTTPBinDataOperation, didFailWith: Error)
    func operation(_: HTTPBinDataOperation, didSucceedWithGetResponse: Any, postResponse: Any, image: UIImage)
}

class HTTPBinDataOperation: Operation {
    weak var delegate: HTTPBinDataOperationDelegate?
    
    var isRunLoopRunning = false
    var port: Port!

    var getResponse: Any!
    var postResponse: Any!
    var image: UIImage!
    var error: Error?
    
    init(with delegate: HTTPBinDataOperationDelegate) {
        self.delegate = delegate
    }

    override func main() {
        WebServiceAPI.shared.fetchGetResponse { data, error in
            if let error = error {
                self.error = error
            } else {
                self.getResponse = data
            }
            self.quitRunLoop()
        }
        doRunLoop()
        OperationQueue.main.addOperation {
            self.delegate?.operation(self, withProgress: 1.0/3)
        }
        guard !isCancelled, error == nil else {
            OperationQueue.main.addOperation {
                self.delegate?.operation(self, didFailWith: self.error!)
            }
            return
        }
        WebServiceAPI.shared.postCustomerName("Peter Shih") { data, error in
            if let error = error {
                self.error = error
            } else {
                self.postResponse = data
            }
            self.quitRunLoop()
        }
        doRunLoop()
        OperationQueue.main.addOperation {
            self.delegate?.operation(self, withProgress: 2.0/3)
        }
        guard !isCancelled, error == nil else {
            OperationQueue.main.addOperation {
                self.delegate?.operation(self, didFailWith: self.error!)
            }
            return
        }
        WebServiceAPI.shared.fetchImage { image, error in
            if let error = error {
                self.error = error
            } else {
                self.image = image
            }
            self.quitRunLoop()
        }
        doRunLoop()
        OperationQueue.main.addOperation {
            self.delegate?.operation(self, withProgress: 1.0)
        }
        guard !isCancelled, error == nil else {
            OperationQueue.main.addOperation {
                self.delegate?.operation(self, didFailWith: self.error!)
            }
            return
        }
        OperationQueue.main.addOperation {
            self.delegate?.operation(self, didSucceedWithGetResponse: self.getResponse, postResponse: self.postResponse, image: self.image)
        }
    }
    
    override func cancel() {
        super.cancel()
        WebServiceAPI.shared.currentTask = nil
        quitRunLoop()
    }
    
    func doRunLoop() {
        isRunLoopRunning = true
        port = Port()
        RunLoop.current.add(port, forMode: .common)
        while isRunLoopRunning, !isCancelled {
            RunLoop.current.run(until: Date(timeIntervalSinceNow: 0.5))
        }
        port = nil
    }
    
    func quitRunLoop() {
        port.invalidate()
        isRunLoopRunning = false
    }
}
