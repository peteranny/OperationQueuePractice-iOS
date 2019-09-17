//
//  HTTPBinDataManager.swift
//  WebServiceAPIPractice
//
//  Created by peter.shih on 2019/9/17.
//  Copyright © 2019年 Peteranny. All rights reserved.
//

import Foundation
import UIKit

protocol HTTPBinDataManagerDelegate: class {
    func manager(_: HTTPBinDataManager, withProgress: Float)
    func manager(_: HTTPBinDataManager, didFailWith: Error)
    func manager(_: HTTPBinDataManager, didSucceedWithGetResponse: Any, postResponse: Any, image: UIImage)
}

class HTTPBinDataManager {
    static let shared = HTTPBinDataManager()
    
    weak var delegate: HTTPBinDataManagerDelegate?
    
    let operationQueue = OperationQueue()
    
    func executeOperation() {
        operationQueue.cancelAllOperations()
        operationQueue.addOperation(HTTPBinDataOperation(with: self))
    }
}

extension HTTPBinDataManager: HTTPBinDataOperationDelegate {
    func operation(_ operation: HTTPBinDataOperation, withProgress progress: Float) {
        delegate?.manager(self, withProgress: progress)
    }
    
    func operation(_ operation: HTTPBinDataOperation, didFailWith error: Error) {
        delegate?.manager(self, didFailWith: error)
    }
    
    func operation(_ operation: HTTPBinDataOperation, didSucceedWithGetResponse getResponse: Any, postResponse: Any, image: UIImage) {
        delegate?.manager(self, didSucceedWithGetResponse: getResponse, postResponse: postResponse, image: image)
    }
}
