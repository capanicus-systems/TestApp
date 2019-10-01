//
//  ToDoManager.swift
//  ToDoQuiz
//
//  Created by MAC on 01/10/19.
//  Copyright © 2019 Capanicus. All rights reserved.
//

import UIKit
import CoreData
import Firebase

class ToDoManager: NSObject {

    /*--------- init shared manager   ------------*/
    class var sharedInstance: ToDoManager
    {
        struct Static
        {
            static let instance : ToDoManager = ToDoManager()
        }
        return Static.instance
    }
    
    //defining firebase reference var
    var refToDoRealime: DatabaseReference!
    
    func fetchToDoList() {
        
        //getting a reference to the node ToDo
        refToDoRealime = Database.database().reference().child("ToDo");
        
        //observing the data changes
        refToDoRealime.observe(DataEventType.value, with: { (snapshot) in
            
            let managedContext  = AppDelegate.shared.persistentContainer.viewContext
            
            /*----------------- delete All data From LocalToDo -------------*/
            let fetchRequest    = NSFetchRequest<NSFetchRequestResult>(entityName: "LocalToDo")
            do {
                let results : NSArray = try managedContext.fetch(fetchRequest) as NSArray
                if (results.count > 0)
                {
                    for object in results {
                        managedContext.delete(object as! NSManagedObject)
                    }
                }
            }catch let err as NSError {
                print("Coredata error -> \(err.debugDescription)")
            }
            /*-------------- End ----------------*/
            
            //if the reference have some values
            if snapshot.childrenCount > 0
            {
                //iterating through all the values
                for todoData in snapshot.children.allObjects as! [DataSnapshot] {
                    //getting values
                    let todoObject = todoData.value as? [String: AnyObject]
                    let todoID : String  = todoObject?["id"] as! String
                    let todo : String  = todoObject?["todo"] as! String
                    let status : String = todoObject?["status"] as! String
                    
                    //save todo in localtodo
                    let localToDo: LocalToDo  = NSEntityDescription.insertNewObject(forEntityName: "LocalToDo", into: managedContext) as! LocalToDo
                    localToDo.todoID  = todoID
                    localToDo.todo    = todo
                    localToDo.status  = status
                    
                    DispatchQueue.main.async {
                        do
                        {
                            try managedContext.save()
                            //print("LocalToDo saved")
                            
                        } catch let error as NSError {
                            print("LocalToDo Could not save. \(error), \(error.userInfo)")
                        }
                    }
                }
            }
        })
    }
    
}
