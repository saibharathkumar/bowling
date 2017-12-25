# README
Bowling exercise: Strike!

Background Strike! is a bowling club. They need help to keep score automatically on competitions and avoid human errors from the judges. On competitions there are 10 frames. In each frame the player has the opportunity to try to take down the pins twice and there are 10 pins on the start of each try. The rules are the following:

If the player knocks down less than 10 pins during 2 tries on the same frame, his/her score is the sum of the pins they’ve knock down in the 2 attempts.
If the player knocks down all the 10 pins during 2 tries on the same frame (spare), his/her score is the sum of the pins knocked down on the spare (10), plus the number of pins knocked down in the next try. Example: try 1(spare): 3|7, try 2: 3|4, score try 1: 13, score try 2: 7, total: 20
If the player knocks down all 10 pins on the first try (strike), his/her score is the sum of pins knocked down on the strike (10) plus the number of pins knocked down on the next 2 tries. Example: try 1(strike): 10|/, try 2: 3|4, score try 1: 17, score try 2: 7, total: 24

Application Set up 

Ruby version: 2.2.6 (rvm installed)

Rails version: 5.1+

* for System dependencies -- run command in project path 'bundle install'

Data base setup 

* rake db:create
* rake db:migrate
* rails s (start server)
