# Xkcd287

my first Elixir program

![General solutions get you a 50% tip.](https://imgs.xkcd.com/comics/np_complete.png)

* [xkcd 287](https://xkcd.com/287/)
* [explanation](https://www.explainxkcd.com/wiki/index.php/287:_NP-Complete)

# Spec

> With apologies to xkcd, please provide a solution to the following programming exercise:
 
> You will be given a data file (sample file is attached). The first line of the data file will have a target price. The following lines contain a menu of dishes.
 
> Write a program to read in the data file and find all combinations of dishes that add up exactly to the target price specified on the first line of the data file. If there is no solution, your program should specify that there is no combination of dishes that will be equal in cost to the target price. Keep in mind that each dish can be used more than one time!
 
> Your program will be tested on multiple data sets so please provide documentation on how to invoke your program with the correct data file. Please code your solution in Ruby.

## example dataset provided

|target total|$15.05|
|---|---:|
|mixed fruit|$2.15|
|french fries|$2.75|
|side salad|$3.35|
|hot wings|$3.55|
|mozzarella sticks|$4.20|
|sampler plate|$5.80|

## Usage

* `mix deps.get`
* `mix escript.build`
* `./xkcd_287 menu.txt`

`xkcd_287 --help` is available, and shows you how to override the desired total.

the file `menu.txt` represents the given problem

## Testing

* mix test

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
