# splitty
An app I'm making to help people (mainly college students) split bills easily in groups.

## Remaining Features
- [X] **Total calculation.** The working list should have a footer view that shows the current subtotal of the list, along with a button to save it.
- [X] **Saveable lists.** Users should be able to save the list they're working on when they're done with it. When they save it, they should be able to give it a name, and the list, along with its name, should show up in the "Past Splits" tab.
- [ ] **Editable items.** Users should be able to click on an item in the current list to view its details and edit it.
- [ ] **Details for past splits.** When users are looking at their past splits, they should be able to click on one to see the items in it.
- [ ] **Barcode scanning.** Currently, users have to enter all product info manually. I want to implement barcode scanning using AVFoundation so they can scan the UPC of a product and have its information auto-populate. The app should also track any changes they make to this information and persist them for future use.
- [ ] **Empty states.** Table views should show some kind of message (and in some cases, a button) when they have no content to display. This should also apply to the list of people that's shown in `AddItemManuallyViewController`.

## Future Features
- [ ] **Smart barcode scanning.** If a user scans a barcode for an item and then changes any of its information, those updates should be saved so the next time the user scans that item, they're automatically applied.
- [ ] **Group lists.** Users should be able to connect their phones together using Multipeer Connectivity so they can all work on the same list together.

## Things to Clean Up
- [ ] **Localization and string constants.** Splitty currently has string literals strewn all over the codebase to set values for UI elements. I want to replace this with a `Localizable.strings` file soon. Currency values are already formatted using `NSCurrencyFormatter`, so they should be a non-issue. However, I'm unhappy with the way `Models/Item.swift` currently formats the names of its members to produce displayable strings like `A`, `A and B`, `A, B, and C`, etc. I want to clean this up and use something more generalized and localizable.
- [ ] **Custom view and control configuration.** Splitty has a few custom views and controls. I decided to move all of the logic for creating constraints to create more complex views out of view controllers to make reusable `UIView` subclasses instead. I'm unhappy with how I designed those subclasses to allow configuration of the more basic UIKit elements they're composed of. Most of it is currently done using `didSet` hooks and by using `get {} set {}` to wrap around the real values. I want to fix this and make custom view and control configuration more sensible.
- [ ] **Core Data on the main queue.** So far, I haven't moved any of Splitty's Core Data work onto background threads. This is mainly because the amount of data involved so far has been very small. There are no image files or binary data being stored, and most users' entire databases will probably be < 50K bytes. However, if any features require it for performance reasons, I want to move Core Data work to the background thread.
- [ ] **Better abstractions for constraints.** I've avoided external dependencies like SnapKit in favor of Auto Layout anchors. At first, they did a great job at letting me set up constraints with minimal boilerplate, but as the constraints in Splitty grew a little more, I feel more like I need to create some kind of light abstraction over Auto Layout to reduce the amount of code necessary to build constraints.
