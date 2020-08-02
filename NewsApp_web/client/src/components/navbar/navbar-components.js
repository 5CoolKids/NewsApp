import React, { Component }  from 'react';
import { Navbar, Nav } from 'react-bootstrap';
import { NavLink } from "react-router-dom";
import SearchBox from "../searchbox/searchbox-components";
import BookmarkDisplay from "../icon/bookmark-display-components";
import SourceSwitch from '../source-switch/source-switch-components';
import 'bootstrap/dist/css/bootstrap.min.css';
import './navbar-styles.css';

class NavigationBar extends Component {

    render() {
      return (
        <Navbar expand="lg" variant="dark" className="navbar_background">
            <SearchBox />
            <Navbar.Toggle aria-controls="basic-navbar-nav" />
            <Navbar.Collapse id="basic-navbar-nav">
                <Nav className="mr-auto">
                    <Nav.Link as={ NavLink } exact activeClassName="active" to="/">Home</Nav.Link>
                    <Nav.Link as={ NavLink } to="/world">World</Nav.Link>
                    <Nav.Link as={ NavLink } to="/politics">Politics</Nav.Link>
                    <Nav.Link as={ NavLink } to="/business">Business</Nav.Link>
                    <Nav.Link as={ NavLink } to="/technology">Technology</Nav.Link>
                    <Nav.Link as={ NavLink } to="/sports">Sports</Nav.Link>
                </Nav>

                <BookmarkDisplay />
                <SourceSwitch checked={this.props.checked} 
                              handleSwitchChange={this.props.handleSwitchChange}
                />
            </Navbar.Collapse>
        </Navbar>
      );
    }
}

export default NavigationBar;
