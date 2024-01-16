//
//  DetailsVC.swift
//  TodoApp
//
//  Created by Ecem Bostancıoğlu on 16.01.2024.
//

import UIKit
import CoreData
import PhotosUI

class DetailsVC: UIViewController, UINavigationControllerDelegate, PHPickerViewControllerDelegate{

    
    
     func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
         picker.dismiss(animated: true)
                if let itemprovider = results.first?.itemProvider{
                  
                    if itemprovider.canLoadObject(ofClass: UIImage.self){
                       
                        itemprovider.loadObject(ofClass: UIImage.self) { image , error  in
                            if let selectedImage = image as? UIImage{
                                DispatchQueue.main.async {
                                    self.imageView.image = selectedImage
                                }
                            }
                        }
                    }
                    
                }
     }
     

 
    
    
    @IBOutlet weak var todoField: UITextField!
    @IBOutlet weak var descriptionField: UITextField!
    @IBOutlet weak var deadlineDP: UIDatePicker!
    @IBOutlet weak var imageView: UIImageView!
    
    var chosenTodo = ""
    var chosenId : UUID?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if chosenTodo != ""{
            //Core Data
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
                     
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ToDoList")
            let idString = chosenId?.uuidString
            fetchRequest.predicate = NSPredicate(format: "id = %@", idString!)
            fetchRequest.returnsObjectsAsFaults = false
            
            
            do{
                let results = try context.fetch(fetchRequest)
                          
                    if results.count > 0 {
                        for result in results as! [NSManagedObject]{
                            if let todo = result.value(forKey: "todo") as? String {
                                     todoField.text = todo
                        }
                            if let descript = result.value(forKey: "descript") as? String {
                                    descriptionField.text = descript
                        }
                            if let date = result.value(forKey: "date") as? Date{
                                     deadlineDP.date = date
                        }
                            if let imageData = result.value(forKey: "image") as? Data{
                                    let image = UIImage(data: imageData)
                                     imageView.image = image
                        }
                             }
                         }
                         
                     }catch{
                         print("error")
                     }
            
        } else {
            todoField.text = ""
            descriptionField.text = ""
        }
        
        //Recognizers
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(gestureRecognizer)
        
        imageView.isUserInteractionEnabled = true
                let imageTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectImage))
                imageView.addGestureRecognizer(imageTapRecognizer)
      
    }
    
    
    @objc func hideKeyboard(){
           view.endEditing(true)
       }
    
    @objc func selectImage(){
           
           configureImagePicker()
           
       }
       
       func configureImagePicker(){
           var configuration = PHPickerConfiguration()
                     configuration.selectionLimit = 1
                     configuration.filter = .images
           let pickerViewController = PHPickerViewController(configuration: configuration)
                     pickerViewController.delegate = self
                     present(pickerViewController, animated: true)
          }
       
       
    @IBAction func saveButtonClicked(_ sender: Any) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let newTodo = NSEntityDescription.insertNewObject(forEntityName: "ToDoList", into: context)
        
        newTodo.setValue(todoField.text!, forKey: "todo")
        newTodo.setValue(descriptionField.text!, forKey: "descript")
        newTodo.setValue(deadlineDP.date, forKey: "date")
        newTodo.setValue(UUID(), forKey: "id")
        
        let data = imageView.image?.jpegData(compressionQuality: 0.5)
        newTodo.setValue(data, forKey: "image")
        
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
