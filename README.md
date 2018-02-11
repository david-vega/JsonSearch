# JsonSearch

Ruby command line application for search in JSON formatted files.

## Requirements
  - Unix command-line environment *(Not tested on Windows, it might just work)*
  - [Ruby](https://www.ruby-lang.org) v2.5.0
  - [Bundler](http://bundler.io/)
  - Internet connection or offline access to the gems in the __Gemfile__

## Installation
  - Clone or download this repository
  - In the terminal go to this project path and run `bundle install` to install all the necessary ruby gems
  - Execute the __JsonSearch__ program `ruby json_search.rb`
  - Search :smiley:
  
## Notes
  - The program searches in all the available files by default, you'll have to use the `[[file]]` command to limit the search 
  - Feel free to add other Json files to the resources folder.
  - The program loads the Json files on load, you'll have to restart in order to have the files available
  
### Commands
  - `[[file]]` Lets you specify the files you want to search, you'll have to specify the file(s) from the given list
  - `[[help]]` Shows a list of available commands and it's description
  - `[[exit]]` Exits the program
  
## Licence
```
The MIT License (MIT)

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
```
 
