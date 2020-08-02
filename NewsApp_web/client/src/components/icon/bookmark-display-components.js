import React, { Component }  from 'react';
import { withRouter } from "react-router-dom";
import './bookmark-display-styles.css';
import { EmptyBookmark } from "./empty-bookmark-components";
import { FilledBookmark } from "./filled-bookmark-components";

class BookmarkDisplay extends Component {
    constructor() {
        super();
        this.state = {
            display: false
        };
    }

    componentDidMount() {
        if (this.props.location.pathname === "/favorites") {
            this.setState({ display: true });
        }
    }

    handleClick = () => {
        this.props.history.push("/favorites");
        this.setState({ display: true} );
    }

    componentDidUpdate(prevProps) {
        if (prevProps.location.pathname === "/favorites" && this.props.location.pathname !== prevProps.location.pathname) {
            this.setState({ display: false });
        }
    }

    render() {
        return (
            <>
            {this.state.display ? (
                <FilledBookmark/>
            ) : (
                <EmptyBookmark onClick={()=>{this.handleClick()}} />
            )} 
            </>
        );
    }
}
export default withRouter(BookmarkDisplay);
