# SwiftMVVMExample
An example of pure Swift 3 application with Model-View-ViewModel architecture.
Made as a part of the iOS coding challenge: https://github.com/luxe-eng/ios-coding-challenges

The app uses Google Places JSON API to show place autocomplete results in the first screen and place photos and details in the second one.
Carthage is used as a dependency manager and Alamofire as a network library. 

![Overview](https://i.imgur.com/U0wPwGD.gif "Overview")

# Run
Before building the project run `carthage bootstrap` to fetch the dependencies. Note that you should have Carthage installed.

You also should obtain a Google Places API key: https://developers.google.com/places/web-service/get-api-key. Once you have one, put it into a file named `GooglePlacesConfig.plist.example` and then rename it to `GooglePlacesConfig.plist`.
