//
//  FeedParser.swift
//  ReadingRSS
//
//  Created by Данил Казаков on 12.06.2020.
//  Copyright © 2020 Danil Moguchiy. All rights reserved.
//



import Foundation

class FeedParser: NSObject, XMLParserDelegate {
    
    private var rssItems: [News] = []
    private var currentElement = ""
    private var currentTitle = "" {
        didSet {
            currentTitle = currentTitle.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    private var currentPubDate = "" {
        didSet {
            currentPubDate = currentPubDate.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    private var currentCategory = "" {
        didSet {
            currentCategory = currentCategory.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    private var currentYandexFullText = "" {
        didSet {
            currentYandexFullText = currentYandexFullText.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    
    private var currentImageUrl = ""
    private var currentImageWidth = ""
    private var currentImageHeight = ""
    private var parserCompletionHandler: (([News]) -> Void)?
    
    func parseFeed(url: String, completionHandler: (([News]) -> Void)?) {
        self.parserCompletionHandler = completionHandler
        let request = URLRequest(url: URL(string: url)!)
        let urlSession = URLSession.shared
        let task = urlSession.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                if let error = error {
                    print(error.localizedDescription)
                }
                return
            }
            //parse XML data
            let parser = XMLParser(data: data)
            parser.delegate = self
            parser.parse()
           
        }
        task.resume()
    }
    
    //MARK: XML Parser Delegate
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        currentElement = elementName
        if currentElement == "item" {
            currentTitle = ""
            currentPubDate = ""
            currentCategory = ""
            currentYandexFullText = ""
            currentImageUrl = ""
            currentImageHeight = ""
            currentImageWidth = ""
        }
        
        if currentElement == "enclosure" {
            guard let urlString = attributeDict["url"] else {return}
            guard let imageWidth = attributeDict["width"] else {return}
            guard let imageHeight = attributeDict["height"] else {return}
            currentImageUrl += urlString
            currentImageHeight += imageHeight
            currentImageWidth += imageWidth
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        switch currentElement {
        case "title": currentTitle += string
        case "pubDate": currentPubDate += string
        case "category": currentCategory += string
        case "yandex:full-text": currentYandexFullText += string
        default: break
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" {
            let news = News(title: currentTitle, pubDate: currentPubDate, category: currentCategory, yandexFullText: currentYandexFullText, imageUrl: currentImageUrl, imageWidth: currentImageWidth, imageHeight: currentImageHeight)
            self.rssItems.append(news)
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        parserCompletionHandler?(rssItems)
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print(parseError.localizedDescription)
    }
}
