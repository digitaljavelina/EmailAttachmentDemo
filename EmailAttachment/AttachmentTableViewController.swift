//
//  AttachmentTableViewController.swift
//  EmailAttachment
//
//  Created by Simon Ng on 21/11/14.
//  Copyright (c) 2014 AppCoda. All rights reserved.
//

import UIKit
import MessageUI


class AttachmentTableViewController: UITableViewController, MFMailComposeViewControllerDelegate {
    
    enum MIMEType: String {
        case jpg = "image/jpeg"
        case png = "image/png"
        case doc = "application/msword"
        case ppt = "application/vnd.ms-powerpoint"
        case html = "text/html"
        case pdf = "application/pdf"
        
        init?(type: String) {
            switch type.lowercaseString {
            case "jpg": self = .jpg
            case "png": self = .png
            case "doc": self = .doc
            case "ppt": self = .ppt
            case "html": self = .html
            case "pdf": self = .pdf
            default: return nil
                
            }
        }
    }


    let filenames = ["10 Great iPhone Tips.pdf", "camera-photo-tips.html", "foggy.jpg", "Hello World.ppt", "no more complaint.png", "Why Appcoda.doc"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }


    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return filenames.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) 

        // Configure the cell...
        cell.textLabel?.text = filenames[indexPath.row]
        cell.imageView?.image = UIImage(named: "icon\(indexPath.row).png");

        return cell
    }
    
    func showEmail(attachmentFile: String) {
        // check if the device is capable of sending email
        
        guard MFMailComposeViewController.canSendMail() else {
            return
        }
        
        let emailTitle = "Great photo and doc"
        let messageBody = "Hey, check this out!"
        let toRecipients = ["mike@digitaljavelina.com"]
        
        // initialize the mail composer and populate mail content
        
        let mailComposer = MFMailComposeViewController()
        mailComposer.mailComposeDelegate = self
        mailComposer.setSubject(emailTitle)
        mailComposer.setMessageBody(messageBody, isHTML: false)
        mailComposer.setToRecipients(toRecipients)
        
        // determine the file name and extension
        
        let fileParts = attachmentFile.componentsSeparatedByString(".")
        let filename = fileParts[0]
        let fileExtension = fileParts[1]
        
        // get the resource path and read the file using NSData
        
        guard let filePath = NSBundle.mainBundle().pathForResource(filename, ofType: fileExtension) else {
            return
        }
        
        // get the file data and MIME type
        
        if let fileData = NSData(contentsOfFile: filePath), mimeType = MIMEType(type: fileExtension) {
            // add attachment
            
            mailComposer.addAttachmentData(fileData, mimeType: mimeType.rawValue, fileName: filename)
            
            // present mail view controller on screen
            
            presentViewController(mailComposer, animated: true, completion: nil)
        }
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        
        switch result.rawValue {
        case MFMailComposeResultCancelled.rawValue:
            print("Mail cancelled")
        case MFMailComposeResultSaved.rawValue:
            print("Mail saved")
        case MFMailComposeResultSent.rawValue:
            print("Mail sent")
        case MFMailComposeResultFailed.rawValue:
            print("Failed to send mail: \(error)")
        default: break
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedFile = self.filenames[indexPath.row]
        showEmail(selectedFile)
    }
    

}
