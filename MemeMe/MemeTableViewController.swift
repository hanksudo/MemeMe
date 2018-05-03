//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by Hank Wang on 2018/5/3.
//  Copyright © 2018 hanksudo. All rights reserved.
//

import UIKit

class MemeTableViewController: UITableViewController {

    var memes: [Meme]! {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.memes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    func configureUI() {
        let height = (tableView.frame.height)
        let width = (tableView.frame.width)
        let rowsInPortraitMode: CGFloat = 5.2
        let rowsInLandscapeMode: CGFloat = 2.5
        
        if height > width {
            tableView.rowHeight = height / rowsInPortraitMode
        } else {
            tableView.rowHeight = height / rowsInLandscapeMode
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let selectedRow = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedRow, animated: true)
        }
        
        // MARK: check new items
        let memesCount = memes.count
        let tableRowCount = self.tableView.numberOfRows(inSection: 0)
        let newCount = memesCount - tableRowCount

        if newCount > 0 {
            let newItems = memes[..<(newCount)]
            var indexes = [IndexPath]()
            for i in 0..<newItems.count {
                let index = IndexPath(row: i, section: 0)
                indexes.append(index)
            }
            tableView.performBatchUpdates({
                tableView.insertRows(at: indexes, with: UITableViewRowAnimation.automatic)
            }, completion: nil)
        } else {
            tableView.reloadData()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableMemeCell", for: indexPath)
        
        let meme = memes[(indexPath as NSIndexPath).row]
        
        cell.textLabel?.text = meme.topText
        cell.detailTextLabel?.text = meme.bottomText
        
        if let memedImage = meme.loadImage() {
            cell.imageView?.image = memedImage
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "delete") { (action, indexPath) in
            self.memes[indexPath.row].remove()
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        return [delete]
    }

    // MARK: Did select row at
    // Performs a segue with particular meme when a row is selected
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showMemeDetails", sender: AnyObject.self)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMemeDetails" {
            if let dest = segue.destination as? MemeDetailViewController,
                let index = tableView.indexPathForSelectedRow {
                let meme = memes[index.row]
                dest.meme = meme
            }
        }
    }

}
