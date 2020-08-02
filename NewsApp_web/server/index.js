const express = require('express');
var cors = require('cors');
const axios = require("axios");
const app = express();
const PORT = process.env.PORT || 8080;

app.get('/', (req, res) => {
  res.status(200).send('Hello, world!').end();
});

function nullFilter(jsonDoc, type, section) {
  var results = [];
  var cnt = 0;
  for ( var m in jsonDoc ) {
    if (type) {
      if (jsonDoc[m]['webTitle'] != null && jsonDoc[m]['webUrl'] != null &&
          jsonDoc[m]['sectionId'] != null &&
          jsonDoc[m]['webPublicationDate'] != null &&
          jsonDoc[m]['blocks']['body'][0]['bodyTextSummary'] != null &&
          jsonDoc[m]['blocks']['main'] != null &&
          jsonDoc[m]['blocks']['main']['elements'] != null &&
          jsonDoc[m]['blocks']['main']['elements'][0]['assets'].length > 0 &&
          jsonDoc[m]['id'] != null) {
        var len = jsonDoc[m]['blocks']['main']['elements'][0]['assets'].length - 1;
        let result = {
          title: jsonDoc[m]['webTitle'],
          abstract: jsonDoc[m]['blocks']['body'][0]['bodyTextSummary'],
          section: jsonDoc[m]['sectionId'],
          published_date: jsonDoc[m]['webPublicationDate'],
          image_url: jsonDoc[m]['blocks']['main']['elements'][0]['assets'][len]['file'],
          web_url: jsonDoc[m]['webUrl'],
          id: jsonDoc[m]['id']
        }
        results[cnt] = result;
        cnt++; 
      }
    } else {
      if (jsonDoc[m]['multimedia'] != null &&
          jsonDoc[m]['title'] != null &&
          jsonDoc[m]['section'] != null &&
          jsonDoc[m]['subsection'] != null &&
          (jsonDoc[m]['section'] == section || jsonDoc[m]['subsection'] == section || section == 'home') &&
          jsonDoc[m]['published_date'] != null &&
          jsonDoc[m]['abstract'] != null &&
          jsonDoc[m]['url'] != null) {
        let result = {
          title: jsonDoc[m]['title'],
          abstract: jsonDoc[m]['abstract'],
          section: jsonDoc[m]['subsection'] == 'politics' ? jsonDoc[m]['subsection'] : jsonDoc[m]['section'],
          published_date: jsonDoc[m]['published_date'],
          image_url: jsonDoc[m]['multimedia'][0]['url'],
          web_url: jsonDoc[m]['url'],
          id: jsonDoc[m]['url']
        }
        results[cnt] = result;
        cnt++; 
      }
    }
    if (cnt == 10 && section != 'home') return results;
  }
  return results; 
}

app.use(cors());

app.get('/NYTimes_home', async function(req, res) {
  try{
    const response = await axios.get("https://api.nytimes.com/svc/topstories/v2/home.json?api-key=7J1zslJccR5LA5NGVxcypAcarW8sWlAE");
    const data = response.data;
    var results = nullFilter(data["results"], false, 'home');
    res.send({ results });
  } catch (e) {
    console.log(e);
  }
});

app.get('/guardian_home', async function(req, res) {
  try{
    const response = await axios.get("https://content.guardianapis.com/search?api-key=ce41375f-42e9-48fb-b199-8e16fc1d1617&section=(sport|business|technology|politics)&show-blocks=all");
    const data = response.data;
    var results = nullFilter(data['response']['results'], true, 'home');
    res.send({ results });
  } catch (e) {
    console.log(e);
  }
});

app.get('/NYTimes_world', async function(req, res) {
  try{
    const response = await axios.get("https://api.nytimes.com/svc/topstories/v2/world.json?api-key=7J1zslJccR5LA5NGVxcypAcarW8sWlAE");
    const data = response.data;
    var results = nullFilter(data["results"], false, 'world');
    res.send({ results });
  } catch (e) {
    console.log(e);
  }
});

app.get('/guardian_world', async function(req, res) {
  try{
    const response = await axios.get("https://content.guardianapis.com/world?api-key=ce41375f-42e9-48fb-b199-8e16fc1d1617&show-blocks=all");
    const data = response.data;
    var results = nullFilter(data['response']['results'], true, 'world');
    res.send({ results });
  } catch (e) {
    console.log(e);
  }
});

