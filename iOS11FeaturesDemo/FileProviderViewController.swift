//
//  FileProviderViewController.swift
//  iOS11FeaturesDemo
//
//  Created by satheeshwaran on 6/6/17.
//  Copyright © 2017 Satheeshwaran. All rights reserved.
//

import UIKit

class FileProviderViewController: UIViewController {

    fileprivate func callFileBrowserAPI() {
        let documentBrowser = UIDocumentBrowserViewController(forOpeningFilesWithContentTypes: [".png",".jpg",".txt"])
        documentBrowser.browserUserInterfaceStyle = .light
        self.present(documentBrowser, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func showFilesTapped(_ sender: Any) {
        self.callFileBrowserAPI()
    }
}
