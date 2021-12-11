const express = require('express')
const app = express()
const port = 3000
const axios = require('axios');
var mongo = require('mongodb');
var db = require("./App/Data/mongoDB/db-setup.js");
var googleAPI= require("./App/Data/googleAPI/loadBook.js");
var getBook= require("./App/Service/getBook.js");

app.get('/book', (req, res) => {
	// wenn book nicht in der DB vor kleiner als 30 tagen aktualisiert, aktualisiere db und sende passende Daten Strukturen 
	const books = new getBook()
	books.test().then(
		function(value) {
			console.log("getBook")
			res.send(value)
		},
		function(error) {
			console.log("erros")
			res.send(error)
		}
	)
})

app.get('/connect', (req, res) => {
	db.connectToDB("google").then(
		function(value) {
			res.send("connecting")
			console.log("connectec")
		},
		function(error) {
			res.send("fail")
		}
	);
})

app.get('/close', (req, res) => {
 	db.close()
	res.send('ok')
})
			

app.listen(port, () => {
  console.log(`Example app listening at http://localhost:${port}`)
})