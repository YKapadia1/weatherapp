# CO2509 Assignment: Weather Application

An android app using Flutter aimed at showing the weather and forecast of user seleted cities.

## Introduction

This project is a basic weather app created that can show the current weather of a given city.
It allows you to add cities, as well as set certain cities as favourites, at which point they will also show in a seperate list.
Due to API limitations, only the current weather of a given city can be displayed. No weather forecasts will be displayed.
This app uses the AirVisual API provided by IQAir to get weather data for cities.

## Getting Started

**IMPORTANT: Before building, ensure you have Flutter version 2.10.3 installed. Older versions may not work.**

If building the app for the first time, run the following batch files in this order:

- cleanproj.bat
- getpkg.bat
- buildapp.bat


It is also possible to do the same thing in Visual Studio Code, provided you have the project folder open in a workspace and Dart/Flutter is integrated into the IDE:

- In the terminal, type the command "flutter clean" without quotes to completely clean the project.
- Next, type the command "flutter pub get" also without quotes to acquire the necessary packages.
- Finally, type the command "flutter build apk" also without quotes to build the project.

The assembled APK can be found in "\build\app\outputs\flutter-apk", and will be called "app-release.apk".

When downloading the ZIP, the project should have already had cleanproj.bat run already, so all you need to do is download the necessary
packages, and build the project.


## How To Use

Upon launching the app, you will be presented with a screen showing an empty list of cities, with the app informing you that you have no cities in the list.
Swiping right-to-left or tapping on the "Favourites" button will show another empty list of cities. This is the favourites list. Any cities you have favourited will show up here.

## Adding a City

Tapping the pin with a plus icon in the bottom right will take you to a page where you can add a city of your choosing. 
Tapping the location icon in the top right will ask if you want to add the city that is closest to you based on your IP address.

If you want to add a certain city, you can do so by filling in the drop down boxes for the country, state, and city, and then pressing the "Add City" button.

**Note that if you are in a city unsupported by the API, then an error will be returned and a message stating as such will be displayed. Unfortunately this is a limitation of the API, and cannot be fixed by me.**

Once you have added the city to the list, your selection should show up in the list of cities.

## Viewing the weather of a city

To view the weather of a city in your list, simply tap on the entry in the list. After a second or two, the weather data should be displayed, which includes the current temperature. The current weather conditions, such as if it is sunny or raining will also be displayed.

**Note: Due to limitations of the API plan this application utilises, weather forecasts are not provided.**

## Adding/Removing a city from favourites

To add a city to your favourites list, long press on the entry you want adding to the favourites. This can also be done when viewing the weather of a given city by tapping the heart icon in the top right.

To remove a city, either long press on it again, or go to the favourites list and swipe left-to-right on the entry to remove it. This can also be done when viewing the weather of a given city by tapping the heart icon in the top right.

## Changing the App Theme

This app supports both a light theme and a dark theme. To change the theme, tap the gear icon in the top right on the main page. This will take you to a settings page. From there, tap the slider with the "Dark Mode" label to change the theme from light to dark and vice versa.
