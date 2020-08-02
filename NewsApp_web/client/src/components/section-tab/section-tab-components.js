import React from 'react';
import Badge from 'react-bootstrap/Badge';
import './section-tab-styles.css';

class SectionTab extends React.Component {
    render() {
        if (this.props.section === "TECHNOLOGY") {
            return(<Badge className="tag_tech">{this.props.section}</Badge>);
        } else if (this.props.section === "WORLD") {
            return(<Badge className="tag_world">{this.props.section}</Badge>);
        } else if (this.props.section === "POLITICS") {
            return(<Badge className="tag_politics">{this.props.section}</Badge>);
        } else if (this.props.section === "BUSINESS") {
            return(<Badge className="tag_business">{this.props.section}</Badge>);
        } else if (this.props.section === "SPORTS" || this.props.section === "SPORT") {
            return(<Badge className="tag_sport">SPORTS</Badge>);
        } else if (this.props.section === "GUARDIAN") {
            return(<Badge className="tag_guar">{this.props.section}</Badge>);
        }else if (this.props.section === "NYTIMES") {
            return(<Badge className="tag_nyt">{this.props.section}</Badge>);
        } else {
            return(<Badge className="tag_health">{this.props.section}</Badge>);
        }
    }
}

export default SectionTab;
