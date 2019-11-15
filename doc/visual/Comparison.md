#### Comparison of Spectron and Puppeteer

| Feature                                | Spectron | Puppeteer |
| -------------------------------------- | -------- | --------- |
| [ Element API ](feaure/ElementAPI.md)                            | 2        | 1         |
| [ Page API ](feaure/PageAPI.md)                               | 1        | 2         |
| [ Browser API ](feaure/BrowserAPI.md)                            | 1        | 2         |
| [ Touchscreen/mouse/keyboard API ](feaure/InputAPI.md)         | 1        | 2         |
| [ Workers API ](feaure/WorkersAPI.md)                            | 0        | 2         |
| [ Request/Response API ](feaure/RequestResponseAPI.md)                   | 0        | 2         |
| [ Dialog API ](feaure/DialogAPI.md)                             | 0        | 1         |
| [ Electron API ](feaure/ElectronAPI.md)                           | 2        | 0         |
| [ Device emulation ](feaure/DeviceEmulation.md)                       | 1        | 2         |
| [ Page navigation ](feaure/PageNavigation.md)                        | 1        | 1         |
| [ Function exposing ](feaure/FunctionExposing.md)                      | 0        | 1         |
| [ Commands chaining ](feaure/CommandsChaining.md)                      | 1        | 0         |
| [ Screenshots creation ](feaure/ScreenshotsCreation.md)                   | 1        | 1         |
| [ Screen recording ](feaure/ScreenRecording.md)                       | 0        | 0         |
| [ Drag and drop ](feaure/DragAndDrop.md)                          | 2        | 1         |
| [ Access to raw Chrome Devtools Protocol ](feaure/ChromeDevToolsProtocol.md) | 1        | 1         |
| [ Headless testing ](feaure/HeadlessTesting.md)                       | 0        | 1         |

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
