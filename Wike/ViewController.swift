//
//  ViewController.swift
//  Wike
//
//  Created by Alejandro Morgan on 16/08/20.
//  Copyright © 2020 Alejandro Morgan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var textoBuscar: UITextField?
    
    var aBuscarPalabra: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
        
    @IBAction func buscar(_ sender: Any) {
         if textoBuscar!.text!.isEmpty{
            textoBuscar!.text! = "error"}
        aBuscarPalabra = textoBuscar?.text
        let urlCompleto = "https://es.wikipedia.org/w/api.php?action=query&prop=extracts&format=json&exintro=&titles=\(aBuscarPalabra!.replacingOccurrences(of:" ", with: "%20"))"
        let objetoUrl = URL(string:urlCompleto)
        let tarea = URLSession.shared.dataTask(with: objetoUrl!) { (datos, respuesta, error) in
                    if error != nil {
                        print(error!)
                    } else {
                        do{
                            let json = try JSONSerialization.jsonObject(with: datos!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String:Any]
        let querySubJson = json["query"] as! [String:Any]
        let pagesSubJson = querySubJson["pages"] as! [String:Any]
        let pageId = pagesSubJson.keys
        let primerLlave = pageId.first!
        let idSubJson = pagesSubJson[primerLlave] as! [String:Any]
        var extractStringHtml = "" as String
        if idSubJson["extract"] != nil {
            extractStringHtml = idSubJson["extract"] as! String
            print(extractStringHtml)
            DispatchQueue.main.sync(execute: {
                self.webView.loadHTMLString(extractStringHtml, baseURL: nil)
                })}else{ DispatchQueue.main.sync(execute: {
                self.textoBuscar!.text! = "error"})}
                        }catch {
                            self.textoBuscar!.text! = "error"
                        }
                    }
        }
            tarea.resume()
    }
}

 

