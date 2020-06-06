# COMMUNITY COMPOSE
Welcome to Community Compose! We're glad you found us.

We are a Ruby on Rails application that integrates with an online music notation software to provide music composers an opportunity to meet, socialize, and collaborate with other musicians in their geographic area.
___
## Why?
Community Compose was created by [Zach Holcomb](https://github.com/zachholcomb), [Kevin McGrevey](https://github.com/kmcgrevey), [Tyler Porter](https://github.com/tylerpporter), and [Andrew Reid](https://github.com/reid-andrew) as a [class project](https://backend.turing.io/module3/projects/terrificus/) for the Turing School of Software and Design's [Back End Engineering](https://backend.turing.io/) program.

The idea for this application came from Zach, who had used music notation software previously and felt that it was missing an important "social media" aspect.
___
## Features
After authenticating with OAuth 2.0 via Flat.io and registering for Community Compose, users can **create a score** by clicking the link on the dashboard. After providing a name & specifying the type, the user will be redirected to a Flat.io interface to write their new piece of music.

On the **dashboard**, users can view all scores they own and collaborate on, listed in descending order of the most recently edited.
![dashboard](https://github.com/zachholcomb/community_compose/blob/e40b04e4c85ccacc0f798c7a1f65365bc91b01c3/dashboard.png)

Users can **edit a score** and **playback** a score after selecting it from the dashboard.
![edit](https://github.com/zachholcomb/community_compose/blob/e40b04e4c85ccacc0f798c7a1f65365bc91b01c3/edit.png)

The **explore** page will show users scores from other users in their geographic area (defined as zip codes within 10 miles of the user's zip code).
![explore](https://github.com/zachholcomb/community_compose/blob/e40b04e4c85ccacc0f798c7a1f65365bc91b01c3/explore.png)

When viewing a score composed by somone else, a user can **request to collaborate**. Once approved by the score's owner, they'll have full edit access to that score.

Users can communicate in-app using the **message** feature.
___
## Technology & Frameworks
Community Compose is built using [Ruby on Rails](https://rubyonrails.org/). It uses a [Sinatra](http://sinatrarb.com/) [microservice](https://github.com/tylerpporter/location_api) to call a [RapidAPI](https://rapidapi.com/) location API to identify users in the same geographic proximity. Users are required to have [Flat.io](https://flat.io/) accounts to login and compose music. [Community Compose](https://community-compose.herokuapp.com/) is hosted on [Heroku](https://www.heroku.com/home) with continuous integration from [TravisCI](https://travis-ci.com/).
___
## Running Locally
To run this project locally, fork, clone, and run `bundle install`.

Install the [Figaro](https://github.com/laserlemon/figaro) gem, which will create a `config/application.yml` file.

This file needs three values:
1. A `CLIENT_ID`
1. A `CLIENT_SECRET`.
1. A `CALLBACK`

The `CLIENT_ID` and `CLIENT_SECRET` must be requested from [Flat.io](https://docs.google.com/forms/d/e/1FAIpQLSeW4sZuUrcBXEtbecJ8xlWL9anbFCsrpHBgc6C48DOE4zuElQ/viewform). As part of this request, you must specify a callback URI (we recommend http://localhost:3000/auth/flat/callback) and the neccessary scopes (we recommend `scores` and `account.public_profile`).
___
## Testing
Code is tested using [RSpec](https://rspec.info/) with [Capybara](https://github.com/teamcapybara/capybara). Test coverage is assessed by [SimpleCov](https://github.com/colszowka/simplecov) at greater than 95%.

Tests are located in the `spec` folder and grouped into `features` and `models`. [Webmock](https://github.com/bblimke/webmock) is used to mock API calls and [FactoryBot](https://github.com/thoughtbot/factory_bot) and [Faker](https://github.com/faker-ruby/faker) are used to generate dynamic test data.

To run tests locally, download this repo and run `bundle exec rspec`.
___
## Roadmap
Future planned development includes greater adoption of Flat.io features, including the ability to fork and comment on scores. Increased in-app messaging, activity feeds, and the ability to see other users on a "Google Maps"-type interface are also planned.
___
## Credits
We could not have built this project without the cooperation of the team at Flat.io, who provided configuration assistance and developed the RESTful API with which we interact.

[Brian Zanti](https://github.com/BrianZanti) was the Turing instructor assigned as our project manager on this project and provided invaluable direction. He, along with the rest of the Turing [instructional staff](https://turing.io/team/instructors/), receive credit for helping us learn the skills applied in this project.
___
## License
This project is licensed under the MIT license - see LICENSE.txt for details.
