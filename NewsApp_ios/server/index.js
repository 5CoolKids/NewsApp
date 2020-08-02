const express = require('express');
var cors = require('cors');
const axios = require("axios");
const app = express();
var moment = require("moment");
const googleTrends = require('google-trends-api');
const PORT = process.env.PORT || 8080;

app.use(cors());

function organizeData(jsonDoc) {
    var results = [];
    var cnt = 0;
    for ( var m in jsonDoc ) {
        if (jsonDoc[m]['webTitle'] != null &&
            jsonDoc[m]['webPublicationDate'] != null &&
            jsonDoc[m]['sectionId'] != null &&
            jsonDoc[m]['id'] != null &&
            jsonDoc[m]['fields'] != null &&
            jsonDoc[m]['webUrl'] != null) {
            var now = moment();
            var then = jsonDoc[m]['webPublicationDate'];
            var ms = moment.duration(now.diff(then));
            var publishTime = "";
            if (ms.asSeconds() < 60) {
                publishTime = parseInt(ms.asSeconds(), 10) + "s ago";
            } else if (ms.asMinutes() < 60) {
                publishTime = parseInt(ms.asMinutes(), 10) + "m ago";
            } else {
                publishTime = parseInt(ms.asHours(), 10) + "h ago";
            }

            let noImg = false;
            if (jsonDoc[m]['fields'] == null || jsonDoc[m]['fields']['thumbnail'] == null) {
                noImg = true;
            }

            var result = {
                title: jsonDoc[m]['webTitle'],
                time: publishTime,
                section: jsonDoc[m]['sectionId'],
                id: jsonDoc[m]['id'],
                image: (noImg) ? "null" : jsonDoc[m]['fields']['thumbnail'],
                webUrl: jsonDoc[m]['webUrl'],
                date: moment(then).format("D MMM YYYY")
            };
            results[cnt] = result;
            cnt++; 
        }
    }
    return results;
}

app.get('/home', async function(req, res) {
    try{
      const response = await axios.get("https://content.guardianapis.com/search?orderby=newest&show-fields=starRating,headline,thumbnail,short-url&api-key=ce41375f-42e9-48fb-b199-8e16fc1d1617");
      const data = response.data;
      var results = organizeData(data['response']['results']);
      res.send({ results });
    } catch (e) {
      console.log(e);
    }
});

function organizeSectionData(jsonDoc) {
    var results = [];
    var cnt = 0;
    for ( var m in jsonDoc ) {
        if (jsonDoc[m]['webTitle'] != null &&
            jsonDoc[m]['webPublicationDate'] != null &&
            jsonDoc[m]['sectionName'] != null &&
            jsonDoc[m]['id'] != null &&
            jsonDoc[m]['webUrl'] != null) {
            var now = moment();
            var then = jsonDoc[m]['webPublicationDate'];
            var ms = moment.duration(now.diff(then));
            var publishTime = "";
            if (ms.asSeconds() < 60) {
                publishTime = parseInt(ms.asSeconds(), 10) + "s ago";
            } else if (ms.asMinutes() < 60) {
                publishTime = parseInt(ms.asMinutes(), 10) + "m ago";
            } else {
                publishTime = parseInt(ms.asHours(), 10) + "h ago";
            }

            let hasImage = false;
            let index = 0;
            if (jsonDoc[m]['blocks']['main'] != null && 
                jsonDoc[m]['blocks']['main']['elements'] != null && 
                jsonDoc[m]['blocks']['main']['elements'][0]['assets'].length > 0) {
                hasImage = true;
                index = jsonDoc[m]['blocks']['main']['elements'][0]['assets'].length - 1;
            }

            var result = {
                title: jsonDoc[m]['webTitle'],
                time: publishTime,
                section: jsonDoc[m]['sectionName'],
                id: jsonDoc[m]['id'],
                image: (!hasImage) ? "null" : jsonDoc[m]['blocks']['main']['elements'][0]['assets'][index]['file'],
                webUrl: jsonDoc[m]['webUrl'],
                date: moment(then).format("D MMM YYYY")
            };
            results[cnt] = result;
            cnt++; 
        }
    }
    return results;
}

app.get('/world', async function(req, res) {
    try{
      const response = await axios.get("https://content.guardianapis.com/world?api-key=ce41375f-42e9-48fb-b199-8e16fc1d1617&show-blocks=all");
      const data = response.data;
      var results = organizeSectionData(data['response']['results']);
      res.send({ results });
    } catch (e) {
      console.log(e);
    }
});

