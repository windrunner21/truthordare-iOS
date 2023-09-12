# TruthDare AI

TruthDare AI is an iOS application that grants new look at the traditional "Truth or Dare" game:

- Includes AI.
- No ads. 
- Simple design.
- Full game customizability.

### Availability:
- iOS 15.0 and higher
- App Store Link (In Review)

##
<p align="row">
  <img src="https://github.com/windrunner21/truthordare-iOS/assets/18750749/a90cf8ee-1ab0-4e42-8f44-c276da65b455" width="200" >
  <img src="https://github.com/windrunner21/truthordare-iOS/assets/18750749/58dc7dc6-db62-4e93-94a2-8d25d9c5a55f" width="200" >
</p> 

## Features
- [x] AI generated Truths and Dares.
- [x] Add/Remove Players before and in-game.
- [x] Only Truth or Only Dare Game Mode.
- [x] Randomize or Queue Players.
- [x] Create Custom Truths and Custom Dares.
- [x] Turn off Truths and Dares - come up with own content on the spot.
- [x] Dark Mode.
- [x] No ads and never will be.
- [x] Modern feel and look. 

## Implementation
Implemented using native iOS development. 

### Architecture
Architecture used for the project is a 4 layered architecture. Layers are: 

- Business Logic Layer 
- UI Layer
- Network Layer
- Storage Layer

SOLID principles were used.
Patterns like Delegate Pattern were used to keep code simple and readable.

### In-App Purchases
In-App Purchases: Renewable Subscription named TruthAI+ was implemented in order to grant eligible users access to AI generated content. 
Therefore, custom paywall was implemented inside the application to let users access full features of the application but AI content without the eligible subscription. 
And let paid users access AI generated content. Restore purhases option was implemented as well.

### Storage
CoreData was used in order to store user's custom truths and dares. Encrypted NSUserDefaults were used in order to store user's application settings.

### Network
Network Layer was implemented using core URLSession and Tasks. AI generated content is fetched from trained ChatGPT model.

### Design
Storyboard and Programmable design was used. Storyboards let you imagine the design easier, as they were used in simple screens.
UIKit was used as a UI framework. Custom UI classes were built for reusability and maintanability. Designed by Imran Hajiyev. Prototyped in Figma.

## Screenshots

### Game Screens: Truth and Dare
<p align="row">
  <img src="https://github.com/windrunner21/truthordare-iOS/assets/18750749/a906a033-512a-41e8-9ee6-afd8da80c71d" width="200" >
  <img src="https://github.com/windrunner21/truthordare-iOS/assets/18750749/badda240-9da3-471c-aeb2-5389f71a1347" width="200" >
</p>

### Players: Add Player and Manage Players
<p align="row">
  <img src="https://github.com/windrunner21/truthordare-iOS/assets/18750749/09da07f0-d66c-45c2-8425-58951238c593" width="200" >
  <img src="https://github.com/windrunner21/truthordare-iOS/assets/18750749/e78f1a17-82b5-4b8d-98f3-f821b0163400" width="200" >
</p>

### Game Settings
<p align="row">
  <img src="https://github.com/windrunner21/truthordare-iOS/assets/18750749/1df792ac-c673-471b-95ec-8ebd63ca7d7f" width="200" >
  <img src="https://github.com/windrunner21/truthordare-iOS/assets/18750749/cb450431-0140-48f8-8ed9-670dc8a7ed3e" width="200" >
  <img src="https://github.com/windrunner21/truthordare-iOS/assets/18750749/16b741df-5617-4663-a56b-c9a748058f1e" width="200" >
</p>

### TruthAI+ Subscription
<p align="row">
  <img src="https://github.com/windrunner21/truthordare-iOS/assets/18750749/93133d66-adbe-4507-878d-db831f9bc626" width="200" >
  <img src="https://github.com/windrunner21/truthordare-iOS/assets/18750749/b957e1a1-c9e5-44e7-ad70-b87740a4be3a" width="200" >
</p>

# Copyright
iOS version created by Imran Hajiyev. All rights reserved 2023 TruthDare AI.

- Official Website: https://truth-or-dare-ai.vercel.app
- Privacy Policy: https://truth-or-dare-ai.vercel.app/privacy-policy

## Contact
Reach me here or submit offical form at https://truth-or-dare-ai.vercel.app

# Imran Hajiyev ©