app.get('/NYTimes_politics', async function(req, res) {
  try{
    const response = await axios.get("https://api.nytimes.com/svc/topstories/v2/politics.json?api-key=7J1zslJccR5LA5NGVxcypAcarW8sWlAE");
    const data = response.data;
    var results = nullFilter(data["results"], false, 'politics');
    res.send({ results });
  } catch (e) {
    console.log(e);
  }
});

app.get('/guardian_politics', async function(req, res) {
  try{
    const response = await axios.get("https://content.guardianapis.com/politics?api-key=ce41375f-42e9-48fb-b199-8e16fc1d1617&show-blocks=all");
    const data = response.data;
    var results = nullFilter(data['response']['results'], true, 'politics');
    res.send({ results });
  } catch (e) {
    console.log(e);
  }
});

app.get('/NYTimes_business', async function(req, res) {
  try{
    const response = await axios.get("https://api.nytimes.com/svc/topstories/v2/business.json?api-key=7J1zslJccR5LA5NGVxcypAcarW8sWlAE");
    const data = response.data;
    var results = nullFilter(data["results"], false, 'business');
    res.send({ results });
  } catch (e) {
    console.log(e);
  }
});

app.get('/guardian_business', async function(req, res) {
  try{
    const response = await axios.get("https://content.guardianapis.com/business?api-key=ce41375f-42e9-48fb-b199-8e16fc1d1617&show-blocks=all");
    const data = response.data;
    var results = nullFilter(data['response']['results'], true, 'business');
    res.send({ results });
  } catch (e) {
    console.log(e);
  }
});

app.get('/NYTimes_technology', async function(req, res) {
  try{
    const response = await axios.get("https://api.nytimes.com/svc/topstories/v2/technology.json?api-key=7J1zslJccR5LA5NGVxcypAcarW8sWlAE");
    const data = response.data;
    var results = nullFilter(data["results"], false, 'technology');
    res.send({ results });
  } catch (e) {
    console.log(e);
  }
});

app.get('/guardian_technology', async function(req, res) {
  try{
    const response = await axios.get("https://content.guardianapis.com/technology?api-key=ce41375f-42e9-48fb-b199-8e16fc1d1617&show-blocks=all");
    const data = response.data;
    var results = nullFilter(data['response']['results'], true, 'technology');
    res.send({ results });
  } catch (e) {
    console.log(e);
  }
});

app.get('/NYTimes_sports', async function(req, res) {
  try{
    const response = await axios.get("https://api.nytimes.com/svc/topstories/v2/sports.json?api-key=7J1zslJccR5LA5NGVxcypAcarW8sWlAE");
    const data = response.data;
    var results = nullFilter(data["results"], false, 'sports');
    res.send({ results });
  } catch (e) {
    console.log(e);
  }
});

