import React, { Component } from 'react';
import Card from 'react-bootstrap/Card';
import Row from 'react-bootstrap/Row';
import Col from 'react-bootstrap/Col';
import Popup from '../popup/popup-components.js';
import { Link } from "react-router-dom";
import SectionTab from '../section-tab/section-tab-components';
import Truncate from 'react-truncate';
import "../favoritescard/favorites-card-styles.css";

class ResultCard extends Component {

    hangdleShare = (e) => {
      e.preventDefault();
    }

    render() {
        return (
        <div className='page_container'>
            <h2 className="header_text">Results</h2>
            <Row>
                {this.props.news1.map(news => (
                    <Col key={ news.id } lg={3}>
                        <Link to={`/article?id=${news.id}`} style={{ color: 'inherit', textDecoration: 'inherit'}}>
                            <Card className='card_container'>
                                <Card.Body>
                                    <Card.Title>
                                        <Truncate className="title_text" lines={2} ellipsis={<span>...</span>}>
                                            { news.title }
                                        </Truncate>
                                        <Popup news={ news } onClick={ this.hangdleShare } source={ "" }/>
                                    </Card.Title>
                                    <Card.Img src={news.image_url} className="img_container"/>
                                    <Card.Text> 
                                        <span className="date_text">{news.published_date}</span> 
                                        <span className="section_tab"><SectionTab section={ news.section.toUpperCase() }/></span>
                                    </Card.Text>
                                </Card.Body>
                            </Card>
                        </Link>
                    </Col>
                ))}
                {this.props.news2.map(news => (
                    <Col key={ news.id } lg={3}>
                        <Link to={`/article?id=${news.id}`} style={{ color: 'inherit', textDecoration: 'inherit'}}>
                            <Card className='card_container'>
                                <Card.Body>
                                    <Card.Title>
                                        <Truncate className="title_text" lines={2} ellipsis={<span>...</span>}>
                                            { news.title }
                                        </Truncate>
                                        <Popup news={ news } onClick={ this.hangdleShare }/>
                                    </Card.Title>
                                    <Card.Img src={news.image_url} className="img_container"/>
                                    <Card.Text> 
                                        <span className="date_text">{news.published_date}</span> 
                                        <span className="section_tab"><SectionTab section={ news.section.toUpperCase() }/></span>
                                    </Card.Text>
                                </Card.Body>
                            </Card>
                        </Link>
                    </Col>
                ))}
            </Row>
        </div>
        )
    }
}

export default ResultCard;

