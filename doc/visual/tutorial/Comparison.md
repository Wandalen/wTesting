#### Comparison of Spectron and Puppeteer

| Feature                                | Spectron | Puppeteer |
| -------------------------------------- | -------- | --------- |
| [ Element API ](feature/ElementApi.md)                            | 2        | 1         |
| [ Page API ](feature/PageApi.md)                               | 1        | 2         |
| [ Browser API ](feature/BrowserApi.md)                            | 1        | 2         |
| [ Touchscreen/mouse/keyboard API ](feature/InputApi.md)         | 1        | 2         |
| [ Workers API ](feature/WorkersApi.md)                            | 0        | 2         |
| [ Request/Response API ](feature/RequestResponseApi.md)                   | 0        | 2         |
| [ Dialog API ](feature/DialogApi.md)                             | 0        | 1         |
| [ Electron API ](feature/ElectronApi.md)                           | 2        | 0         |
| [ Device emulation ](feature/DeviceEmulation.md)                       | 1        | 2         |
| [ Page navigation ](feature/PageNavigation.md)                        | 1        | 1         |
| [ Function exposing ](feature/FunctionExposing.md)                      | 0        | 1         |
| [ Commands chaining ](feature/CommandsChaining.md)                      | 1        | 0         |
| [ Screenshots creation ](feature/ScreenshotsCreation.md)                   | 1        | 2         |
| [ Screen recording ](feature/ScreenRecording.md)                       | 0        | 0         |
| [ Drag and drop ](feature/DragAndDrop.md)                          | X        | X         |
| [ Drag and drop file from system into browser ](feature/DragAndDropFile.md)                          | 1        | 1         |
| [ Access to raw Chrome Devtools Protocol ](feature/ChromeDevToolsProtocol.md) | X        | 1         |
| [ LocalStorage support ](feature/LocalStorage.md) | 2        | 1         |
| [ Opening the HTML page using local path without server ](feature/ServerlessTesting.md) | 1        | 1 |
| [ Wait until element is visible ](feature/WaitForElementIsVisible.md) | 1        | 1 |
| [ Wait until element is visible in viewport ](feature/WaitForElementIsVisibleInViewport.md) | 1        | 1 |
| [ Check if element is visible in viewport ](feature/IsVisibleInViewport.md) | 1        | 1 |
| [ Get element(s) attribute value ](feature/GetElementAttribute.md) | 1        | 1 |
| [ Wait until dialog appears ](feature/WaitForDialog.md) | 1        | 1 |
| [ Headless testing ](feature/HeadlessTesting.md)                       | 0        | 1         |
| [ Performance ](feature/Performance.md)                       |    0     |   1    |

#### Legend

- 0 - missing
- 1 - basic API or feature exists
- 2 - advanced API
- X - bugged

#### Summary

- Both have similar API related to interaction with page and element. If some method is missing, the desired result can be achieved via other methods.
- Puppeteer methods return a promise. No chaining support.
- Puppeteer has more browser and page related API.
- Puppeteer has a convenient mouse/keyboard/touchscreen/dialog API.
- Puppeteer supports only testing in Chrome.
- Puppeteer has workers API
- Puppeteer supports headless mode
- Puppeteer is better for unit tests, as unit tests should be fast enough

- Spectron has more useful methods/shortcuts related to element interaction.
- Spectron methods return the thenable object, supports command chaining.
- Spectron has shortcut for element drag-and-drop
- Spectron has debug feature( allows to pause browser execution and just into devtools )
- Spectron has full access to electron API( requires nodeIntegration to be enabled in electron )
- Spectron does not support headless mode out of the box
- Spectron is good for integration tests because the integration tests do not have to be fast

[Back to content](../README.md#Tutorials)

