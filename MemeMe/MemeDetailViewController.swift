//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Hank Wang on 2018/5/3.
//  Copyright © 2018 hanksudo. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController, UIGestureRecognizerDelegate {

    var meme: Meme!
    var swipeGesture: UISwipeGestureRecognizer!
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(goBack))
        swipeGesture.direction = .down
        swipeGesture.delegate = self
        self.view.addGestureRecognizer(swipeGesture)
    }
    
    @objc func goBack() {
        self.view.removeGestureRecognizer(swipeGesture)
        dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        imageView.image = meme.loadImage()
    }
    @IBAction func actionShare(_ sender: Any) {
        let controller = UIActivityViewController(activityItems: [imageView.image!], applicationActivities: nil)
        present(controller, animated: true, completion: nil)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
