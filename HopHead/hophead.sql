DROP TABLE IF EXISTS "beers";
CREATE TABLE "beers" ("id" INTEGER PRIMARY KEY  AUTOINCREMENT  NOT NULL , "beerName" VARCHAR NOT NULL , "breweryName" VARCHAR, "breweryLocation" VARCHAR, "abv" INTEGER, "ibu" INTEGER, "category" VARCHAR NOT NULL , "style" VARCHAR, "favorites" INTEGER NOT NULL , "notes" VARCHAR);
