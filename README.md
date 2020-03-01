# Apes Scouter 

Apes Scouter is the system used by FRC Team 668, [*The Apes of Wrath*](http://apesofwrath668.org/) for scouting at competition. 

Apes Scouter is written in Ruby using the [Sinatra](http://sinatrarb.com) framework and uses MySQL as the
backing datastore with [Sequel](http://sequel.jeremyevans.net/) as the ORM. Development and production are run on 
UNIX (Mac OS and Ubuntu), but it should work on other Linux distributions as well. No promises that it will work on Windows.

Many parts of this project are based on the [Cheesy Parts](https://github.com/Team254/cheesy-parts) system created by FRC Team 254, *The Cheesy Poofs*.

## Development

Prerequisites:

* Ruby (2.6.1 is the current version we're using for development and production)
* [Bundler](http://gembundler.com)
* MySQL
* RVM (optional)

To run the server locally:

1. Create an empty MySQL database and a user account with full permissions on it.
1. Edit the `db.rb` file with the parameters for your environment.
1. Set the database password as an environment variable (so that it stays out of version control).
1. Run `bundle install`. This will download and install the gems that Apes Scouter depends on.
1. Run `bundle exec rake db:migrate`. This will run the database migrations to create the necessary tables in
MySQL. **Please make sure your database has been created and that it is empty with no tables in it. Otherwise this command will fail**.
1. Run `ruby scouter_server_control.rb <command>` to control the running of the Apes Scouter server, where `<command>` can be one of `start|stop|run|restart`.
1. Go to `http://localhost:9000` in the browser.

Due to the fact that this system was designed to be run locally, there is no authetication for the site. If you are planning on putting this out on the internet I highly recommend some sort of SSO mechanism.

## Deployment to a Production Server

Prerequisites (in addition to those above):

* Apache

1. Setup Apache as the webserver (Nginx should work as well). [Guide](https://www.digitalocean.com/community/tutorials/how-to-install-the-apache-web-server-on-debian-9)
1. Clone this repository in the directory of your choice).
1. Follow the steps above, except for step 7.
1. Open the port where the site is running (9000 if using the default values): `sudo iptables -A INPUT -p tcp --dport 9000 -j ACCEPT`
1. Redirect the public webserver port 80 to 9000: `sudo iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to 9000`
1. Public IP address or domain should now work for your site.

## Contributing

If you have a suggestion for a new feature, create an issue on GitHub or shoot an e-mail to
[cking@apesofwrath668.org](mailto:cking@apesofwrath668.org). Or if you have some Ruby-fu and are feeling adventurous,
fork this project and send a pull request.

