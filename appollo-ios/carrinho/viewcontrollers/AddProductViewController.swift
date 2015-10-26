//
//  AddProductViewController.swift
//  appollo-ios
//
//  Created by Student on 10/23/15.
//  Copyright © 2015 Appollo. All rights reserved.
//

import UIKit

class AddProductViewController: UITableViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var quantidadeStepper: UIStepper!
    @IBOutlet weak var imageCell: UITableViewCell!

    @IBOutlet weak var nameTextView: UITextField!
    @IBOutlet weak var quantidadeTextView: UITextField!
    @IBOutlet weak var valorUnitarioTextView: UITextField!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var toqueParaInserirImagem: UILabel!
    
    
    lazy var imagePickerController: UIImagePickerController = {
        var picker = UIImagePickerController()
        picker.delegate = self
        return picker
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tableView.tableFooterView = UIView()
        self.imageCell.separatorInset = UIEdgeInsetsMake(0, self.imageCell.bounds.size.width, 0, 0)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func stepperValueChanged(sender: AnyObject) {
        self.quantidadeTextView.text = "\(Int(self.quantidadeStepper.value))"
    }

    @IBAction func cancelDidPushed(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func productNameChanged(sender: AnyObject) {
        self.navigationItem.title = self.nameTextView.text
    }
    
    @IBAction func changeImagePushed(sender: AnyObject) {
        
        let alert = UIAlertController(title: "Imagem do Produto", message: nil, preferredStyle: .ActionSheet)

        let escolherFotoAction = UIAlertAction(title: "Escolher Foto Existente", style: .Default) { (alert: UIAlertAction!) -> Void in

            let picker = self.imagePickerController
            picker.allowsEditing = true
            picker.sourceType = .SavedPhotosAlbum
            self.presentViewController(picker, animated: true, completion: nil)
        }
        
        let tirarFotoAction = UIAlertAction(title: "Tirar Foto", style: .Default) { (alert: UIAlertAction!) -> Void in
            
            let picker = self.imagePickerController
            picker.allowsEditing = false
            picker.sourceType = .Camera
            self.presentViewController(picker, animated: true, completion: nil)
            
        }
        
        alert.addAction(escolherFotoAction)
        alert.addAction(tirarFotoAction)
        self.presentViewController(alert, animated: true, completion:nil)
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        self.productImageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.productImageView.contentMode = .ScaleAspectFit
        
        picker.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
