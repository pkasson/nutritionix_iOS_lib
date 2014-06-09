# Nutritionix Client Library for iOS
===========

This is a iOS client for the [Nutritionix](http://www.nutritionix.com/) API.

This repo contains both the client library and a sample iOS project demonstrating the usage of the Nutritionix API for iOS.

There are two different invocation mechanisms and you are free to choose which one serves your application best - both make use of the AFNetworking library, which is included in the workspace.  One is asynchronous while the other is syncrhonous.  The synchronous call was created to prevent need for any call back mechanism (and works better in the unit test as well).

You must obtain an application id and key to use in the API service call.

 
## Use
```objective-c


NSDictionary *jsonDictionary = [Nutritionix_iOS_Library callNutritionixWithUPCAndWait:upc];


```