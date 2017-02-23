# Pre-work - WorldTip

WorldTip is a tip calculator application for iOS.

Submitted by: William Gilman

Time spent: 24.5 hours spent in total

## Sceenshot
<img src='http://i.imgur.com/NV9m4Jq.png' title='Swip Main' width='' alt='Swip Main' />

## User Stories

The following **required** functionality is complete:

* [x] User can enter a bill amount, choose a tip percentage, and see the tip and total values.
* [x] Settings page to change the default tip percentage.

The following **optional** features are implemented:
* [x] Using locale-specific currency
* [x] Using currency thousands separators
* [x] Making sure the keyboard is always visible and the bill amount is always the first responder. This way the user doesn't have to tap anywhere to use this app. Just launch the app and start typing.
* [x] UI animations
* [ ] Remembering the bill amount across app restarts (if <10mins)

The following **additional** features are implemented:

- Country selector with default customary tipping options (credit: [TripAdvisor](https://www.tripadvisor.com/))
- Pulls in current exchange rates to convert the bill to USD (credit: [Fixer.io](http://fixer.io/))
- HTTP client for API calls (credit: [Alamofire](https://github.com/Alamofire/Alamofire))
- Tooltip for information about tip, total and USD total (credit: [AMPopTip](https://github.com/andreamazz/AMPopTip))
- Bill inputs from right to left always with correct currency symbol (credit: [SO Post](http://stackoverflow.com/questions/29782982/how-to-input-currency-format-on-a-text-field-from-right-to-left-using-swift))
- Background image updates to flag of the country currently selected

## Video Walkthrough

Here's a walkthrough of implemented user stories:

<img src='http://i.imgur.com/mH016vm.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />

GIF created with [LiceCap](http://www.cockos.com/licecap/).

## License

    Copyright [2017] [William Gilman]

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
