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
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var shoppingCart: ShoppingCart!
    
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

        saveButton.enabled = false
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
    
    @IBAction func fieldsEditingChanged(sender: AnyObject) {
        if (nameTextView.text != "" && quantidadeTextView.text != "" && valorUnitarioTextView.text != "") {
            saveButton.enabled = true
        } else {
            saveButton.enabled = false
        }
    }
    
    @IBAction func changeImagePushed(sender: AnyObject) {
        
        let alert = UIAlertController(title: "Product photo", message: nil, preferredStyle: .ActionSheet)

        let escolherFotoAction = UIAlertAction(title: "Photo Library", style: .Default) { (alert: UIAlertAction!) -> Void in

            let picker = self.imagePickerController
            picker.allowsEditing = true
            picker.sourceType = .SavedPhotosAlbum
            self.presentViewController(picker, animated: true, completion: nil)
        }
        
        let tirarFotoAction = UIAlertAction(title: "Camera", style: .Default) { (alert: UIAlertAction!) -> Void in
            
            let picker = self.imagePickerController
            picker.allowsEditing = false
            picker.sourceType = .Camera
            self.presentViewController(picker, animated: true, completion: nil)
            
        }
        
        alert.addAction(escolherFotoAction)
        alert.addAction(tirarFotoAction)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: {
            (alertAction: UIAlertAction!) in
            alert.dismissViewControllerAnimated(true, completion: nil)
        }))
        
        alert.view.tintColor = UIColor(hex: SaveThePiggyApperance.mainColor)
        
        self.presentViewController(alert, animated: true, completion:nil)
        
    }
    
    @IBAction func savePushed(sender: AnyObject) {
        let item = ShoppingCartItem.create() as! ShoppingCartItem
        item.name = nameTextView.text!
        item.quantity = Int(quantidadeStepper.value)
        
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .DecimalStyle

        item.price = formatter.numberFromString(valorUnitarioTextView.text!)!
        
        if let img = productImageView.image {
            item.image = UIImagePNGRepresentation(img)
        }
        
        item.cart = shoppingCart
        item.automatic = 0
        item.save()
        
        let items = shoppingCart.items!.mutableCopy() as! NSMutableOrderedSet
        items.insertObject(item, atIndex: 0)
        shoppingCart.items = items
        
        shoppingCart.save()
        
        self.navigationController?.popViewControllerAnimated(true) // back
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        self.productImageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.productImageView.contentMode = .ScaleAspectFit
        
        self.toqueParaInserirImagem.hidden = true
        
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
