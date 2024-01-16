//
//  ViewController.swift
//  TodoApp
//
//  Created by Ecem Bostancıoğlu on 16.01.2024.
//

import UIKit
import CoreData
import Foundation


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    @IBOutlet weak var tableView: UITableView!
    var todoArray = [String]()
    var dateArray = [Date]()
    var idArray = [UUID]()
    
    var selectedTodo = ""
    var selectedId : UUID?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        tableView.dataSource = self
        tableView.delegate = self
        
        configureItems()
        getData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: NSNotification.Name("newData"), object: nil)
    }
    
    private func configureItems(){
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(buttonClicked))
    }
    
    @objc func getData(){
        
        todoArray.removeAll(keepingCapacity: false)
        idArray.removeAll(keepingCapacity: false)
        dateArray.removeAll(keepingCapacity: false)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ToDoList")
        fetchRequest.returnsObjectsAsFaults = false
        
        
        do{
           let results = try context.fetch(fetchRequest)
            
            for result in results as! [NSManagedObject]{
                if let todo = result.value(forKey: "todo") as? String{
                    self.todoArray.append(todo)
                }
                if let date = result.value(forKey: "date") as? Date{
                    self.dateArray.append(date)
                }
                if let id = result.value(forKey: "id") as? UUID{
                    self.idArray.append(id)
                }
                
                self.tableView.reloadData()
            }

        }catch{
            print("error")
        }
    }

    @IBAction func buttonClicked(_ sender: Any) {
        selectedTodo = ""
        performSegue(withIdentifier: "toDetailsVC", sender: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           if segue.identifier == "toDetailsVC"{
               let destinationVC = segue.destination as! DetailsVC
               destinationVC.chosenTodo = selectedTodo
               destinationVC.chosenId = selectedId
           }
       }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todos")!
        cell.textLabel?.text = todoArray[indexPath.row]
        
        let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        cell.detailTextLabel?.text = dateFormatter.string(from: dateArray[indexPath.row])
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedTodo = todoArray[indexPath.row]
        selectedId = idArray[indexPath.row]
        performSegue(withIdentifier: "toDetailsVC", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
        if editingStyle == .delete{
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ToDoList")
            
            let idString = idArray[indexPath.row].uuidString
            
            fetchRequest.predicate = NSPredicate(format: "id = %@", idString)
            
            fetchRequest.returnsObjectsAsFaults = false
            
            do{
                let results = try context.fetch(fetchRequest)
                
                if results.count > 0 {
                    
                    for result in results as! [NSManagedObject]{
                        
                        if let id = result.value(forKey: "id") as? UUID{
                            
                            if id == idArray[indexPath.row]{
                                context.delete(result)
                                todoArray.remove(at: indexPath.row)
                                idArray.remove(at: indexPath.row)
                                self.tableView.reloadData()
                                
                                do{
                                    try context.save()
                                } catch {
                                    print("error")
                                }
                                break
                            }
                        }
                    }
                }
               
            }  catch let fetchError as NSError {
                print("Error fetching data: \(fetchError.localizedDescription)")
                
            }

        }
    }
    
    
}

