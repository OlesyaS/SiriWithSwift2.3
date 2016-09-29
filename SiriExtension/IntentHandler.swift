//
//  IntentHandler.swift
//  SiriExtension
//
//  Created by Olesya Slepchenko on 29/09/16.
//  Copyright © 2016 OSlepchenkoApps. All rights reserved.
//

import Intents

// As an example, this class is set up to handle Message intents.
// You will want to replace this or add other intents as appropriate.
// The intents you wish to handle must be declared in the extension's Info.plist.

// You can test your example integration by saying things to Siri like:
// "Send a message using <myApp>"
// "<myApp> John saying hello"
// "Search for messages in <myApp>"

class IntentHandler: INExtension, INStartVideoCallIntentHandling {
    
    override func handlerForIntent(intent: INIntent) -> AnyObject? {
        
        if (intent is INStartVideoCallIntent) {
            return self
        }
        return nil
    }
    
    // MARK: Resolve
    
    @objc(resolveContactsForStartVideoCall:completion:)
    func resolveContacts(forStartVideoCall intent: INStartVideoCallIntent,
                                           with completion: ([INPersonResolutionResult]) -> Void) {
        print("resolveContacts")
        if let contacts = intent.contacts where contacts.count > 0 {
            
            print(" the intent has some contacts ")
            
            var resolutionResults = [INPersonResolutionResult]()
            let handle = INPersonHandle(value: "ContactName", type: .Unknown)
            let person = INPerson(personHandle: handle, nameComponents: nil, displayName: "ContactName", image: nil, contactIdentifier: "123", customIdentifier: nil)
            resolutionResults += [.success(with: person)]
            completion(resolutionResults)
        } else {
            print(" the intent has no contacts ")
            // No recipients are provided. We need to prompt for a value.
            completion([INPersonResolutionResult.needsValue()])
        }
    }
    
    // MARK: Confirm
    
    @objc(confirmStartVideoCall:completion:)
    func confirm(startVideoCall intent: INStartVideoCallIntent,
                                completion: (INStartVideoCallIntentResponse) -> Void) {
        print(" confirm(startVideoCall ")
        print(" Authorized ")
        completion(INStartVideoCallIntentResponse(code: .Ready, userActivity: nil))
    }
    
    // MARK: Handle
    
    @objc(handleStartVideoCall: completion:)
    func handle(startVideoCall intent: INStartVideoCallIntent,
                               completion: (INStartVideoCallIntentResponse) -> Void) {
        print(" handleStartVideoCall")
        if let inPerson = intent.contacts?[0] {
            // Start video call
            print("we are ready to video call")
            completion(INStartVideoCallIntentResponse(code: .Ready, userActivity: nil))
        }
        else {
            print("failure the handling")
            completion(INStartVideoCallIntentResponse(code: .Failure, userActivity: nil))
        }
    }
}

