import React, { Component } from 'react';
import axios from 'axios';
import ResultCard from './resultcard/result-card-components';

class SearchResults extends Component {
  _isMounted = false;

  constructor() {
    super();
    this.state = { 
      results_nyt: [],
      results_guar: []
    };
  }

  async getResultsGuar() {
    const response = await axios.get(`https://newsapp-backend-yyc.appspot.com/search_keyword_guar?q=${this.props.keyword}`);
    try {
      if (this._isMounted) {
        this.setState({
            results_guar: response.data.results
        });
      }
    } catch (error) {
        this.setState({ error });
    }
  }

  async getResultsNYT() {
    const response = await axios.get(`https://newsapp-backend-yyc.appspot.com/search_keyword_nyt?q=${this.props.keyword}`);
    try {
      if (this._isMounted) {
        this.setState({
            results_nyt: response.data.results
        });
      }
    } catch (error) {
        this.setState({ error });
    }
  }
  
  componentDidMount() {
    this._isMounted = true;
    this.getResultsGuar();
    this.getResultsNYT();
  }

  componentWillUnmount() {
    this._isMounted = false;
  }
  
  componentDidUpdate(prevProps) {
    if (prevProps.keyword !== this.props.keyword) {
      this.getResultsGuar();
      this.getResultsNYT();
    }
  }
    
  render() {
      return (
        <>
        <ResultCard news1={this.state.results_nyt} news2={this.state.results_guar}/>
        </>
      );
  }
}

export default SearchResults;
