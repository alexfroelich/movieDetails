//
//  NoConnectionViewController.swift
//  MovieDetails
//
//  Created by Alexander Froelich on 27/09/21.
//

import UIKit

protocol NoConnectionDelegate {
    func fetchDataAgain(_ noConnectionViewController: NoConnectionViewController)
    
}

class NoConnectionViewController: UIViewController {

    var delegate: NoConnectionDelegate?
    var main: MainViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func tryAgainPressed(_ sender: UIButton) {
        delegate?.fetchDataAgain(self)
       
        dismiss(animated: true, completion: nil)
    }
    
    

}