app.get('/business', async function(req, res) {
    try{
      const response = await axios.get("https://content.guardianapis.com/business?api-key=ce41375f-42e9-48fb-b199-8e16fc1d1617&show-blocks=all");
      const data = response.data;
      var results = organizeSectionData(data['response']['results']);
      res.send({ results });
    } catch (e) {
      console.log(e);
    }
});

app.get('/politics', async function(req, res) {
    try{
      const response = await axios.get("https://content.guardianapis.com/politics?api-key=ce41375f-42e9-48fb-b199-8e16fc1d1617&show-blocks=all");
      const data = response.data;
      var results = organizeSectionData(data['response']['results']);
      res.send({ results });
    } catch (e) {
      console.log(e);
    }
});

app.get('/sports', async function(req, res) {
    try{
      const response = await axios.get("https://content.guardianapis.com/sport?api-key=ce41375f-42e9-48fb-b199-8e16fc1d1617&show-blocks=all");
      const data = response.data;
      var results = organizeSectionData(data['response']['results']);
      res.send({ results });
    } catch (e) {
      console.log(e);
    }
});

app.get('/technology', async function(req, res) {
    try{
      const response = await axios.get("https://content.guardianapis.com/technology?api-key=ce41375f-42e9-48fb-b199-8e16fc1d1617&show-blocks=all");
      const data = response.data;
      var results = organizeSectionData(data['response']['results']);
      res.send({ results });
    } catch (e) {
      console.log(e);
    }
});

app.get('/science', async function(req, res) {
    try{
      const response = await axios.get("https://content.guardianapis.com/science?api-key=ce41375f-42e9-48fb-b199-8e16fc1d1617&show-blocks=all");
      const data = response.data;
      var results = organizeSectionData(data['response']['results']);
      res.send({ results });
    } catch (e) {
      console.log(e);
    }
});

app.get('/search_keyword', async function(req, res) {
    try{
        googleTrends.interestOverTime({keyword: `${req.query.q}`, startTime: new Date('2019-06-01')}, function(err, results) {
            if (err) console.log('oh no error!', err);
            else {
                var jsonRes = JSON.parse(results)["default"]["timelineData"];
                var finalRes = [];
                var count = 0
                for (var m in jsonRes) {
                    var result = {
                        value: jsonRes[m]["value"][0]
                    };
                    finalRes[count] = result
                    count++;
                }
                res.send({ finalRes });
            }
        });
    } catch (e) {
      console.log(e);
    }
});

app.get('/search_news', async function(req, res) {
    try{
      const response = await axios.get(`https://content.guardianapis.com/search?q=${req.query.q}&api-key=ce41375f-42e9-48fb-b199-8e16fc1d1617&show-blocks=all`);
      const data = response.data;
      var results = organizeSectionData(data['response']['results']);
      res.send({ results });
    } catch (e) {
      console.log(e);
    }
  });

function preprocessGuardian(jsonDoc) {
    var hasImage = false;
    if (jsonDoc['blocks']['main'] != null && 
        jsonDoc['blocks']['main']['elements'] != null && 
        jsonDoc['blocks']['main']['elements'][0]['assets'].length > 0) {
        hasImage = true;
        var len = jsonDoc['blocks']['main']['elements'][0]['assets'].length - 1;
    }
    var description = "";
    for (var i in jsonDoc['blocks']['body']) {
        description += jsonDoc['blocks']['body'][i]['bodyHtml'];
    }
    var results = {
        title: jsonDoc['webTitle'],
        image: (hasImage) ? jsonDoc['blocks']['main']['elements'][0]['assets'][len]['file'] : "null",
        date: moment(jsonDoc['webPublicationDate']).format("D MMM YYYY"),
        content: description,
        webUrl: jsonDoc['webUrl'],
        section: jsonDoc['sectionName']
    };
    return results;
}

app.get('/guardian_detail_page', async function(req, res) {
    try{
        const response = await axios.get(`https://content.guardianapis.com/${req.query.id}?api-key=ce41375f-42e9-48fb-b199-8e16fc1d1617&show-blocks=all`);
        const data = response.data;
        var results = preprocessGuardian(data['response']['content']);
        res.send({ results });
    } catch (e) {
        console.log(e);
    }
});



app.listen(PORT, () => {
    console.log(`App listening on port ${PORT}`);
    console.log('Press Ctrl+C to quit.');
  });
  
module.exports = app;