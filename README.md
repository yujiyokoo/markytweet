# Marky Tweet #

This is a web application that searches Twitter and generates random sentences from the search resutls.

This application has been developed on Padrino.
By default, it uses Ajax to search the web and updates on the same page as the form, but it has server-side fallback if you have Javascript turned off.

For the string generation, it uses a customised version of [MarkyMarkov](https://github.com/zolrath/marky_markov), a Markov Chain gem developed by zolrath.

For server side twitter searches, it uses memcached to cache query results.

This is a small application but has a fair bit of tests in rspec (+capybara) and jasmine.
