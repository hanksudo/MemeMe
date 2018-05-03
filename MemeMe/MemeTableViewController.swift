//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by Hank Wang on 2018/5/3.
//  Copyright © 2018 hanksudo. All rights reserved.
//

import UIKit

class MemeTableViewController: UITableViewController {

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        let memesCount = appDelegate.memes.count
        let tableRowCount = self.tableView.numberOfRows(inSection: 0)
        let newItems = appDelegate.memes[..<(memesCount - tableRowCount)]

        if newItems.count > 0 {
            var indexes = [IndexPath]()
            for i in 0..<newItems.count {
                let index = IndexPath(row: i, section: 0)
                indexes.append(index)
            }
            tableView.performBatchUpdates({
                tableView.insertRows(at: indexes, with: UITableViewRowAnimation.automatic)
            }, completion: nil)
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appDelegate.memes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableMemeCell", for: indexPath)
        
        let meme = appDelegate.memes[(indexPath as NSIndexPath).row]
        
        cell.textLabel?.text = meme.topText
        cell.detailTextLabel?.text = meme.bottomText
        
        if let memedImage = meme.loadImage() {
            cell.imageView?.image = memedImage
        }

        return cell
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
                let meme = appDelegate.memes[index.row]
                dest.meme = meme
            }
        }
    }

}
