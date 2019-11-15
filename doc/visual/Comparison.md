#### Comparison of Spectron and Puppeteer

| Feature                                | Spectron | Puppeteer |
| -------------------------------------- | -------- | --------- |
| Element API                            | 2        | 1         |
| Page API                               | 1        | 2         |
| Browser API                            | 1        | 2         |
| Touchscreen/mouse/keyboard API         | 1        | 2         |
| Workers API                            | 0        | 2         |
| Request/Response API                   | 0        | 2         |
| Dialog API                             | 0        | 1         |
| Electron API                           | 2        | 0         |
| Device emulation                       | 1        | 2         |
| Page navigation                        | 1        | 1         |
| Function exposing                      | 0        | 1         |
| Commands chaining                      | 1        | 0         |
| Screenshots creation                   | 1        | 1         |
| Screen recording                       | 0        | 0         |
| Drag and drop                          | 2        | 1         |
| Access to raw Chrome Devtools Protocol | 1        | 1         |
| Headless testing                       | 0        | 1         |

#### Legend

0. missing
1. basic API or feature exists
2. advanced API

#### Summary

- Both have similar API related to interaction with page and element. If some method is missing, the desired result can be achieved via other methods.
- Puppeteer methods return a promise. No chaining support.
- Puppeteer has more browser and page related API.
- Puppeteer has a convenient mouse/keyboard/touchscreen/dialog API.
- Puppeteer supports only testing in Chrome.
- Puppeteer has workers API
- Puppeteer supports headless mode

- Spectron has more useful methods/shortcuts related to element interaction.
- Spectron methods return the thenable object, supports command chaining.
- Spectron has shortcut for element drag-and-drop
- Spectron has debug feature( allows to pause browser execution and just into devtools )
- Spectron has full access to electron API( requires nodeIntegration to be enabled in electron )
- Spectron does not support headless mode out of the box
