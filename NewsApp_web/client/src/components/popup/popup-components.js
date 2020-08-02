import React, { Component } from 'react'; 
import { IoMdShare } from 'react-icons/io';
import Modal from 'react-bootstrap/Modal';
import { EmailShareButton, FacebookShareButton, TwitterShareButton, EmailIcon, FacebookIcon, TwitterIcon} from "react-share";
import './popup-styles.css';

class Popup extends Component {
  constructor() {
    super();
    this.state = {
      show: false
    };
  }

  handleShow = () => { 
    this.setState({
        show: true
    })
  }
  
  handleClose = () => { 
    this.setState({
        show: false
    })
  }

  render() {
    const source = this.props.source;
    return (
      <span onClick = {this.props.onClick}>
        <IoMdShare onClick={this.handleShow}/>
        <Modal show={this.state.show} onHide={this.handleClose}>
          <Modal.Header closeButton>
            <Modal.Title>
              {source !== "" ? (
                <div className="bold_source">{ source }</div>
              ) : (
                null
              )}    
              { this.props.news.title }
            </Modal.Title>
          </Modal.Header>
          <Modal.Body>
            <h4 className="bold_font">Share via</h4>
            <div className="share_but">
              <FacebookShareButton className="share_icon"
                url={this.props.news.web_url}
                hashtag='#CSCI_571_NewsApp'
              >  
                <FacebookIcon size={55} round />
              </FacebookShareButton>
            </div>
            <div className="share_but">
              <TwitterShareButton className="share_icon"
                url={this.props.news.web_url}
                hashtags={['CSCI_571_NewsApp']}
              >
                <TwitterIcon size={55} round />
              </TwitterShareButton>
            </div>
            <div className="share_but">
              <EmailShareButton className="share_icon"
                subject='#CSCI_571_NewsApp'
                body={this.props.news.web_url}
              >
                <EmailIcon size={55} round />
              </EmailShareButton>
            </div>
          </Modal.Body>
        </Modal> 
      </span>
    );
  }
}

export default Popup;
