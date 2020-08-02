import React, { Component } from 'react';
import commentBox from 'commentbox.io';

class PageWithComments extends Component {

    componentDidMount() {
        this.removeCommentBox = commentBox('5687892684832768-proj');
    }

    componentWillUnmount() {

        this.removeCommentBox();
    }

    render() {

        return (
            <div className="commentbox" id={this.props.id} />
        );
    }
}

export default PageWithComments;