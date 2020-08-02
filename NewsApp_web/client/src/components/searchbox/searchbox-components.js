import React, { Component }  from 'react';
import { withRouter } from "react-router-dom";
import AsyncSelect from 'react-select/lib/Async';
import _ from 'lodash';
import axios from 'axios';
import './searchbox-styles.css';

class SearchBox extends Component {
    constructor() {
        super();
        this.state = {
            suggestions: [],
            selectedOption: ""
        };
    }

    async loadOptions(query, callback) {
        try{
            await axios.get('https://api.cognitive.microsoft.com/bing/v7.0/suggestions?q=' + query,
                {
                    headers: {
                        "Ocp-Apim-Subscription-Key": 'd5ad46e790e843e1bc8e69ea73a2cbaf'
                    }
                })
                .then((response) => {
                    const items = response.data.suggestionGroups[0].searchSuggestions;
                    let options = items.map(function(item) {
                        return {
                            value: item.displayText,
                            label: item.query
                        };
                    });
                    callback(options);
                    this.setState({suggestions: options});
            });
        } catch (error) {
            this.setState({ error });
        } 
    }

    handleSelectChange = (option) => {
        this.setState({selectedOption: option});
        this.props.history.push(`/search?q=${option.label}`);    
    }

    componentDidUpdate(prevProps) {
        if (prevProps.location.pathname === "/search" && this.props.location.pathname !== prevProps.location.pathname) {
            this.setState({ selectedOption: "" });
        }
    }

    render() {
        return (
            <div className="select_container">
                <AsyncSelect
                loadOptions={_.debounce((query, callback) => this.loadOptions(query, callback), 1010)} 
                options={this.state.suggestions}
                value={this.state.selectedOption}
                placeholder="Enter keyword .."
                onChange={this.handleSelectChange}
                />
            </div>
        );
    }
}

export default withRouter(SearchBox);
