# Phone Your Rep API

WIP.
The companion to [the Phone Your Rep frontend](https://github.com/Flaque/phone-your-rep/tree/gh-pages).

# Installation

Be sure to use Ruby 2.3.3.

```
rbenv install 2.3.3 or rvm install 2.3.3
brew install postgres
brew install postgis
```

Or download the [Heroku PostgreSQL app](https://postgresapp.com/) and forgo the brew postgres and postgis install. This is by far the easiest route.

Then

```
gem install rails --no-ri --no-rdoc
gem install bundler
bundle install
bundle exec rake db:create
bundle exec rake db:gis:setup
bundle exec rake db:migrate
```
Seeding the database will automatically Geocode ~1900 office locations. You will need to configure your Google API key, enabled to use the geocode API, as your `ENV["GOOGLE_API_KEY"]`.

You can access the API without a key by commenting out every line in `config/initializers/geocoder.rb`. Keep in mind you might have a lower quota this way.

If you don't want to geocode all of the offices, comment out these lines in office_location.rb
```ruby
before_create :geocode
before_save   :geocode, if: :needs_geocoding?
```
then
```
bundle exec rake db:seed
```
When you're done seeding the basic data, you need to load the shapefiles for districts and states. Run
```
ruby lib/shapefiles.rb
```
Then
```
rails s
```

This is deployed on Heroku. Deploying a geo-spatially enabled database to Heroku can be a bit of a challenge. Docs for that will come soon.

#Usage
An example request to the API looks like this:
```
https://phone-your-rep.herokuapp.com/reps?lat=42.3134848&long=-71.2072321&state=Massachusetts
```

And here is the response:
```json
[
  {
    "bioguide_id": "W000817",
    "official_full": "Elizabeth Warren",
    "state": "MA",
    "district": null,
    "role": "United States Senate",
    "party": "Democrat",
    "senate_class": "01",
    "last": "Warren",
    "first": "Elizabeth",
    "middle": null,
    "nickname": null,
    "suffix": null,
    "contact_form": "http://www.warren.senate.gov/?p=email_senator#thisForm",
    "url": "http://www.warren.senate.gov",
    "photo": "https://theunitedstates.io/images/congress/450x550/W000817.jpg",
    "twitter": "SenWarren",
    "facebook": "senatorelizabethwarren",
    "youtube": "senelizabethwarren",
    "instagram": null,
    "googleplus": null,
    "twitter_id": "970207298",
    "facebook_id": "131559043673264",
    "youtube_id": "UCTH9zV8Imw09J5bOoTR18_A",
    "instagram_id": null,
    "office_locations": [
      {
        "type": "district",
        "building": "2400 JFK Federal Building",
        "address": "15 New Sudbury St",
        "suite": "",
        "city": "Boston",
        "state": "MA",
        "zip": "02203-0002",
        "phone": "617-565-3170",
        "fax": "",
        "hours": "",
        "latitude": 42.3604802,
        "longitude": -71.0590624,
        "v_card_link": "https://phone-your-rep.herokuapp.com/v_cards/2062",
        "qr_code_link": "https://phone-your-rep.herokuapp.com/media/W1siZiIsIjIwMTcvMDEvMTMvN3lzaGx6YWF6NV9FbGl6YWJldGhfV2FycmVuXzIwNjIucG5nIl1d/Elizabeth%20Warren_2062.png?sha=94f6c72955808582"
      },
      {
        "type": "district",
        "building": "",
        "address": "1550 Main St",
        "suite": "Suite 406",
        "city": "Springfield",
        "state": "MA",
        "zip": "01103-1422",
        "phone": "413-788-2690",
        "fax": "",
        "hours": "",
        "latitude": 42.105218,
        "longitude": -72.5929401,
        "v_card_link": "https://phone-your-rep.herokuapp.com/v_cards/2063",
        "qr_code_link": "https://phone-your-rep.herokuapp.com/media/W1siZiIsIjIwMTcvMDEvMTMvOGZ3MXkweDlzZF9FbGl6YWJldGhfV2FycmVuXzIwNjMucG5nIl1d/Elizabeth%20Warren_2063.png?sha=aef00bb7ca9863b2"
      },
      {
        "type": "capitol",
        "building": null,
        "address": "317 Hart Senate Office Building",
        "suite": null,
        "city": "Washington",
        "state": "DC",
        "zip": "20510",
        "phone": "202-224-4543",
        "fax": null,
        "hours": null,
        "latitude": 38.8928318,
        "longitude": -77.0043625,
        "v_card_link": "https://phone-your-rep.herokuapp.com/v_cards/841",
        "qr_code_link": "https://phone-your-rep.herokuapp.com/media/W1siZiIsIjIwMTcvMDEvMTMvNnAwcW1wdTh0OV9FbGl6YWJldGhfV2FycmVuXzg0MS5wbmciXV0/Elizabeth%20Warren_841.png?sha=45538bb7e2e64080"
      }
    ]
  },
  {
    "bioguide_id": "K000379",
    "official_full": "Joseph P. Kennedy III",
    "state": "MA",
    "district": "04",
    "role": "United States Representative",
    "party": "Democrat",
    "senate_class": null,
    "last": "Kennedy",
    "first": "Joseph",
    "middle": "P.",
    "nickname": null,
    "suffix": "III",
    "contact_form": null,
    "url": "http://kennedy.house.gov",
    "photo": "https://theunitedstates.io/images/congress/450x550/K000379.jpg",
    "twitter": "RepJoeKennedy",
    "facebook": "301936109927957",
    "youtube": null,
    "instagram": "repkennedy",
    "googleplus": null,
    "twitter_id": "1055907624",
    "facebook_id": "301936109927957",
    "youtube_id": "UCgfHlaGqxD8p-2V_YlNIqrA",
    "instagram_id": "1328567154",
    "office_locations": [
      {
        "type": "district",
        "building": "",
        "address": "29 Crafts St",
        "suite": "Suite 375",
        "city": "Newton",
        "state": "MA",
        "zip": "02458-1275",
        "phone": "617-332-3333",
        "fax": "617-332-3308",
        "hours": "M-F 9-5:30PM",
        "latitude": 42.3503838,
        "longitude": -71.1864397,
        "v_card_link": "https://phone-your-rep.herokuapp.com/v_cards/1368",
        "qr_code_link": "https://phone-your-rep.herokuapp.com/media/W1siZiIsIjIwMTcvMDEvMTMvNHg5cml0OXpoY19Kb3NlcGhfUC5fS2VubmVkeV9JSUlfMTM2OC5wbmciXV0/Joseph%20P.%20Kennedy%20III_1368.png?sha=f2d0f3b0075dbe33"
      },
      {
        "type": "district",
        "building": "",
        "address": "8 N Main St",
        "suite": "Suite 200",
        "city": "Attleboro",
        "state": "MA",
        "zip": "02703-2282",
        "phone": "508-431-1110",
        "fax": "508-431-1101",
        "hours": "M-F 9-5:30PM",
        "latitude": 41.925494,
        "longitude": -71.2992993,
        "v_card_link": "https://phone-your-rep.herokuapp.com/v_cards/1367",
        "qr_code_link": "https://phone-your-rep.herokuapp.com/media/W1siZiIsIjIwMTcvMDEvMTMvNzQ3d3k3ejZveV9Kb3NlcGhfUC5fS2VubmVkeV9JSUlfMTM2Ny5wbmciXV0/Joseph%20P.%20Kennedy%20III_1367.png?sha=bce3ee4e0eb879eb"
      },
      {
        "type": "capitol",
        "building": null,
        "address": "434 Cannon HOB",
        "suite": null,
        "city": "Washington",
        "state": "DC",
        "zip": "20515-2104",
        "phone": "202-225-5931",
        "fax": null,
        "hours": null,
        "latitude": 38.8870943,
        "longitude": -77.0082254,
        "v_card_link": "https://phone-your-rep.herokuapp.com/v_cards/842",
        "qr_code_link": "https://phone-your-rep.herokuapp.com/media/W1siZiIsIjIwMTcvMDEvMTMvMmxrMTdxeWI4Ml9Kb3NlcGhfUC5fS2VubmVkeV9JSUlfODQyLnBuZyJdXQ/Joseph%20P.%20Kennedy%20III_842.png?sha=d8bdecdafaff4c95"
      }
    ]
  },
  {
    "bioguide_id": "M000133",
    "official_full": "Edward J. Markey",
    "state": "MA",
    "district": null,
    "role": "United States Senate",
    "party": "Democrat",
    "senate_class": "02",
    "last": "Markey",
    "first": "Edward",
    "middle": "J.",
    "nickname": "Ed",
    "suffix": null,
    "contact_form": "http://www.markey.senate.gov/contact",
    "url": "http://www.markey.senate.gov",
    "photo": "https://theunitedstates.io/images/congress/450x550/M000133.jpg",
    "twitter": "SenMarkey",
    "facebook": "EdJMarkey",
    "youtube": "RepMarkey",
    "instagram": null,
    "googleplus": null,
    "twitter_id": "3047090620",
    "facebook_id": "6846731378",
    "youtube_id": "UCT1ujew5yQy2uMhGrjiKHoA",
    "instagram_id": null,
    "office_locations": [
      {
        "type": "district",
        "building": "975 JFK Federal Building",
        "address": "15 New Sudbury St",
        "suite": "",
        "city": "Boston",
        "state": "MA",
        "zip": "02203-0002",
        "phone": "617-565-8519",
        "fax": "",
        "hours": "",
        "latitude": 42.3604802,
        "longitude": -71.0590624,
        "v_card_link": "https://phone-your-rep.herokuapp.com/v_cards/2064",
        "qr_code_link": "https://phone-your-rep.herokuapp.com/media/W1siZiIsIjIwMTcvMDEvMTMvN2l5N3ltZDY4bF9FZHdhcmRfSi5fTWFya2V5XzIwNjQucG5nIl1d/Edward%20J.%20Markey_2064.png?sha=6bed90c3afa8310c"
      },
      {
        "type": "district",
        "building": "",
        "address": "222 Milliken Blvd",
        "suite": "suite 312",
        "city": "Fall River",
        "state": "MA",
        "zip": "02721-1623",
        "phone": "508-677-0523",
        "fax": "",
        "hours": "",
        "latitude": 41.6746583,
        "longitude": -71.150793,
        "v_card_link": "https://phone-your-rep.herokuapp.com/v_cards/2065",
        "qr_code_link": "https://phone-your-rep.herokuapp.com/media/W1siZiIsIjIwMTcvMDEvMTMvNHc2NTV6cWtocF9FZHdhcmRfSi5fTWFya2V5XzIwNjUucG5nIl1d/Edward%20J.%20Markey_2065.png?sha=98e8ed1adcceb949"
      },
      {
        "type": "district",
        "building": "",
        "address": "1550 Main St",
        "suite": "4th Floor",
        "city": "Springfield",
        "state": "MA",
        "zip": "01103-1422",
        "phone": "413-785-4610",
        "fax": "",
        "hours": "",
        "latitude": 42.105218,
        "longitude": -72.5929401,
        "v_card_link": "https://phone-your-rep.herokuapp.com/v_cards/2066",
        "qr_code_link": "https://phone-your-rep.herokuapp.com/media/W1siZiIsIjIwMTcvMDEvMTMvMXdoNzlpMWgzcl9FZHdhcmRfSi5fTWFya2V5XzIwNjYucG5nIl1d/Edward%20J.%20Markey_2066.png?sha=7c02514e33b626e1"
      },
      {
        "type": "capitol",
        "building": null,
        "address": "255 Dirksen Senate Office Building",
        "suite": null,
        "city": "Washington",
        "state": "DC",
        "zip": "20510",
        "phone": "202-224-2742",
        "fax": null,
        "hours": null,
        "latitude": 38.8928318,
        "longitude": -77.0043625,
        "v_card_link": "https://phone-your-rep.herokuapp.com/v_cards/674",
        "qr_code_link": "https://phone-your-rep.herokuapp.com/media/W1siZiIsIjIwMTcvMDEvMTMvNGhjeHlhbWd3cF9FZHdhcmRfSi5fTWFya2V5XzY3NC5wbmciXV0/Edward%20J.%20Markey_674.png?sha=be737915c763d7ff"
      }
    ]
  }
]
```