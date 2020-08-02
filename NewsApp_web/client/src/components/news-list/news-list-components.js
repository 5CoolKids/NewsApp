import React, {Component} from 'react';
import { Link } from "react-router-dom";
import Container from 'react-bootstrap/Container';
import Row from 'react-bootstrap/Row';
import Col from 'react-bootstrap/Col';
import Card from 'react-bootstrap/Card';
import Popup from '../popup/popup-components.js';
import SectionTab from '../section-tab/section-tab-components';
import './news-list-styles.css';
import Truncate from 'react-truncate';

class NewsList extends Component {

  handleShare = (e) => {
    e.preventDefault();
  }

  render() {
    return (
      <div className='homePage'>
        {this.props.news.map(news => 
          <Link key={ news.id } to={`/article?id=${news.id}`} style={{ color: 'inherit', textDecoration: 'inherit'}}>
            <Container className='news_container' fluid>
              <Row>
                <Col md={3}>
                  <Card>
                    <Card.Img src={ news.image_url } className='news_image_container'/>
                  </Card>
                </Col>
                <Col md={9}>
                  <div>
                    <Card.Title>
                      <span className="bold_title">
                        { news.title }
                      </span>
                      <Popup news={ news } onClick={ this.handleShare } source={ "" }/>
                    </Card.Title>
                    <Card.Text>
                      <Truncate lines={3} ellipsis={<span>...</span>}>
                        { news.abstract }
                      </Truncate>
                    </Card.Text>
                    <Card.Subtitle>
                      <div className="italic_date">{ news.published_date.substring(0, 10) }</div>
                      <div className="section_tab"><SectionTab section={ news.section.toUpperCase() }/></div>
                    </Card.Subtitle>
                  </div>
                </Col>
              </Row>
            </Container> 
          </Link>  
        )}
      </div>
    )  
  }
}
export default NewsList;

