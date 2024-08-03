# Requirements 

# SDK
Create a iOS/Android SDK for the provided DeckOfCards API. This should be able to be locally released and installed for local app development.

# iOS Application

Create an iOS/Android application that plays the card game "War".


# Rules for War:

all cards in a deck are dealt out to the players. each player has a "battle won" counter
players do not look at their hand
players draw a card.
player with the highest card wins and takes both cards. The "battle won" counter goes up for that player
play ends when a player has won 10 battles.

# Design of app:

Users should be able to specify the number of players for the game (up to 4)
All cards in deck get shuffled and sent to the "players" piles.
Press a button to play the round.
A random card from each pile is played, the highest card wins.
    If there's a tie between cards, the person with the most cards in their pile wins, and if there's a tie there a random player gets the cards.
Please find attached file for the API spec which you should follow for the SDK.  It is in OpenAPI3.