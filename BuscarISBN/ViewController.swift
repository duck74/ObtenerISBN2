//
//  ViewController.swift
//  BuscarISBN
//
//  Created by Koss on 12/02/16.
//  Copyright © 2016 mine. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var recISBN:String?
    var resultado:String = ""
    var portadaImage:UIImage?
    
    @IBOutlet weak var portadaTitulo: UILabel!
    @IBOutlet weak var portadaView: UIImageView!
    @IBOutlet weak var verISBN: UILabel!
    
    @IBOutlet weak var verResultado: UITextView!
    
    @IBOutlet weak var insertarISBN: UIButton!
    
    
    @IBAction func clearResultado(sender: AnyObject) {
        verResultado.text = "Resultado"
    }
    
    
    @IBAction func entrarISBNView(segue: UIStoryboardSegue) {
        
        if let isbnViewController = segue.sourceViewController as? EntrarISBN {
           let isbn = NSMutableString(string: isbnViewController.ISBNbuscar!)
            let isbnString = (crearISBNString(isbn))
            verISBN.text = isbnString
            //verISBN.text = isbnViewController.ISBNbuscar
            recISBN = isbnViewController.ISBNbuscar
            verResultado.text = String(recibirJSON())
            //acceder los avlores de JSON
            //recibirJSON()
            
        }
    }
    
    
    func recibirJSON() -> NSString{
        let isbn = NSMutableString(string: recISBN!)
        let isbnString = (crearISBNString(isbn))
        //cuando puede test, usa este variable
        //let x = "978-84-376-0494-7"
        //let y = "978-08-125-0356-2"
        var test:NSString?
        var textField:NSString = ""
        
        let urlPath:String = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:"
        guard let endpoint = NSURL(string: urlPath as String + isbnString) else { print("Error creating endpoint");return "error"}
        print(endpoint)
        let datos:NSData? = NSData(contentsOfURL: endpoint)
        //test = NSString(data: datos!, encoding: NSUTF8StringEncoding)
        if datos?.length > 2 {
            
               do {
                    let json = try NSJSONSerialization.JSONObjectWithData(datos!, options: NSJSONReadingOptions.MutableLeaves)
                    let dico1 = json as! NSDictionary
                    let dico2 = dico1["ISBN:"+isbnString] as! NSDictionary
                    textField = (textField as String) + "Titulo: " + String(dico2["title"]!) + "\n" + "Autor(es): " + String((dico2["authors"]![0]!["name"]!)!) + "\n"
                    if dico2["cover"] == nil {
                        textField =  (textField as String) + "\nLibro no hay una portada"
                        portadaTitulo.hidden = true
                        portadaView.image = nil
                    }
                    else
                        {
                        if let url = NSURL(string: String((dico2["cover"]!["medium"]!)!) ), data = NSData(contentsOfURL: url) {
                            portadaImage = UIImage(data: data)
                            print(url)
                            portadaTitulo.hidden = false
                            self.portadaView.image = portadaImage
                        }
                        
                        textField = (textField as String) //+ "\nPortada" + String((dico2["cover"]!["medium"]!)!)
                    }
                    
                }
                catch _ {
                    
                }
            }
            else
            {
                print(test)
                test = "error"
            }
        
        if  (datos == nil){
            return "Hay un problema con los datos o el coneccion."
        }
        else if test == "error" {
            return "No encontró un libro con este ISBN"
        }
        else {
            return textField
        }
        //return String(jsonISBN)
        //var data:NSData?
        /*
        let isbnString = (crearISBNString(isbn))
        print(isbnString)
        let x = "978-84-376-0494-7"
        let urlPath:String = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:" + x
        guard let endpoint = NSURL(string: urlPath as String) else { print("Error creating endpoint");return  ""}
        let request = NSMutableURLRequest(URL:endpoint)
        print(request)
        NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) -> Void in
            do {
                guard let dat = data else { throw JSONError.NoData }
                //create dictionary from json
                guard let json = try NSJSONSerialization.JSONObjectWithData(dat, options: []) as? NSDictionary else { throw JSONError.ConversionFailed }
                
                let jsonString = NSString(data: dat, encoding: NSUTF8StringEncoding)! as String

                //print(jsonString)
                //resultado = NSString(data: dat, encoding: NSUTF8StringEncoding)! as String
                //print(resultado!)
                self.resultado = jsonString
            print(self.resultado)
                
            } catch let error as JSONError {
                print(error.rawValue)
            } catch {
                print(error)
            }
            }.resume()
        //let json = NSJSONSerialization.dataWithJSONObject(dat, options: NSJSONWritingOptions.PrettyPrinted, error: &error)
        return resultado*/
    }
    
    func verifyUrl (urlString: String?) -> Bool {
        //Check for nil
        if let urlString = urlString {
            // create NSURL instance
            if let url = NSURL(string: urlString) {
                // check if your application can open the NSURL instance
                return UIApplication.sharedApplication().canOpenURL(url)
            }
        }
        return false
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //yourTextField.becomeFirstResponder()
        //insertarISBN.layer.cornerRadius = 3
        portadaTitulo.hidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    enum JSONError: String, ErrorType {
        case NoData = "ERROR: no data"
        case ConversionFailed = "ERROR: conversion from JSON failed"
    }
    
    func crearISBNString(isbn: NSMutableString) -> String{
        isbn.insertString("-", atIndex: 3)
        isbn.insertString("-", atIndex: 6)
        isbn.insertString("-", atIndex: 10)
        isbn.insertString("-", atIndex: 15)
        //print(isbn)
        return String(isbn)
    }
    
}

