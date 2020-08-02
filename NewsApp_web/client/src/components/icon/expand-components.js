import React, { Component }  from 'react';
import { FaAngleDown, FaAngleUp } from "react-icons/fa";
import "./expand-styles.css";
import { animateScroll as scroll } from 'react-scroll'

class ExpandContent extends Component {
    constructor() {
        super();
        this.state = {
            expanded: false
        };
    } 

    handleScrollUp = () => {
        scroll.scrollToTop();
        this.setState({ expanded: false });
    }

    handleScrollDown = () => {
        this.setState({ expanded: true });
        scroll.scrollMore(500);
    }

    render() {
        return(
            <>
            {this.state.expanded ? (
                <>
                <p>{this.props.after}</p>
                <FaAngleUp className="arrow_icon" onClick={() => {this.handleScrollUp()}}/>
                </>
            ) : (
                <>
                <p>{this.props.before}</p>
                <FaAngleDown className="arrow_icon" onClick={() => {this.handleScrollDown()}}/>
                </>
            )}
            </>
        );
    }
}

export default ExpandContent;
