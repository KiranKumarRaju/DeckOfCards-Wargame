# Deck of Cards iOS SDK

## Getting Started

### Project Setup

1. Install Xcode 15
1. Open `DeckOfCards.xcodeproj` from root folder
1. 3 targets are Created. 
    DeckOfCards - This is SDK
    DeckOfCardsTests - SDK Unit tests
    WarGame - Application

### Distrubution of SDK

1. Install correct ruby version (`rbenv install` or `asdf install`, etc, from the root project directory)
1. Run `bundle install` from the root project directory
1. Run `bundle exec fastlane distribute version_number:1.0.0`
1. XC Framework will be created under `release/Frameworks`


### Known Issue

1. Getting 500 domain error in calling API's - It's error from server

### Demo Video

