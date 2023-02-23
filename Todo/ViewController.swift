//
//  ViewController.swift
//  Todo
//
//  Created by fuji on 2023/02/21.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    

    // テーブルに表示するデータの配列宣言
    var TodoList = [String]()
    
    // インスタンスの生成
    let userDefaults = UserDefaults.standard
    
    // データ読み込み処理
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // データ読み込み
        if let storedTodoList = userDefaults.array(forKey: "TodoList") as? [String] {
            TodoList.append(contentsOf: storedTodoList)
        }
    }
    
    // storyboardのtableViewの紐付け
    @IBOutlet weak var tableView: UITableView!
    
    // storyboardの追加ボタンとの紐付け
    @IBAction func addButton(_ sender: Any) {
        // テキストフィールド付きアラートを表示させる
        let alertController = UIAlertController(title: "Todo追加", message: "Todoを入力してください", preferredStyle: UIAlertController.Style.alert)
        alertController.addTextField(configurationHandler: nil)
        
        // 「追加」押下時の処理
        let addTodo = UIAlertAction(title: "追加", style: UIAlertAction.Style.default){(action: UIAlertAction) in
            if let textField = alertController.textFields?.first {
                // 配列とstoryboardのtableViewに追加内容を格納
                self.TodoList.insert(textField.text!, at: 0)
                self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: UITableView.RowAnimation.right)
                
                // UserDefaultsに追加内容を格納
                /* UserDefaults:DB作成するまでもないデータを格納しておくもの */
                self.userDefaults.set(self.TodoList, forKey: "TodoList")
            }
        }
        
        // 「キャンセル」押下時の処理
        let cancel = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler:nil)
        
        alertController.addAction(addTodo)
        alertController.addAction(cancel)
        
        present(alertController, animated:true, completion: nil)
    }
    
    // 削除機能
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
        if editingStyle == UITableViewCell.EditingStyle.delete{
            // 配列とstoryboardのtableViewから削除内容を除去
            TodoList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath as IndexPath], with: UITableView.RowAnimation.automatic)
            
            // UserDefaultsから削除内容を除去
            userDefaults.set(TodoList, forKey: "TodoList")
        }
    }
    
    // 「削除」表示のための処理
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "削除"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 表示するcellの数を戻り値として返す
        return TodoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // TodoCellに表示するための変数宣言
        let TodoCell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath)
        let Todo = TodoList[indexPath.row]
        // 作成した変数にTodoの中身を格納して返す
        TodoCell.textLabel?.text = Todo
        return TodoCell
    }

}


