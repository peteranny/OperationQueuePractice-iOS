//
//  ViewController.swift
//  WebServiceAPIPractice
//
//  Created by peter.shih on 2019/9/16.
//  Copyright © 2019年 Peteranny. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var startButton: UIButton!

    override func viewDidLoad() {
        HTTPBinDataManager.shared.delegate = self
    }

    @IBAction func didTapStartButton(_ sender: UIButton) {
        HTTPBinDataManager.shared.executeOperation()
        progressBar.progress = 0
        startButton.isEnabled = false
    }
}

extension ViewController: HTTPBinDataManagerDelegate {
    func manager(_ manager: HTTPBinDataManager, withProgress progress: Float) {
        progressBar.progress = progress
    }
    
    func manager(_ manager: HTTPBinDataManager, didFailWith error: Error) {
        print(#function, error)
        startButton.isEnabled = true
    }
    
    func manager(_ manager: HTTPBinDataManager, didSucceedWithGetResponse getResponse: Any, postResponse: Any, image: UIImage) {
        print(#function, getResponse, postResponse, image)
        startButton.isEnabled = true
    }
}
