# Navigation App (Flutter + OpenStreetMap + OSRM)

## Overview

This is a Flutter navigation application that shows the user’s current location on a map, allows searching for places, draws routes to a selected destination, and supports alternative route selection. The app is built using OpenStreetMap for map tiles, Nominatim for place search, and OSRM for routing.

The goal of this project was to build a lightweight navigation system without using Google Maps paid APIs.

---

## Features

* Show current location on map
* Search places by name
* Show search suggestions
* Draw route from current location to destination
* Show distance and estimated time
* Support alternative routes
* Select different routes
* Stop navigation and clear route
* Handle location permission
* Handle internet connection errors
* Loader while searching places
* Close keyboard after selecting place

---

## Tech Stack

* Flutter
* GetX (State Management)
* flutter_map (OpenStreetMap)
* Geolocator (Location)
* HTTP (API calls)
* OSRM (Routing)
* Nominatim (Place search)

---

## APIs Used

1. **OpenStreetMap** – Map tiles
2. **Nominatim API** – Place search
3. **OSRM API** – Route and navigation

No Google Maps API is used in this project.

---

## How Navigation Flow Works

1. App starts and gets user current location
2. Map opens at current location
3. User searches destination
4. App shows place suggestions
5. User selects a place
6. Route is drawn on the map
7. If multiple routes available, user can select route
8. Distance and ETA are displayed
9. User can press **Stop** to clear navigation

---

## Permissions Required

### Android

* Location Permission
* Internet Permission

Add in `AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
<uses-permission android:name="android.permission.INTERNET"/>
```

---

## Author Notes

This project was built as a learning project to understand maps, location services, routing, and API integration in Flutter. The focus was on implementing navigation features without using paid map services.

---

## Run Project

```
flutter pub get
flutter run
```

---

## Demo Flow

Search → Select Place → Route Draw → Select Route → Distance/ETA → Stop Navigation

---

**End of README**
