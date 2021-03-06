# Hacker News CLI Web Scraping

This is a CLI interface for scraping the HackerNews website. It will grab the
first 10 articles from front, newest, ask, or show pages and be able to display
the top 10 comments from the post

## Features

- Input for different pages
- Text highlighting for keywords like languages and interests
- Lines have a max length depending on terminal size

## Installation

1. Make sure you are on a recent Ruby version and have `bundle` installed
1. Clone this repo
1. Run `bash hnconsole.sh` to start the program
  1. If it is the first time, the program dependencies will install
1. Get the front, newest, ask, or show pages by typing it into the input
   page input line `>`
1. Once one the article input line `>>`
     1. put in the number of the article for more info on it
     1. the number of the article + `comments` for the comments of that article
     1. `!` to go back to the page line input
1. At any time, type `help` oo `man` for more info, or `quit` to exit the program

## Requirements

- `ruby >= 2.5.0`
- `bundle >= 2.1.4`
- Run on `macOS 10.15.3`, but most likely can be run on other systems w/ the
  right ruby version