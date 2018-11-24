---
author: Florent
date: 2013-02-01 08:15:46+00:00
draft: false
title: Javascript closures as a way to retain state
type: post
url: /blog/2013/javascript-closures-as-a-way-to-retain-state/
categories:
- Programming
tags:
- closures
- javascript
---

Long time no blog! Let's get back into it with a nifty and clean way of retaining state in Javascript - [closures](http://en.wikipedia.org/wiki/Closure_%28computer_science%29).

I was recently looking for an easy way to call a specific function after two separate/unrelated AJAX calls to two remote endpoints have been completed. The naive method would be to make the first AJAX call -> callback to the second AJAXÂ  call -> callback to doSomething, but we can use the fact that these two AJAX calls are not related and run them concurrently. An easy way to achieve that is to:

1. set flags, say initialising two global variables at the beginning of the file:

```js
var callback_one_done = false;
var callback_two_done = false;
```

2. have each callbacks set its own flag to 'true' upon completion and call doSomething
3. check both flags in doSomething:

```js
var doSomething = function() {
    if (callback_one_done && callback_two_done){
        // actually do something
    }
}
```

But this is a bit ugly, as it litters the global namespace with two flags that are only used there. Instead, thanks to Javascript's lexical scope we can declare doSomething as a **closure** and have the flags live inside the function itself:

```js
var doSomething = (function(){
        var callback_one_done = false;
        var callback_two_done = false;
        return function(source) {
            if (source === 'callback_one') { callback_one_done = true; }
            if (source === 'callback_two') { callback_two_done = true; }
            if (callback_one_done && callback_two_done) {
                // actually do something
            }
        };
    }());
```


What we've done here is declare an anonymous function that returns a function. This newly created function, that gets attributed to doSomething, is a closure that contains both the code needed to run _and_ the flag variables. The state is set and kept inside the function itself, without leaking on the outside environment.

Now we just need to call doSomething('callback_one') from the first AJAX call and doSomething('callback_two') from the second AJAX call and doSomething will wait until both calls are complete to run the "actually do something" part.
