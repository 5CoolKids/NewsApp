import React, { Component } from 'react';
import axios from 'axios';
import NewsList from './news-list/news-list-components';
import { Loading } from './loader/loader-components';

class Home extends Component {
  _isMounted = false;
  constructor() {
    super();
    this.state = {
      news: [],
      loading: true
    };
  }
  
  componentDidMount() {
    this._isMounted = true;
    var url = '';
    if (this.props.checked) {
      url = 'localhost:8080/guardian_home';
    } else {
      url = 'localhost:8080/NYTimes_home';
    }
    this.getNews(url);
  }

  async getNews(url) {
    const response = await axios.get(url);
    try {
      if (this._isMounted) {
        this.setState({
          news: response.data.results,
          loading: false
        });
      }
    } catch (error) {
      this.setState({ error });
    }
  }

  componentWillUnmount() {
    this._isMounted = false;
  }
    
  render() {
    if (this.state.loading) {
      return (
        <Loading loading={this.state.loading}/>
      );
    } else {
      return (
        <div>
          <NewsList news={this.state.news}/> 
        </div>
      );
    }
  }
}

export default Home;