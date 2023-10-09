//
//  ViewController.swift
//  AudicallDemo
//
//  Created by macOS on 07/10/23.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var jionButton: UIButton!
    @IBOutlet weak var chanelIDTextFiled: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    @IBAction func jionButtonClick(_ sender: UIButton) {
        self.view.endEditing(true)
//        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let JionCallVC = JionCallViewController.initialize(from: .main)
        JionCallVC.channelName = self.chanelIDTextFiled.text ?? "1"
        navigationController?.pushViewController(JionCallVC, animated: true)
    }
}

struct KeyCenter {    
    static let AppId: String = "Agora Key"
    static let Certificate: String? = ""
}
