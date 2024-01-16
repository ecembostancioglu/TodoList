//
//  DetailsVC.swift
//  TodoApp
//
//  Created by Ecem Bostancıoğlu on 16.01.2024.
//

import UIKit

class DetailsVC: UIViewController {

    
    @IBOutlet weak var todoField: UITextField!
    
    @IBOutlet weak var descriptionField: UITextField!
    
    @IBOutlet weak var deadlineDP: UIDatePicker!
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

      
    }
    
    
    @IBAction func saveButtonClicked(_ sender: Any) {
    }
    
    
    
}
