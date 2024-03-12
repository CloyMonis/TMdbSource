//
//  ViewController.swift
//  TMdbSource
//
//  Created by Cloy.Monis on 03/11/2024.
//  Copyright (c) 2024 Cloy.Monis. All rights reserved.
//

import UIKit
import TMdbSource

class ViewController: UIViewController {

    let dataSource = TMdbDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        dataSource.getMovies(pageNo: 1) { movies in
            print(" movies count before \(movies.count)")
        }
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 5.0 , execute: DispatchWorkItem(block: {
            self.dataSource.getMovies(pageNo: 1) { movies in
                print(" movies count after \(movies.count)")
            }
        }))
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

