//
//  HomeViewModel.swift
//  Base MVVM Project
//
//  Created by Matija Solić on 04/08/2018.
//  Copyright © 2018 Factory. All rights reserved.
//
import UIKit
import Foundation
import RxSwift
import Moscapsule


enum mqttTopics : String {
    case Led = "LED", Dti = "dti", Fan = "fan"
    
}

class HomeViewModel: HomeViewModelProtocol {
    var mqttClient: MQTTClient!
    var temperatureC: Variable<String>
    var temperatureF: Variable<String>
    var humidity: Variable<String>
    var LED : Bool = false

    init() {
        self.temperatureC = Variable<String>("-.- °C")
         self.temperatureF =  Variable<String>("-.- °F")
         self.humidity =  Variable<String>("-.- %")
         self.mqttClient = enstablishConnection()
        
    }

    func enstablishConnection() -> MQTTClient {
        // set MQTT Client Configuration
        let mqttConfig = MQTTConfig(clientId: "pbtckmqs", host: "m24.cloudmqtt.com", port: 15785, keepAlive: 60)
        
        mqttConfig.mqttAuthOpts = MQTTAuthOpts(username: "testUser1", password: "testUser1")
        
        mqttConfig.onPublishCallback = { messageId in
            NSLog("published (mid=\(messageId))")
        }
        mqttConfig.onMessageCallback = { mqttMessage in
            print(mqttMessage.topic)
            self.serialize(message: mqttMessage)
        }
        
        // create new MQTT Connection
        let mqttClient = MQTT.newConnection(mqttConfig)
        
        // subscribe
        
        mqttClient.subscribe("test", qos: 2)
        mqttClient.subscribe("dti", qos: 1)
        
        return mqttClient
    }
    
    
    func triggerFanSpeed(speed: Float) {
        let scaledFanValue: Int = Int((1023 - 0) * (speed - 0) / (100 - 0))
        self.mqttClient.publish(string: String(scaledFanValue), topic: "fan", qos: 1, retain: false)
    }
    
    func triggerLED() {
        if LED {
            self.mqttClient.publish(string: "1", topic: "LED", qos: 1, retain: false)
            self.LED = !LED
        }
        else {
            self.mqttClient.publish(string: "0", topic: "test", qos: 1, retain: false)
            self.LED = !LED
        }
        
    }

}

extension HomeViewModel {
    
    func serialize(message: MQTTMessage) {
       
                switch message.topic {
                case mqttTopics.Led.rawValue:
                    break
                case mqttTopics.Dti.rawValue:
                    let jsonDecoder = JSONDecoder()
                    if let dataToDecode = message.payloadString?.data(using: .utf8) {
                        do {
                            let data = try jsonDecoder.decode(DTIObject.self, from: dataToDecode)
                            self.humidity.value = String(data.dti.humidity) + " %"
                            self.temperatureC.value = String(data.dti.temperatureC) + " °C"
                            self.temperatureF.value = String(data.dti.temperatureF) + " °F"
        
                        } catch let error {
                            print(error.localizedDescription)
                        }
                    }
                case mqttTopics.Fan.rawValue:
                    break
                default:
                    print(message.topic)
                }
     
    }
    
}

protocol HomeViewModelProtocol {
    func triggerLED()
    func triggerFanSpeed(speed: Float)
    var temperatureC: Variable<String> {get}
    var temperatureF: Variable<String> {get}
    var humidity: Variable<String> {get}
}
