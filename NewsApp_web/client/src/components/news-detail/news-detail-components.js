import React from 'react';
import { EmailShareButton, FacebookShareButton, TwitterShareButton, EmailIcon, FacebookIcon, TwitterIcon} from "react-share";
import "./news-detail-styles.css";
import BookmarkSave from '../icon/bookmark-save-components';
import ReactTooltip from "react-tooltip";
import ExpandContent from "../icon/expand-components";

class NewsDetail extends React.Component {
    constructor() {
        super();
        this.state = {
            news_text: "",
            need_expand: false,
            before_expand_text: ""
        };
    }

    componentDidMount() {
        const content = `${this.props.news.description}`;
        const final = content.replace(/\n/gi, '\n\n');
        this.setState({ news_text: final });
        if (final.split(/[.!?]+\s/).filter(Boolean).length > 4) {
            this.setState({ need_expand: true }, () => console.log(this.state.need_expand));
            var cnt = 0;
            var i = 0;
            for (i; i < final.length; i++) {
                if (final.charAt(i) === '.' || final.charAt(i) === '!' || final.charAt(i) === '?') {
                    cnt++;
                }
                if (cnt >= 4) break;
            }
            this.setState({ before_expand_text: final.substring(0, i + 1) });
        }
    }

    render() {
        return (
            <div className="detail_container">
                <h2 className="title_container">{ this.props.news.title }</h2>
                <div className="info_container">
                    <div className="date_container">{ this.props.news.published_date }</div>
                    <div className="bookmarkIcon_container">
                        <BookmarkSave news={ this.props.news }/>
                    </div>
                    <div className="shareIcon_container">
                        <div className="share_but">
                            <FacebookShareButton className="share_icon"
                            url={this.props.news.web_url}
                            hashtag='#CSCI_571_NewsApp'
                            >  
                            <FacebookIcon size={28} round data-tip data-for='fb'/>
                            </FacebookShareButton>
                            <ReactTooltip id="fb" place="top">
                                Facebook
                            </ReactTooltip>
                        </div>
                        <div className="share_but">
                            <TwitterShareButton className="share_icon"
                            url={this.props.news.web_url}
                            hashtags={['CSCI_571_NewsApp']}
                            >
                            <TwitterIcon size={28} round data-tip data-for='tw'/>
                            </TwitterShareButton>
                            <ReactTooltip id="tw" place="top">
                                Twitter
                            </ReactTooltip>
                        </div>
                        <div className="share_but">
                            <EmailShareButton className="share_icon"
                            subject='#CSCI_571_NewsApp'
                            body={this.props.news.web_url}
                            >
                            <EmailIcon size={28} round data-tip data-for='email'/>
                            </EmailShareButton>
                            <ReactTooltip id="email" place="top">
                                Email
                            </ReactTooltip>
                        </div>
                    </div>         
                </div>
                <div className="image_container">
                    <img src={ this.props.news.image_url } alt='loading'/>
                </div>
                <>
                {(this.state.need_expand === false) ? (
                    <div className="content_container">
                        { this.state.news_text }
                    </div>
                ) : (
                    <div className="content_container">
                        <ExpandContent before={this.state.before_expand_text} after={this.state.news_text}/>
                    </div>
                )}
                </>
            </div>
        );
    }
}

export default NewsDetail;
