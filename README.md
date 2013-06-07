# State Decoded  / Vagrant Configuration

A Vagrant configuration for State Decoded, to make it easy to get started.

### Install Vagrant

Installing Vagrant is very simple—simply [follow the instructions](http://docs.vagrantup.com/v2/installation/).

### Set up Your Vagrant Box

Download your virtual machine:

```
$ vagrant box add statedecoded statedecoded.box
$ vagrant init
```

Replace Vagrant's default config files:

* Copy [the provided Vagrantfile](blob/master/Vagrantfile) into your Vagrant directory.
* Copy [the provided bootstrap.sh]blob/master/bootstrap.sh) into your Vagrant directory.

Start the Vagrant box:

```
$ vagrant up
```

### Download The State Decoded

* Grab either [the bleeding-edge development version](https://github.com/statedecoded/statedecoded/archive/master.zip) or [the latest numbered release](https://github.com/statedecoded/statedecoded/tags) and unzip it within `/vagrant/`, as `/vagrant/statedecoded/`.
* Delete `statedecoded/includes/config-sample.inc.php` and replace it with the `config.inc.php` provided with this Vagrant quick start guide. Rename `statedecoded/includes/class.State-sample.inc.php` to `class.Virginia.inc.php`.

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
