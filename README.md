<p align="center">
  <img src="https://spanet.com.au/wp-content/uploads/AppLogo_pic-450x451.png" width="150">
</p>

# SpaNET API
This documentation allows you to control SpaNET WiFi controllers which can be found in Vortex/SpaNET spa's. If your spa works with the SpaNET SpaLINK app, this documentation will help you automate and integrate control of it into your own code.

# Plugins & Libraries
Some SpaNET plugins and libraries for various programming languages/platforms have been created for ease of use. Below listed are current plugins available. To get your SpaNET plugin created based on this API for a platform not already on this list shown here (e.g. openHAB, Home Assistant, Python Package, Node.JS Package), please open an issue with the URL to your repository and information so this can help make it more visible.
* Homebridge: homebridge-spanet [STATUS: COMING SOON]  
  View on [Github](https://github.com/BlaT2512/homebridge-spanet) or [NPM](https://www.npmjs.com/)
<!--
* Javascript: spanet [STATUS: NOT YET PLANNED]  
  View on [Github](https://github.com/BlaT2512) or [NPM](https://www.npmjs.com/)
* Python: spanet [STATUS: NOT YET PLANNED]  
  View on [Github](https://github.com/BlaT2512) or [PyPI](https://pypi.org/)
-->

# Code Included
This Github repo contains code snippets which can be used in your own programming to demonstrate how to communicate with SpaLINK in different programming languages. Included files are listed below.
* code-request/
  * code-demo-request.swift  
  Demo of making SpaNET API web requests in Apple's Swift programming language (uses CocoaPods dependency manager)
  * code-demo-request.js  
  Demo of making SpaNET API web requests in JavaScript (uses NodeJS and package manager NPM)
  * code-demo-request.ts  
  Demo of making SpaNET API web requests in TypeScript (uses NodeJS and package manager NPM)
  * code-demo-request.py  
  Demo of making SpaNET API web requests in Python (uses Python package manager PIP)
  * code-demo-request.go  
  Demo of making SpaNET API web requests in Go (Golang)
* code-websocket/
  * code-demo-socket.swift  
  Demo of connecting to spa web socket in Apple's Swift programming language (uses CocoaPods dependency manager)
  * code-demo-socket.js  
  Demo of connecting to spa web socket in JavaScript (uses NodeJS and package manager NPM)
  * code-demo-socket.ts   
  Demo of connecting to spa web socket in TypeScript (uses NodeJS and package manager NPM)
  * code-demo-socket.py  
  Demo of connecting to spa web socket in Python (uses Python package manager PIP)
  * code-demo-socket.go  
  Demo of connecting to spa web socket in in Go (Golang)
* code-demo/
  * code-demo.swift  
  Full working demo of spa control in Apple's Swift programming language (uses CocoaPods dependency manager)
  * code-demo.js  
  Full working demo of spa control in JavaScript (uses NodeJS and package manager NPM)
  * code-demo.ts  
  Full working demo of spa control in TypeScript (uses NodeJS and package manager NPM)
  * code-demo.py  
  Full working demo of spa control in Python (uses Python package manager PIP)
  * code-demo.go  
  Full working demo of spa control in Go (Golang)

# Credits
Thanks to [@devbobo's](https://github.com/devbobo) original work and inspiration to make this full API.  
Also thanks to [@thehoff](https://github.com/thehoff) for contributions and assistance developing this.

# API
### See [spanet.md](spanet.md)

# FAQs
**Q - Which spa companies produce spa's using the SpaNET spa controller and are compatible with the SmartLINK module?**  
SpaNET spa controllers can be found in a variety of Vortex, Oasis and many other brand spas/swim spas/spa pools.

**Q - If my spa has a compatible SpaNET controller without WiFi, can I make my own SmartLINK module?**  
This should be possible, and testing to successfully make and program a homemade SmartLINK compatible module is currently underway. This will be updated if we complete this and decide to release a documentation about it.
