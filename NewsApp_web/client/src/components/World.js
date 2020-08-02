import React, { Component } from 'react';
import axios from 'axios';
import NewsList from './news-list/news-list-components';
import { Loading } from './loader/loader-components';

class World extends Component {
    _isMounted = false;
    constructor() {
        super();
        this.state = {
            news: [],
            loading: true
        };
    }

    async getNews(url) {
      this._isMounted = true;
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

    componentDidMount() {
      var url = '';
      if (this.props.checked) {
        url = 'https://newsapp-backend-yyc.appspot.com/guardian_world';
      } else {
        url = 'https://newsapp-backend-yyc.appspot.com/NYTimes_world';
      }
      this.getNews(url);
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
          <NewsList news={this.state.news} />
        </div>
      );
    }
  }
}

export default World;