//
//  AddUpdateViewController.swift
//  ToDoQuiz
//
//  Created by MAC on 01/10/19.
//  Copyright © 2019 Capanicus. All rights reserved.
//

import UIKit
import CoreData

class AddUpdateViewController: UIViewController {

    @IBOutlet var toolBar: UIToolbar!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var addButton: UIButton!
    
    let placeHolderText : String = "Enter todo here..."
    var localToDo : LocalToDo?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //check if its for todo update
        if localToDo != nil {
            self.navigationItem.title = "Update ToDo"
            addButton.setTitle("Update", for: .normal)
            self.textView.text = localToDo?.todo
        } else {
            self.textView.text = placeHolderText
            self.textView.textColor = .lightGray
        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func barButtonAction(_ sender: UIBarButtonItem) {
        self.view.endEditing(true)
    }
    
    @IBAction func buttonAction(_ sender: Any)
    {
        let todoText = self.textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if localToDo != nil
        {
            //creating todo with the previous values
            let todo = ["id":localToDo?.todoID,
                        "todo": todoText,
                        "status": localToDo?.status
                        ]
            
            //updating the ToDo using the previous key of the ToDo
            ToDoManager.sharedInstance.refToDoRealime.child(localToDo!.todoID!).setValue(todo)
        }
        else
        {
            //generating a new key inside todo node and also getting the generated key
            let key = ToDoManager.sharedInstance.refToDoRealime.childByAutoId().key
            
            //creating todo with the given values
            let todo = ["id":key,
                            "todo": todoText,
                            "status": "N"
                            ]
        
            //adding the todo inside the generated unique key
            ToDoManager.sharedInstance.refToDoRealime.child(key!).setValue(todo)
        }
        
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: UITextViewDelegate
extension AddUpdateViewController: UITextViewDelegate {
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView == self.textView {
            textView.inputAccessoryView = self.toolBar
        }
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeHolderText
            textView.textColor = .lightGray
        }
    }
    
}