app.get('/guardian_sports', async function(req, res) {
  try{
    const response = await axios.get("https://content.guardianapis.com/sport?api-key=ce41375f-42e9-48fb-b199-8e16fc1d1617&show-blocks=all");
    const data = response.data;
    var results = nullFilter(data['response']['results'], true, 'sports');
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
  var results = {
    title: jsonDoc['webTitle'],
    image_url: (hasImage) ? jsonDoc['blocks']['main']['elements'][0]['assets'][len]['file'] : "https://assets.guim.co.uk/images/eada8aa27c12fe2d5afa3a89d3fbae0d/fallback-logo.png",
    published_date: jsonDoc['webPublicationDate'].substring(0,10),
    description: jsonDoc['blocks']['body'][0]['bodyTextSummary'],
    web_url: jsonDoc['webUrl'],
    section: jsonDoc['sectionId'],
    id: jsonDoc['id'],
    source: "GUARDIAN"
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

function preprocessNYT(jsonDoc) {
  if (jsonDoc['multimedia'].length > 0) {
    var target = -1;
    for (var m in jsonDoc['multimedia']) {
      if (jsonDoc['multimedia'][m]['width'] > 2000) {
        target = m;
        break;
      }
    }
  }
  var results = {
    title: jsonDoc['headline']['main'],
    image_url: (jsonDoc['multimedia'].length > 0 && target >= 0) ? ("https://www.nytimes.com/" + jsonDoc['multimedia'][target]['url']) : "https://upload.wikimedia.org/wikipedia/commons/0/0e/Nytimes_hq.jpg",
    published_date: jsonDoc['pub_date'].substring(0,10),
    description: jsonDoc['abstract'],
    web_url: jsonDoc['web_url'],
    section: jsonDoc['section_name'],
    id: jsonDoc['web_url'],
    source: "NYTIMES"
  };
  return results;
}

app.get('/nyt_detail_page', async function(req, res) {
  try{
    const response = await axios.get(`https://api.nytimes.com/svc/search/v2/articlesearch.json?fq=web_url:("${req.query.id}")&api-key=7J1zslJccR5LA5NGVxcypAcarW8sWlAE`);
    const data = response.data;
    var results = preprocessNYT(data['response']['docs'][0]);
    res.send({ results });
  } catch (e) {
    console.log(e);
  }
});

function processResults(jsonDoc, type) {
  var results = [];
  if (type) {
    for (var m in jsonDoc) {
      if (jsonDoc[m]['webTitle'] == null || jsonDoc[m]['sectionId'] == null || jsonDoc[m]['webPublicationDate'] == null ||
          jsonDoc[m]['webUrl'] == null || jsonDoc[m]['id'] == null) {
        continue;
      }
      var hasImage = false;
      if (jsonDoc[m]['blocks']['main'] != null && 
          jsonDoc[m]['blocks']['main']['elements'] != null && 
          jsonDoc[m]['blocks']['main']['elements'][0]['assets'].length > 0) {
          hasImage = true;
          var len = jsonDoc[m]['blocks']['main']['elements'][0]['assets'].length - 1;
      }
      var result = {
        title: jsonDoc[m]['webTitle'],
        section: jsonDoc[m]['sectionId'],
        image_url: (hasImage) ? jsonDoc[m]['blocks']['main']['elements'][0]['assets'][len]['file'] : "https://assets.guim.co.uk/images/eada8aa27c12fe2d5afa3a89d3fbae0d/fallback-logo.png",
        published_date: jsonDoc[m]['webPublicationDate'].substring(0,10),
        web_url: jsonDoc[m]['webUrl'],
        id: jsonDoc[m]['id']
      };
      results[m] = result;
    }
  } else {
    for (var m in jsonDoc) {
      if (jsonDoc[m]['headline'] == null || jsonDoc[m]['headline']['main'] == null || jsonDoc[m]['pub_date'] == null ||
          jsonDoc[m]['web_url'] == null) {
            continue;
      }
      if (jsonDoc[m]['multimedia'] != null && jsonDoc[m]['multimedia'].length > 0) {
        var target = -1;
        for (var k in jsonDoc[m]['multimedia']) {
          if (jsonDoc[m]['multimedia'][k]['width'] > 2000) {
            target = k;
            break;
          }
        }
      }
      var result = {
        title: jsonDoc[m]['headline']['main'],
        section: (jsonDoc[m]['news_desk'] != "") ? jsonDoc[m]['news_desk'] : jsonDoc[m]['section_name'] ,
        image_url: (jsonDoc[m]['multimedia'].length > 0 && target >= 0) ? ("https://www.nytimes.com/" + jsonDoc[m]['multimedia'][target]['url']) : "https://upload.wikimedia.org/wikipedia/commons/0/0e/Nytimes_hq.jpg",
        published_date: jsonDoc[m]['pub_date'].substring(0,10),
        web_url: jsonDoc[m]['web_url'],
        id: jsonDoc[m]['web_url']
      };
      results[m] = result;
    }
  }
  return results;
}

app.get('/search_keyword_guar', async function(req, res) {
  try{
    const response = await axios.get(`https://content.guardianapis.com/search?q=${req.query.q}&api-key=ce41375f-42e9-48fb-b199-8e16fc1d1617&show-blocks=all`);
    const data = response.data;
    var results = processResults(data['response']['results'], true);
    res.send({ results });
  } catch (e) {
    console.log(e);
  }
});

app.get('/search_keyword_nyt', async function(req, res) {
  try{
    const response = await axios.get(`https://api.nytimes.com/svc/search/v2/articlesearch.json?q=${req.query.q}&api-key=7J1zslJccR5LA5NGVxcypAcarW8sWlAE`);
    const data = response.data;
    var results = processResults(data['response']['docs'], false);
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
