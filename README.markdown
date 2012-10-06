[Kaffee](http://fabianm.github.com/kaffee)
===========================================
Kaffee is a software project management tool similar to Maven and is written in Coffeescript.
Kaffee allows you to compile, test, minify and many other tasks to make building your application simple and fun again.

**Warning: Kaffee is currently missing much documentation and is still in development stage.**

Installation
------------
Use `npm` to install Kaffee:

    npm install kaffee kaffee-cli -g
    
This will install the Kaffee core and the command line interface globally.

Configuring your project
------------------------
Kaffee prevents you from having huge build files. Instead, you add a few lines to your package.json file:

    {
      "name" : "myapp",
      "version" : "0.0.1",
      "dependencies" : {
        "kaffee-coffeemaker" : "latest"
      },
      "kaffee" : {
        "archtype" : "kaffee-coffeemaker"
      }
    }

Directory structure
-------------------
Kaffee uses a different directory structure than most other major Nodejs project:

    myapp
    -- src
    ---- main   Main source files
    ---- test   Test source files
    -- lib
    ---- main   Main output files
    ---- test   Test output files

Compile your project
--------------------
Compiling Coffeescript projects is not problem for Kaffee. Use the above configuration and run:

    kaffee compile
    
This will compile all files in the `src/main` and `src/test` into the `lib/main` and `lib/test` folder.
