//: Playground - noun: a place where people can play

import UIKit

let request = "{\"uniqueKey\": \"1234\", \"firstName\": \"John\", \"lastName\": \"Doe\",\"mapString\": \"Mountain View, CA\", \"mediaURL\": \"https://udacity.com\",\"latitude\": 37.386052, \"longitude\": -122.083851}"
let oldStudentUserID = "1234"
let studentUserID = "\"\(oldStudentUserID)\""
let firstName = "Molly"
let lastName = "Cox"
let mapString = "Yosemite National Park"
let studentURL = "https://sporkful.com"
let newLatitude = 37.386052
let newLongitude = -122.083851
let request2 = "{\"uniqueKey\": \(studentUserID), \"firstName\": firstName, \"lastName\": lastName,\"mapString\": mapString, \"mediaURL\": studentURL.text,\"latitude\": newLatitude, \"longitude\": newLongitude}"

print(request as Any)
print(request2 as Any)