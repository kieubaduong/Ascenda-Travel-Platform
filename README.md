# Ascenda Travel Platform
The program helps to search for the best offers near the hotel where the customer is staying with the known latitude and longitude within a predetermined radius

## How to use
Install the Dart SDK: [Get the Dart SDK | Dart](https://dart.dev/get-dart)
With VSCode, in the settings search for "Dart: Cli Console" and switch to "terminal" to be able to use the console screen.

## Run program
The program will require you to enter the check-in date at the hotel. And then it will output the information of the two nearest and different offers

## The flow of the program
1. Starting from the **main.dart** file, the program will call an API from a third party to get the offers within the radius of the hotel. The API call will be executed in the **offer_service.dart** file using the **singleton** pattern to initialize the service only once
2. After getting the data, the **NearbyOfffers** class will filter the offers according to the category requested in the task with the **filterOffers** method and return a json with the filtered offers

## Algorithm
1. Initially, it will go through once from start to end to filter out the possible discounts of the **Hotel** category
2. Continuing will also go through once again to check for expired offers (booking date + 5 < offer expiration date)
3. Continuing to review the list of offers to process those with multiple merchants → only take the closest one.
4. Now we will filter the list to meet the conditions of the task:
   * Only take 2 offers
   * For the same category offers, take the closest one
   * For different category offers, take the two closest ones
5. So there are two cases:
    a. The case where there are more than one category in the list of offers
    b. The case where there is only one category in the list of offers
6. For the case of only one category, sort the list according to the distance and take the two closest ones → end the algorithm
7. For the case of multiple categories, create a hash-map with the categoryId as the key and the list of offers of that category as the value
8. Go through the hash-map once to get the closest offers for that category
9. So now we have a list of offers with different attributes and closest ones. We just need to reorder this list and take the first two elements to finish → end the algorithm

Complexity: O(3n+nlogn) (3n for 3 loops and nlogn in the case of list offers only have one type of category)
Space complexity: O(n)

## Improvement direction
* Go through the list to validate once (filter category, expired date, closest merchant)
* Do not use sorting to get the two closest offers, just go through the list twice. The first pass will find the highest value, the second pass will find the second highest value and the number of occurrences of the highest value
    * If the number of occurrences of the highest value ≥ 2, then return these two highest values
    * If not, return the highest value and the second highest value
* The algorithm only uses deletion operations from the list, so using a linked list will be the most optimal

Complexity: O(2n)
Space complexity: O(n)

## Extensible code
* The API call allows for passing parameters: longitude, latitude, and radius instead of being hardcoded
* The filter function (**filterOffers** method of **NearbyOffer** class) has a parameter list of user types to filter, so it won't be a problem if new types arise later
* When filtering the list of offers, clone a separate list and then modify on this list instead of modifying on the list (data contained in the **NearbyOffer** class) in case the original list of offers is still used for many other purposes
* There is a **constant** file to store the expiration date variable. Currently the hardcoded value is 5 according to the task, but if it changes later, just edit the variable value in this file

## Unit test
Write tests for cases where the data from the API is not fully covered