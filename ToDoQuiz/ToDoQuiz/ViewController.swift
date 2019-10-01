//
//  ViewController.swift
//  ToDoQuiz
//
//  Created by MAC on 01/10/19.
//  Copyright © 2019 Capanicus. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noToDoView: UIView!
    
    var todoListNSFRC: NSFetchedResultsController<NSFetchRequestResult>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.tableView.tableFooterView = UIView()
        
        //fetch todo list from firebase
        ToDoManager.sharedInstance.fetchToDoList()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if (segue.identifier == "CreateToDoSegueID") {
            let destVC = segue.destination as? AddUpdateViewController
            destVC?.localToDo = sender as? LocalToDo
        }
    }

    /*--------- Fetch LocalToDo List From Core Data ---------*/
    func fetchTodoListNSFRC() -> NSFetchedResultsController<NSFetchRequestResult>
    {
        if self.todoListNSFRC == nil
        {
            let managedContext  = AppDelegate.shared.persistentContainer.viewContext
            let fetchRequest    = NSFetchRequest<NSFetchRequestResult>(entityName: "LocalToDo")
            let fetchSort       = NSSortDescriptor(key: "todoID", ascending: false)
            fetchRequest.sortDescriptors = [fetchSort]
            fetchRequest.returnsObjectsAsFaults = false
            
            self.todoListNSFRC = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedContext, sectionNameKeyPath: nil, cacheName: nil)
            self.todoListNSFRC.delegate = self
            
            do {
                try self.todoListNSFRC.performFetch()
                
            } catch let error as NSError {
                print("Unable to perform fetch: \(error.localizedDescription)")
            }
        }
        
        return self.todoListNSFRC
    }
    
    //update todo status from checkbox
    @objc func updateToDo(_ tapGestureRecognizer: UITapGestureRecognizer)
    {
        let touch = tapGestureRecognizer.location(in: self.tableView)
        if let indexPath = self.tableView.indexPathForRow(at: touch) {
            // Access the ToDo at this index path
            if let localToDo : LocalToDo  = self.fetchTodoListNSFRC().fetchedObjects?[indexPath.row] as? LocalToDo {
                let todo = ["id":localToDo.todoID,
                            "todo": localToDo.todo,
                            "status": localToDo.status == "Y" ? "N" : "Y"
                            ]
                
                //updating the ToDo using the key of the ToDo
                ToDoManager.sharedInstance.refToDoRealime.child(localToDo.todoID!).setValue(todo)
            }
        }
    }
}

// MARK: NSFetchedResultsControllerDelegate
extension ViewController : NSFetchedResultsControllerDelegate
{
    /*--------- Fetch Controller delegate -------------*/
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>)
    {
        self.tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?)
    {
        switch type
        {
            case .insert:
                self.tableView.insertRows(at: [newIndexPath!], with: .fade)
                break
                
            case .delete:
                self.tableView.deleteRows(at: [indexPath!], with: .fade)
                break
                
            case .update:
                self.tableView.reloadRows(at: [indexPath!], with: .fade)
                break
                
            case .move:
                self.tableView.deleteRows(at: [indexPath!], with: .fade)
                self.tableView.insertRows(at: [indexPath!], with: .fade)
                break
            default:
            break
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>)
    {
        self.tableView.endUpdates()
    }
}

// MARK: UITableViewDataSource
extension ViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int) -> Int
    {
        if (self.fetchTodoListNSFRC().fetchedObjects?.count)! > 0
        {
            self.tableView.separatorStyle = .singleLine;
            self.tableView.backgroundView = nil;
            return (self.fetchTodoListNSFRC().fetchedObjects?.count)!
        }
        else
        {
            self.tableView.backgroundView = self.noToDoView;
            self.tableView.separatorStyle = .none;
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "ToDoListCell") as? ToDoListCell else {
            return ToDoListCell()
        }
        
        if let localToDo : LocalToDo  = self.fetchTodoListNSFRC().fetchedObjects?[indexPath.row] as? LocalToDo {
            cell.todoTextLabel.text = localToDo.todo
            
            if localToDo.status == "Y" {
                cell.todoTextLabel.textColor = UIColor.lightGray
                cell.statusImageView.image = UIImage(named: "check_icon")
            } else {
                cell.todoTextLabel.textColor = UIColor.black
                cell.statusImageView.image = UIImage(named: "uncheck_icon")
            }
            
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.updateToDo(_:)))
            cell.statusImageView.addGestureRecognizer(tapGestureRecognizer)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
            if let localToDo : LocalToDo  = self.fetchTodoListNSFRC().fetchedObjects?[indexPath.row] as? LocalToDo {
                let alertController = UIAlertController(title: "Alert!", message: "Do you want to delete?", preferredStyle: UIAlertController.Style.alert)
                
                let yes = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { (theAction) -> Void in
                    ToDoManager.sharedInstance.refToDoRealime.child(localToDo.todoID!).setValue(nil)
                })
                alertController.addAction(yes)
                
                let cancel = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: { (theAction) -> Void in
                    print("User Cancelled")
                })
                alertController.addAction(cancel)
                
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
}

// MARK: UITableViewDelegate
extension ViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        if let localToDo : LocalToDo  = self.fetchTodoListNSFRC().fetchedObjects?[indexPath.row] as? LocalToDo {
            self.performSegue(withIdentifier: "CreateToDoSegueID", sender: localToDo)
        }
    }
    
}

