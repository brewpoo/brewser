brewser
=======

Reason for fork
---------------
I am using this to help me turn Beer XML files into ruby objects and JSON. Some XML parsing 
methods were not working for me, so I made my own fork of the repo to fix it.

Original Contributor's Notes:

Brewser is a ruby library for parsing and generating serialized brewing data

Currently brewser is early in development but will eventually support the following input formats:
* [BeerXML (v1, v2)](http://beerxml.org)
* BrewSON - Brewser Recipe and Batches in JSON
* [ProMash (.rec and text exports)](http://www.promash.com)

Input files are deserialized into a common object model for consumption.  Brewser supports these output formats:
* BeerXML
* BrewSON

# Status

Currently, brewser can import BeerXML v1, ProMash .rec files as well as ProMash Recipe Reports (Text files).  Each
file format contains different levels of details.  As a result there is no uniformity amongst the various format.  BeerXML v1
is at this time the most complete serialized format.  

# Installation

Just add brewser to your Gemfile

    gem 'brewser'
  
and run bundle install

# Using 

Brewser will attempt to identify the input file by content and delegate processing to the correct engine.  ProMash .rec files are not easy to identify, as a result this is the last engine attempted and it will try to decode any file you give it.  This is likely to result in garbage if the file is not a properly formatted .rec file.

To load a BeerXML v1 file:

    Brewser.parse(File.read("samples/beerxmlv1/recipes.xml"))
    
This will return an array of BeerXML::Recipe objects.
