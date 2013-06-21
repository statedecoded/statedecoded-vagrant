# State Decoded  / Vagrant Configuration

A Vagrant configuration for State Decoded, to make it easy to get started.

### Install Vagrant

Installing Vagrant is very simple—simply [follow the instructions](http://docs.vagrantup.com/v2/installation/).

### Start the Vagrant Machine

* Download a copy of this repository.
* Change into the directory that contains the repository.
* Run the command `vagrant up`

### Download Sample XML

To have some data to play with, download [the Code of Virginia XML](http://vacode.org/downloads/code.xml.zip) and unzip it, putting its contents into `/statedecoded/htdocs/admin/xml/`.

### Configure The State Decoded

We're able to skip most of [the configuration steps for The State Decoded](/statedecoded/statedecoded/wiki/Installation-Instructions), but a few are still necessary:

* SSH into your Vagrant instance (`vagrant ssh`).
* Create a new MySQL database (e.g., `mysqladmin create statedecoded`).
* Load `statedecoded.sql` into MySQL (e.g., `cd /vagrant/statedecoded; mysql statedecoded < statedecoded.sql`).
* Manually add a record to the MySQL table named `editions` for the instance of the legal code that you intend to import into The State Decoded. (e.g., `mysql -u root -p statedecoded`, then `INSERT INTO editions SET year=2012;`)

### Run the Parser

[Load the parser](http://localhost:4567/admin/parser.php) in your brower and click the "Parse" button.

The parser will chew on the code for a while—depending on your computer's resources, this might take 5–10 minutes. When it's finished, [start browsing the site](http://localhost:4567/).
