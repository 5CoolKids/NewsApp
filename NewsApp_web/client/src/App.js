import React, { Component }from 'react';
import { BrowserRouter as Router, Switch, Route } from 'react-router-dom';
import NavigationBar from './components/navbar/navbar-components.js';
import Home from './components/Home.js';
import World from './components/World.js';
import Politics from './components/Politics.js';
import Business from './components/Business.js';
import Technology from './components/Technology.js';
import Sports from './components/Sports.js';
import Detail from './components/Detail.js';
import SearchResults from './components/SearchResults.js';
import Favorites from './components/Favorites.js';
import { useLocation } from "react-router-dom";

class App extends Component {
  constructor() {
    super();
    this.state = {
        checked: true
    };
  } 

  componentDidMount() {
    var oldItems = localStorage.getItem('source') || "";
    if (oldItems === "true" || oldItems === "") {
      this.setState({ checked: true });
      localStorage.setItem('source', "true");
    } else {
      this.setState({ checked: false });
      localStorage.setItem('source', "false");
    }
  }

  handleSwitchChange = () => { 
    var oldItems = localStorage.getItem('source');
    var updatedItems = (oldItems === "true" ) ? "false" : "true";
    localStorage.setItem('source', updatedItems);
    window.location.reload(true);
  }

  render() {
    const len = (JSON.parse(localStorage.getItem('itemsArray')) != null) ? JSON.parse(localStorage.getItem('itemsArray')).length : 0;
    return (
      <Router>
        <div>
          <NavigationBar handleSwitchChange={this.handleSwitchChange} checked={this.state.checked}/>
          
          <Switch>
              <Route exact path='/' component={() => <Home checked={this.state.checked}/>}/>
              <Route path='/World' component={() => <World checked={this.state.checked}/>}/>
              <Route path='/Politics' component={() => <Politics checked={this.state.checked}/>}/>
              <Route path='/Business' component={() => <Business checked={this.state.checked}/>}/>
              <Route path='/Technology' component={() => <Technology checked={this.state.checked}/>}/>
              <Route path='/Sports' component={() => <Sports checked={this.state.checked}/>}/>
              <Route path='/article' component={() => <Detail id={new URLSearchParams(useLocation().search).get("id")}/>}/>
              <Route path='/search' component={() => <SearchResults keyword={new URLSearchParams(useLocation().search).get("q")}/>}/>
              <Route path='/favorites' component={() => <Favorites size={len}/>}/>
          </Switch>
        </div>
      </Router>
    );
  }
}

export default App;
