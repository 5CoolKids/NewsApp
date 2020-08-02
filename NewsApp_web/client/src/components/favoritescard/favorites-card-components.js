import React, { Component } from 'react';
import Card from 'react-bootstrap/Card';
import Row from 'react-bootstrap/Row';
import Col from 'react-bootstrap/Col';
import Popup from '../popup/popup-components.js';
import { Link } from "react-router-dom";
import SectionTab from '../section-tab/section-tab-components';
import "./favorites-card-styles.css";
import { MdDelete } from "react-icons/md";
import { toast, Zoom } from 'react-toastify';
import Truncate from 'react-truncate';
import 'react-toastify/dist/ReactToastify.css';

toast.configure({
    hideProgressBar: true,
    position: 'top-center',
    autoClose: 3000,
    transition: Zoom
});

class FavoritesCard extends Component {
    constructor() {
      super();
      this.state = { 
        display_news: [],
        size: 0
      };
    }

    componentDidMount() {
        var oldItems = JSON.parse(localStorage.getItem('itemsArray')) || [];
        var len = oldItems.length;
        this.setState({display_news: oldItems});
        this.setState({size : len});
    }

    handleShare = (e) => {
      e.preventDefault();
    }

    handleDelete = (e, web_url, title) => {
        e.preventDefault();
        var oldItems = JSON.parse(localStorage.getItem('itemsArray'));
        var updatedItems = [];
        for (var m in oldItems) {
          if (oldItems[m].web_url !== web_url) {
              updatedItems.push(oldItems[m]);
          }
        }
        toast(`Removing ${title}`);
        localStorage.setItem('itemsArray', JSON.stringify(updatedItems));
        var newLen = updatedItems.length;
        this.setState({display_news: updatedItems});
        this.setState({size : newLen});
    }

    render() {
        const size = this.state.size;
        return (
        <div className='page_container'>
            {size > 0 ? (
                <>
                <h2 className="header_text">Favorites</h2>
                <Row>
                    {this.state.display_news.map(news => (
                        <Col key={ news.id } lg={3}>
                            <Link to={`/article?id=${news.id}`} style={{ color: 'inherit', textDecoration: 'inherit'}}>
                                <Card className='card_container'>
                                    <Card.Body>
                                        <Card.Title>
                                            <Truncate className="title_text" lines={2} ellipsis={<span>...</span>}>
                                                { news.title }
                                            </Truncate>
                                            <Popup news={ news } onClick={ this.handleShare } source={ news.source.toUpperCase() }/>
                                            <MdDelete onClick={(e)=>{this.handleDelete(e, `${news.web_url}`, `${news.title}`)}}/>
                                        </Card.Title>
                                        <Card.Img src={news.image_url} className="img_container"/>
                                        <Card.Text> 
                                            <span className="date_text">{news.published_date}</span> 
                                            <span className="section_tab">
                                                <SectionTab section={ news.source }/> 
                                            </span>
                                            <span className="section_tab">
                                                <SectionTab section={ news.section.toUpperCase() }/> 
                                            </span>
                                        </Card.Text>
                                    </Card.Body>
                                </Card>
                            </Link>
                        </Col>
                    ))}
                </Row>
                </>
            ) : (
                <>
                <h3 className="no_saved">You have no saved articles</h3>
                </>
            )}
        </div>
        )
    }
}

export default FavoritesCard;

