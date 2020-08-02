import React, { Component } from 'react';
import axios from 'axios';
import NewsDetail from './news-detail/news-detail-components';
import PageWithComments from './comment/comment-components'
import { Loading } from './loader/loader-components';

class Detail extends Component {
  _isMounted = false;

  constructor() {
    super();
    this.state = {
        news: {},
        loading: true
    };
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

  componentDidMount() {
    this._isMounted = true;

    var url = '';
    if (this.props.id.substring(0, 4) === 'http') {
      url = `https://newsapp-backend-yyc.appspot.com/nyt_detail_page?id=${this.props.id}`;
    } else {
      url = `https://newsapp-backend-yyc.appspot.com/guardian_detail_page?id=${this.props.id}`;
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
        <>
        <NewsDetail news={ this.state.news }/>
        <div style={{margin: "0 15px 0 15px"}}>
          <PageWithComments id={this.props.id}/>
        </div>
        </>
      ); 
    }
  }
}
    
export default Detail;