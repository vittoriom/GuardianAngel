GuardianAngel
=============

A file watcher for iOS developers that runs tests only for the modified files

The problem it solves
---------------------

If you are working on a project using TDD, you may want to do quick iterations and waiting for the CI system to run tests for you every time is a bit time-consuming. Moreover, you could break tests and only find it out after CI sends you an angry email for that. The alternative is to run tests yourself, but that is also time-consuming and on the long run you may just forget about it.

Enter `guardian-angel`: you just let it watch the files you're working on, and everytime you save them, it will run the tests **only** for the file you modified. Isn't that handy? :)

Disclaimer
==========

This is my first gem, but more than that it's my first Ruby code. If you are a Ruby developer and you would like to contribute with your Ruby-fu, it would be very appreciated since this is an interesting language and I would like to learn some tricks :) 
Thanks

Installation
=============

Simply run `gem install guardian-angel` and you're set :)

Requirements
=============

The only requirement is `xctool`, since it's used to selectively run the tests. You can install it via `brew install xctool` or following instructions on [the xctool GitHub page](https://github.com/facebook/xctool) 

Configuration
=============

In the simplest case, you won't have to do anything. *It just works™*. 

### What is the simplest case?

The simplest case is when you have a workspace or a project in the **top level folder**, with the **same name as the scheme** you want to test. And **the test target is named _{scheme}Tests_**. And the **test files have a 'Test' suffix**. I know, it's a lot of things to be the simplest case, right? But if you think about it, chances are yours **is** the simplest case :)

### Ok, mine is not the simplest case, what now?

If one of the above conditions doesn't apply to you (e.g. you have more schemes or a different suffix for test files), you should create a `guardian_angel.json` file in the top level folder of your project. It should look like this:

```
{
	"workspace" : "MyApp",
	"scheme" : "MyApp-Stage",
	"target" : "MyApp-Tests",
	"suffix" : "Spec"
}
```

Available fields for the configuration are:

+ **workspace**: the name of the workspace you want to build (without extension). By default it's the workspace you have in the top level folder, if any.
+ **project**: the name of the project you want to build (without extension), if you don't use workspaces. By default it's the xcodeproj you have in the top level folder, if you don't have a workspace.
+ **scheme**: the name of the scheme you want to run tests for. By default it's *{workspace}*
+ **target**: the name of the tests target. By default it's *{scheme}Tests*
+ **suffix**: the suffix of your tests files. By default it's *Test*
+ **xctool**: the path to your xctool executable. By default it's *xctool*
+ **reporter**: the xctool reporter you want to use. By default it's *pretty*

You can just specify the configuration fields where the default value doesn't fit you, or you can specify the whole configuration if you want to.

Usage
======

Just run `guardian-angel` in the top level folder of your project.

It will build the tests first, so that it can run them faster when you'll start working on the code.

Then it will start watching the folder for modifications to `.m` or `.swift` files. When this happens, it will try to run the tests only for the modified file, so you can immediately see on the console if you broke them or not. 

ToDo
====

+ Write a custom reporter in Ruby and use it
+ Refactor the code to be more Ruby-ish

License
=======

The project is released under MIT license

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
