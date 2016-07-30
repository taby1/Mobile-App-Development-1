//
//  Fetcher.swift
//  Lectrue 10
//
//  Created by Patrick on 7/25/16.
//  Copyright © 2016 Taby Corp. All rights reserved.
//

import Foundation

class Fetcher: NSObject, NSURLSessionDelegate, NSURLSessionTaskDelegate{
	func session() -> NSURLSession{
		let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
		configuration.timeoutIntervalForRequest = 15.0
		return NSURLSession(configuration: configuration, delegate: self, delegateQueue: nil)
	}
	
	//MARK: NSURLSessionTaskDelegate
	func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?) {
		
	}    //For when task finishes
	func URLSession(session: NSURLSession, task: NSURLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
		
	}   //for progress bars, etc.
	
	typealias RequestCompletionHandler = (data:NSData?, message:String?) -> Void
	func request(url: NSURL, completion: RequestCompletionHandler){
		let task = session().dataTaskWithURL(url){
			(data:NSData?, response:NSURLResponse?, error: NSError?) in
			let message = self.parseResponse(response, error: error)
			completion(data: data, message: message)
		}
	}
	
	typealias JSONRequestCompletionHandler = (json:NSObject?, message:String?) -> Void
	func requestJSON(url:NSURL, completion: JSONRequestCompletionHandler){
		request(url) { (data, message) in
			var json:NSObject?
			if let data = data{
				json = try? NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments) as! NSObject
			}
			completion(json:json, message:message)
		}
	}
	
	func parseResponse(response: NSURLResponse?, error:NSError?) -> String? {
		return "Something"
		return  nil
	}
}
//MARK: NSURLSessionDelegate
extension Fetcher{
	func URLSession(session: NSURLSession, didBecomeInvalidWithError error: NSError?) {
		NSLog("\(#function): Session became invalid: \(error?.localizedDescription)")
	}   //Some fatal error occured (or something)
	func URLSessionDidFinishEventsForBackgroundURLSession(session: NSURLSession) {
		
	}
	func URLSession(session: NSURLSession, task: NSURLSessionTask, didReceiveChallenge challenge: NSURLAuthenticationChallenge, completionHandler: (NSURLSessionAuthChallengeDisposition, NSURLCredential?) -> Void) {
		
	}     //Authentication/logon
	
}