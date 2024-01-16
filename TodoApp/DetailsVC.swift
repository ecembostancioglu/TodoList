//
//  DetailsVC.swift
//  TodoApp
//
//  Created by Ecem Bostancıoğlu on 16.01.2024.
//

import UIKit
import CoreData

class DetailsVC: UIViewController {

    
    @IBOutlet weak var todoField: UITextField!
    @IBOutlet weak var descriptionField: UITextField!
    @IBOutlet weak var deadlineDP: UIDatePicker!
    @IBOutlet weak var imageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

      
    }
    
    
    @IBAction func saveButtonClicked(_ sender: Any) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let newTodo = NSEntityDescription.insertNewObject(forEntityName: "ToDoList", into: context)
        
        newTodo.setValue(todoField.text!, forKey: "todo")
        newTodo.setValue(descriptionField.text!, forKey: "descript")
        newTodo.setValue(deadlineDP.date, forKey: "date")
        newTodo.setValue(UUID(), forKey: "id")
        
        do{
            try context.save()
            print("saved")
        }catch{
            print("error")
        }
        
        NotificationCenter.default.post(name: NSNotification.Name("newData"), object: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
}
